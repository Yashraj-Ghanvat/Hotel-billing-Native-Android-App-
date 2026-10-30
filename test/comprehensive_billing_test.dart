import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:hotel_billing_app/core/utils/password_hasher.dart';
import 'package:hotel_billing_app/core/utils/invoice_number_generator.dart';
import 'package:hotel_billing_app/core/utils/tax_calculator.dart';
import 'package:hotel_billing_app/data/datasources/local/app_database.dart';
import 'package:hotel_billing_app/data/datasources/local/daos/users_dao.dart';
import 'package:hotel_billing_app/data/datasources/local/daos/menu_dao.dart';
import 'package:hotel_billing_app/data/datasources/local/daos/orders_dao.dart';
import 'package:hotel_billing_app/data/datasources/local/daos/bills_dao.dart';
import 'package:hotel_billing_app/services/backup_restore_service.dart';

void main() {
  late AppDatabase db;
  late UsersDao usersDao;
  late MenuDao menuDao;
  late OrdersDao ordersDao;
  late BillsDao billsDao;

  setUp(() async {
    // In-Memory SQLite database for fast real database testing
    db = AppDatabase(NativeDatabase.memory());
    usersDao = UsersDao(db);
    menuDao = MenuDao(db);
    ordersDao = OrdersDao(db);
    billsDao = BillsDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('1. Security & Authentication Tests', () {
    test('Salted SHA-256 PIN Hashing and Verification', () {
      final salt = PasswordHasher.generateSalt();
      final hash = PasswordHasher.hashPin('1234', salt);

      expect(PasswordHasher.verifyPin('1234', hash, salt), isTrue);
      expect(PasswordHasher.verifyPin('9999', hash, salt), isFalse);
    });
  });

  group('2. Financial Year Invoice Number Generator Tests', () {
    test('Invoice Number Formatting with FY 2026-27', () {
      final aprilDate = DateTime(2026, 4, 15);
      final fyCode = InvoiceNumberGenerator.getFinancialYearCode(aprilDate);
      expect(fyCode, '2627');

      final invNo = InvoiceNumberGenerator.formatInvoiceNumber(
        prefix: 'INV',
        sequence: 42,
        date: aprilDate,
      );
      expect(invNo, 'INV-2627-00042');
    });

    test('Invoice Number Financial Year Before April (March 2026)', () {
      final marchDate = DateTime(2026, 3, 10);
      final fyCode = InvoiceNumberGenerator.getFinancialYearCode(marchDate);
      expect(fyCode, '2526');
    });
  });

  group('3. Tax & Billing Engine Tests', () {
    test('CGST (2.5%) + SGST (2.5%) Split Calculation', () {
      final breakup = TaxCalculator.calculate(
        subtotal: 2000.0,
        discountVal: 10.0,
        discountType: 'percent', // 10% discount = 200 rs
        defaultTaxRate: 5.0,
        isTaxInclusive: false,
        isCompositionScheme: false,
      );

      expect(breakup.subtotal, 2000.0);
      expect(breakup.discountAmount, 200.0);
      expect(breakup.taxableAmount, 1800.0);
      expect(breakup.cgstRate, 2.5);
      expect(breakup.cgstAmount, 45.0);
      expect(breakup.sgstRate, 2.5);
      expect(breakup.sgstAmount, 45.0);
      expect(breakup.totalTax, 90.0);
      expect(breakup.grandTotal, 1890.0);
    });

    test('Composition Scheme (Bill of Supply) displays zero tax', () {
      final breakup = TaxCalculator.calculate(
        subtotal: 1500.0,
        discountVal: 0.0,
        discountType: 'flat',
        defaultTaxRate: 5.0,
        isTaxInclusive: false,
        isCompositionScheme: true,
      );

      expect(breakup.cgstAmount, 0.0);
      expect(breakup.sgstAmount, 0.0);
      expect(breakup.totalTax, 0.0);
      expect(breakup.grandTotal, 1500.0);
    });
  });

  group('4. Token System & DAO Integration Tests', () {
    test('Initial Seed Data Loaded (Default Users & Categories)', () async {
      final activeUsers = await usersDao.getAllActiveUsers();
      expect(activeUsers.length, greaterThanOrEqualTo(3)); // Admin, Cashier, Waiter

      final categories = await menuDao.getAllCategories();
      expect(categories.length, greaterThanOrEqualTo(4)); // Starters, Main Course, Beverages, Desserts
    });

    test('Daily Token Generation and Incremental Token Numbers', () async {
      final token1Id = await ordersDao.createTokenOrder(waiterId: 1, orderType: 'takeaway');
      final order1 = await ordersDao.getOrderById(token1Id);
      expect(order1?.tokenNo, 1);
      expect(order1?.orderType, 'takeaway');
      expect(order1?.tokenStatus, 'preparing');

      final token2Id = await ordersDao.createTokenOrder(waiterId: 1, orderType: 'dine_in');
      final order2 = await ordersDao.getOrderById(token2Id);
      expect(order2?.tokenNo, 2);
      expect(order2?.orderType, 'dine_in');
    });

    test('Token Order Item Addition & Status Lifecycle', () async {
      final orderId = await ordersDao.createTokenOrder(waiterId: 1, orderType: 'takeaway');
      final menuItems = await menuDao.getMenuItems();
      final paneerTikka = menuItems.first;

      await ordersDao.addOrUpdateOrderItem(
        orderId: orderId,
        menuItem: paneerTikka,
        quantityDelta: 2,
      );

      final orderItems = await ordersDao.getOrderItemsWithDetail(orderId);
      expect(orderItems.length, 1);
      expect(orderItems.first.orderItem.quantity, 2);

      // Update Token Status to Ready
      await ordersDao.updateTokenStatus(orderId, 'ready');
      var updatedOrder = await ordersDao.getOrderById(orderId);
      expect(updatedOrder?.tokenStatus, 'ready');

      // Update Token Status to Completed
      await ordersDao.updateTokenStatus(orderId, 'completed');
      updatedOrder = await ordersDao.getOrderById(orderId);
      expect(updatedOrder?.tokenStatus, 'completed');
    });

    test('Bill Settlement Transaction for Token Order', () async {
      final orderId = await ordersDao.createTokenOrder(waiterId: 1, orderType: 'takeaway');
      final menuItems = await menuDao.getMenuItems();
      await ordersDao.addOrUpdateOrderItem(orderId: orderId, menuItem: menuItems.first, quantityDelta: 2);

      // Settle Bill
      final bill = await billsDao.createBillTransaction(
        orderId: orderId,
        invoicePrefix: 'INV',
        subtotal: 480.0,
        discount: 0.0,
        discountType: 'flat',
        taxAmount: 24.0,
        cgstAmount: 12.0,
        sgstAmount: 12.0,
        roundOff: 0.0,
        total: 504.0,
        paymentMode: 'upi',
      );

      expect(bill.total, 504.0);
      expect(bill.paymentMode, 'upi');
      expect(bill.billNo, contains('INV-'));

      final paidOrder = await ordersDao.getOrderById(orderId);
      expect(paidOrder?.status, 'paid');
    });

    test('Full JSON Database Export & Restoration', () async {
      final backupService = BackupRestoreService(db);
      final jsonStr = await backupService.exportToJson();

      expect(jsonStr, contains('"users"'));
      expect(jsonStr, contains('"categories"'));
      expect(jsonStr, contains('"menuItems"'));
      expect(jsonStr, contains('"settings"'));

      final restoreSuccess = await backupService.restoreFromJson(jsonStr);
      expect(restoreSuccess, isTrue);
    });
  });
}
