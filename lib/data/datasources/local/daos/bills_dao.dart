import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/bills_table.dart';
import '../tables/orders_table.dart';
import '../../../../core/utils/invoice_number_generator.dart';

part 'bills_dao.g.dart';

@DriftAccessor(tables: [Bills, Orders])
class BillsDao extends DatabaseAccessor<AppDatabase> with _$BillsDaoMixin {
  BillsDao(AppDatabase db) : super(db);

  Stream<List<Bill>> watchBillsForDateRange(DateTime start, DateTime end) {
    return (select(bills)
      ..where((b) => b.createdAt.isBetweenValues(start, end))
      ..orderBy([(b) => OrderingTerm(expression: b.id, mode: OrderingMode.desc)]))
        .watch();
  }

  Future<List<Bill>> getBillsForDateRange(DateTime start, DateTime end) {
    return (select(bills)
      ..where((b) => b.createdAt.isBetweenValues(start, end))
      ..orderBy([(b) => OrderingTerm(expression: b.id, mode: OrderingMode.desc)]))
        .get();
  }

  Future<Bill?> getBillByOrderId(int orderId) {
    return (select(bills)..where((b) => b.orderId.equals(orderId))).getSingleOrNull();
  }

  /// Generates the next sequential invoice number in current financial year
  Future<String> generateNextInvoiceNumber(String prefix) async {
    final fyCode = InvoiceNumberGenerator.getFinancialYearCode();
    final searchPattern = '$prefix-$fyCode-%';

    final latestBill = await (select(bills)
      ..where((b) => b.billNo.like(searchPattern))
      ..orderBy([(b) => OrderingTerm(expression: b.id, mode: OrderingMode.desc)])
      ..limit(1))
        .getSingleOrNull();

    int nextSeq = 1;
    if (latestBill != null) {
      final parts = latestBill.billNo.split('-');
      if (parts.length >= 3) {
        final lastSeq = int.tryParse(parts.last) ?? 0;
        nextSeq = lastSeq + 1;
      }
    }

    return InvoiceNumberGenerator.formatInvoiceNumber(prefix: prefix, sequence: nextSeq);
  }

  /// Finalize Bill and update order status atomically
  Future<Bill> createBillTransaction({
    required int orderId,
    required String invoicePrefix,
    required double subtotal,
    required double discount,
    required String discountType,
    required double taxAmount,
    required double cgstAmount,
    required double sgstAmount,
    required double roundOff,
    required double total,
    required String paymentMode,
  }) async {
    return transaction(() async {
      final billNo = await generateNextInvoiceNumber(invoicePrefix);

      final billId = await into(bills).insert(BillsCompanion.insert(
        orderId: orderId,
        billNo: billNo,
        subtotal: subtotal,
        discount: Value(discount),
        discountType: Value(discountType),
        taxAmount: taxAmount,
        cgstAmount: Value(cgstAmount),
        sgstAmount: Value(sgstAmount),
        roundOff: Value(roundOff),
        total: total,
        paymentMode: paymentMode,
      ));

      // Mark Order as Paid
      await (update(orders)..where((o) => o.id.equals(orderId))).write(
        OrdersCompanion(
          status: const Value('paid'),
          updatedAt: Value(DateTime.now()),
        ),
      );

      return (select(bills)..where((b) => b.id.equals(billId))).getSingle();
    });
  }

  /// Void a bill with reason and admin ID
  Future<void> voidBill(int billId, String reason, int adminUserId) async {
    return transaction(() async {
      await (update(bills)..where((b) => b.id.equals(billId))).write(
        BillsCompanion(
          isVoid: const Value(true),
          voidReason: Value(reason),
          voidByUserId: Value(adminUserId),
        ),
      );
    });
  }
}
