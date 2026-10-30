import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/orders_table.dart';
import '../tables/order_items_table.dart';
import '../tables/menu_items_table.dart';

part 'orders_dao.g.dart';

class OrderItemWithDetail {
  final OrderItem orderItem;
  final MenuItem menuItem;

  OrderItemWithDetail({required this.orderItem, required this.menuItem});
}

class TokenOrderWithItems {
  final Order order;
  final List<OrderItemWithDetail> items;

  TokenOrderWithItems({required this.order, required this.items});

  double get totalAmount {
    double total = 0.0;
    for (var item in items) {
      total += item.orderItem.quantity * item.orderItem.priceAtOrder;
    }
    return total;
  }
}

@DriftAccessor(tables: [Orders, OrderItems, MenuItems])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  OrdersDao(AppDatabase db) : super(db);

  /// Watch active token orders created today
  Stream<List<Order>> watchTodayOrders() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return (select(orders)
      ..where((o) => o.createdAt.isBetweenValues(startOfDay, endOfDay) & o.status.isNotIn(['cancelled']))
      ..orderBy([(o) => OrderingTerm(expression: o.id, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<Order?> getOrderById(int orderId) {
    return (select(orders)..where((o) => o.id.equals(orderId))).getSingleOrNull();
  }

  /// Watch items with menu details for an order
  Stream<List<OrderItemWithDetail>> watchOrderItemsWithDetail(int orderId) {
    final query = select(orderItems).join([
      innerJoin(menuItems, menuItems.id.equalsExp(orderItems.itemId)),
    ])..where(orderItems.orderId.equals(orderId));

    return query.watch().map((rows) {
      return rows.map((row) {
        return OrderItemWithDetail(
          orderItem: row.readTable(orderItems),
          menuItem: row.readTable(menuItems),
        );
      }).toList();
    });
  }

  Future<List<OrderItemWithDetail>> getOrderItemsWithDetail(int orderId) {
    final query = select(orderItems).join([
      innerJoin(menuItems, menuItems.id.equalsExp(orderItems.itemId)),
    ])..where(orderItems.orderId.equals(orderId));

    return query.get().then((rows) {
      return rows.map((row) {
        return OrderItemWithDetail(
          orderItem: row.readTable(orderItems),
          menuItem: row.readTable(menuItems),
        );
      }).toList();
    });
  }

  /// Calculates the next daily token number (#001, #002...) for today
  Future<int> getNextTokenNumberToday() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final todayOrdersCount = await (select(orders)
      ..where((o) => o.createdAt.isBetweenValues(startOfDay, endOfDay)))
        .get();

    return todayOrdersCount.length + 1;
  }

  /// Creates a new Token Order
  Future<int> createTokenOrder({
    required int waiterId,
    required String orderType, // 'takeaway' or 'dine_in'
  }) async {
    return transaction(() async {
      final tokenNo = await getNextTokenNumberToday();

      final orderId = await into(orders).insert(OrdersCompanion.insert(
        tokenNo: Value(tokenNo),
        orderType: Value(orderType),
        tokenStatus: const Value('preparing'),
        waiterId: waiterId,
        status: const Value('open'),
      ));

      return orderId;
    });
  }

  /// Update Token Status ('preparing', 'ready', 'completed')
  Future<void> updateTokenStatus(int orderId, String status) async {
    await (update(orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(
        tokenStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Update Order Type ('takeaway' vs 'dine_in')
  Future<void> updateOrderType(int orderId, String orderType) async {
    await (update(orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(
        orderType: Value(orderType),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Adds or updates item in order
  Future<void> addOrUpdateOrderItem({
    required int orderId,
    required MenuItem menuItem,
    required int quantityDelta,
    String? notes,
  }) async {
    return transaction(() async {
      final existingItem = await (select(orderItems)
        ..where((i) => i.orderId.equals(orderId) & i.itemId.equals(menuItem.id)))
          .getSingleOrNull();

      if (existingItem != null) {
        final newQty = existingItem.quantity + quantityDelta;
        if (newQty <= 0) {
          await (delete(orderItems)..where((i) => i.id.equals(existingItem.id))).go();
        } else {
          await (update(orderItems)..where((i) => i.id.equals(existingItem.id))).write(
            OrderItemsCompanion(
              quantity: Value(newQty),
              notes: Value(notes ?? existingItem.notes),
            ),
          );
        }
      } else if (quantityDelta > 0) {
        await into(orderItems).insert(OrderItemsCompanion.insert(
          orderId: orderId,
          itemId: menuItem.id,
          quantity: quantityDelta,
          priceAtOrder: menuItem.price,
          taxRateAtOrder: Value(menuItem.taxRate),
          notes: Value(notes),
        ));
      }
    });
  }

  /// Updates kotPrintedQuantity after printing KOT
  Future<void> markKotItemsPrinted(int orderId) async {
    return transaction(() async {
      final items = await (select(orderItems)..where((i) => i.orderId.equals(orderId))).get();
      for (var item in items) {
        if (item.quantity > item.kotPrintedQuantity) {
          await (update(orderItems)..where((i) => i.id.equals(item.id))).write(
            OrderItemsCompanion(
              kotPrintedQuantity: Value(item.quantity),
              status: const Value('kot_sent'),
            ),
          );
        }
      }
    });
  }

  /// Cancels an order
  Future<void> cancelOrder(int orderId) async {
    await (update(orders)..where((o) => o.id.equals(orderId))).write(
      OrdersCompanion(
        status: const Value('cancelled'),
        tokenStatus: const Value('completed'),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
