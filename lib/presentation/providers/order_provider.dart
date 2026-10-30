import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/daos/orders_dao.dart';
import '../../domain/models/kot_ticket.dart';
import 'database_provider.dart';
import 'auth_provider.dart';

final selectedOrderIdProvider = StateProvider<int?>((ref) => null);

final todayOrdersStreamProvider = StreamProvider<List<Order>>((ref) {
  final ordersDao = ref.watch(ordersDaoProvider);
  return ordersDao.watchTodayOrders();
});

final activeOrderStreamProvider = StreamProvider<Order?>((ref) async* {
  final orderId = ref.watch(selectedOrderIdProvider);
  if (orderId == null) {
    yield null;
    return;
  }
  final ordersDao = ref.watch(ordersDaoProvider);
  final order = await ordersDao.getOrderById(orderId);
  yield order;
});

final orderItemsStreamProvider = StreamProvider<List<OrderItemWithDetail>>((ref) {
  final orderId = ref.watch(selectedOrderIdProvider);
  if (orderId == null) return Stream.value([]);
  final ordersDao = ref.watch(ordersDaoProvider);
  return ordersDao.watchOrderItemsWithDetail(orderId);
});

class OrderController {
  final Ref ref;

  OrderController(this.ref);

  /// Creates a new Token Order
  Future<int> createNewTokenOrder({String orderType = 'takeaway'}) async {
    final ordersDao = ref.read(ordersDaoProvider);
    final user = ref.read(authProvider);

    final orderId = await ordersDao.createTokenOrder(
      waiterId: user?.id ?? 1,
      orderType: orderType,
    );

    ref.read(selectedOrderIdProvider.notifier).state = orderId;
    return orderId;
  }

  /// Ensures active order exists or creates a new one
  Future<int> getOrCreateActiveOrder({String orderType = 'takeaway'}) async {
    final selectedId = ref.read(selectedOrderIdProvider);
    if (selectedId != null) {
      final ordersDao = ref.read(ordersDaoProvider);
      final existing = await ordersDao.getOrderById(selectedId);
      if (existing != null && existing.status == 'open') {
        return existing.id;
      }
    }
    return await createNewTokenOrder(orderType: orderType);
  }

  /// Adds or updates item quantity in active token order
  Future<void> updateItemQuantity({
    required MenuItem menuItem,
    required int quantityDelta,
    String? notes,
  }) async {
    final ordersDao = ref.read(ordersDaoProvider);
    final orderId = await getOrCreateActiveOrder();

    await ordersDao.addOrUpdateOrderItem(
      orderId: orderId,
      menuItem: menuItem,
      quantityDelta: quantityDelta,
      notes: notes,
    );
  }

  /// Generates KotTicket payload for unprinted item quantities
  Future<KotTicket?> prepareKotTicket(int orderId) async {
    final ordersDao = ref.read(ordersDaoProvider);
    final user = ref.read(authProvider);
    final order = await ordersDao.getOrderById(orderId);
    if (order == null) return null;

    final items = await ordersDao.getOrderItemsWithDetail(orderId);

    final unprintedItems = <KotItem>[];
    bool hasPreviousPrints = false;

    for (var item in items) {
      if (item.orderItem.kotPrintedQuantity > 0) {
        hasPreviousPrints = true;
      }
      final deltaQty = item.orderItem.quantity - item.orderItem.kotPrintedQuantity;
      if (deltaQty > 0) {
        unprintedItems.add(KotItem(
          name: item.menuItem.name,
          quantity: deltaQty,
          notes: item.orderItem.notes,
        ));
      }
    }

    if (unprintedItems.isEmpty) return null;

    return KotTicket(
      orderId: orderId,
      tokenNo: order.tokenNo,
      orderType: order.orderType,
      waiterName: user?.name ?? 'Staff',
      timestamp: DateTime.now(),
      isAdditionKot: hasPreviousPrints,
      items: unprintedItems,
    );
  }

  /// Marks unprinted KOT items as printed
  Future<void> confirmKotPrinted(int orderId) async {
    final ordersDao = ref.read(ordersDaoProvider);
    await ordersDao.markKotItemsPrinted(orderId);
  }
}

final orderControllerProvider = Provider<OrderController>((ref) => OrderController(ref));
