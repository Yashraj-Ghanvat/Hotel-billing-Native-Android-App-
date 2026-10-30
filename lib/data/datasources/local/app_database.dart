import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/password_hasher.dart';

import 'tables/users_table.dart';
import 'tables/categories_table.dart';
import 'tables/menu_items_table.dart';
import 'tables/orders_table.dart';
import 'tables/order_items_table.dart';
import 'tables/bills_table.dart';
import 'tables/settings_table.dart';
import 'tables/day_close_table.dart';
import 'tables/restaurant_tables_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  Users,
  Categories,
  MenuItems,
  Orders,
  OrderItems,
  Bills,
  Settings,
  DayClose,
  RestaurantTables,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'hotel_billing_db',
      native: const DriftNativeOptions(
        shareAcrossIsolates: true,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seedDefaultData();
    },
  );

  /// Seeds default users, categories, tables, and settings
  Future<void> _seedDefaultData() async {
    // 1. Default Admin User (PIN: 1234)
    final adminSalt = PasswordHasher.generateSalt();
    final adminHash = PasswordHasher.hashPin('1234', adminSalt);
    await into(users).insert(UsersCompanion.insert(
      name: 'Admin',
      role: AppConstants.roleAdmin,
      pinHash: adminHash,
      salt: adminSalt,
    ));

    // 2. Default Cashier User (PIN: 5678)
    final cashierSalt = PasswordHasher.generateSalt();
    final cashierHash = PasswordHasher.hashPin('5678', cashierSalt);
    await into(users).insert(UsersCompanion.insert(
      name: 'Cashier 1',
      role: AppConstants.roleCashier,
      pinHash: cashierHash,
      salt: cashierSalt,
    ));

    // 3. Default Waiter User (PIN: 1111)
    final waiterSalt = PasswordHasher.generateSalt();
    final waiterHash = PasswordHasher.hashPin('1111', waiterSalt);
    await into(users).insert(UsersCompanion.insert(
      name: 'Waiter 1',
      role: AppConstants.roleWaiter,
      pinHash: waiterHash,
      salt: waiterSalt,
    ));

    // 4. Default Store Settings
    final defaultSettings = [
      SettingsCompanion.insert(key: AppConstants.keyHotelName, value: AppConstants.defaultHotelName),
      SettingsCompanion.insert(key: AppConstants.keyHotelAddress, value: AppConstants.defaultAddress),
      SettingsCompanion.insert(key: AppConstants.keyHotelPhone, value: AppConstants.defaultPhone),
      SettingsCompanion.insert(key: AppConstants.keyGSTIN, value: AppConstants.defaultGSTIN),
      SettingsCompanion.insert(key: AppConstants.keyFSSAI, value: AppConstants.defaultFSSAI),
      SettingsCompanion.insert(key: AppConstants.keyDefaultTaxRate, value: AppConstants.defaultTaxRateVal.toString()),
      SettingsCompanion.insert(key: AppConstants.keyCurrencySymbol, value: AppConstants.defaultCurrencySymbol),
      SettingsCompanion.insert(key: AppConstants.keyInvoicePrefix, value: AppConstants.defaultInvoicePrefix),
      SettingsCompanion.insert(key: AppConstants.keyPaperWidth, value: AppConstants.defaultPaperWidth),
      SettingsCompanion.insert(key: AppConstants.keyPrinterType, value: AppConstants.defaultPrinterType),
      SettingsCompanion.insert(key: AppConstants.keyPrinterIp, value: AppConstants.defaultPrinterIp),
      SettingsCompanion.insert(key: AppConstants.keyPrinterPort, value: AppConstants.defaultPrinterPort),
      SettingsCompanion.insert(key: AppConstants.keyIsCompositionScheme, value: 'false'),
      SettingsCompanion.insert(key: AppConstants.keyTaxInclusive, value: 'false'),
    ];
    for (var s in defaultSettings) {
      await into(settings).insertOnConflictUpdate(s);
    }

    // 5. Default Restaurant Tables (T-1 to T-6)
    for (int i = 1; i <= 6; i++) {
      await into(restaurantTables).insert(RestaurantTablesCompanion.insert(
        tableNo: 'T-$i',
        capacity: Value(i <= 2 ? 2 : (i <= 4 ? 4 : 6)),
        displayOrder: Value(i),
      ));
    }

    // 6. Default Categories & Sample Menu Items
    final startersId = await into(categories).insert(CategoriesCompanion.insert(name: 'Starters', displayOrder: const Value(1)));
    final mainsId = await into(categories).insert(CategoriesCompanion.insert(name: 'Main Course', displayOrder: const Value(2)));
    final beveragesId = await into(categories).insert(CategoriesCompanion.insert(name: 'Beverages', displayOrder: const Value(3)));
    final dessertsId = await into(categories).insert(CategoriesCompanion.insert(name: 'Desserts', displayOrder: const Value(4)));

    // Starters
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: startersId, name: 'Paneer Tikka', price: 240.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: startersId, name: 'Chicken 65', price: 280.0, isVeg: const Value(false), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: startersId, name: 'Veg Manchurian', price: 190.0, isVeg: const Value(true), hsnCode: const Value('2106')));

    // Main Course
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: mainsId, name: 'Butter Chicken', price: 340.0, isVeg: const Value(false), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: mainsId, name: 'Paneer Butter Masala', price: 290.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: mainsId, name: 'Dal Makhani', price: 220.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: mainsId, name: 'Butter Naan', price: 50.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: mainsId, name: 'Jeera Rice', price: 160.0, isVeg: const Value(true), hsnCode: const Value('2106')));

    // Beverages
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: beveragesId, name: 'Masala Chai', price: 30.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: beveragesId, name: 'Cold Coffee', price: 90.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: beveragesId, name: 'Fresh Lime Soda', price: 60.0, isVeg: const Value(true), hsnCode: const Value('2106')));

    // Desserts
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: dessertsId, name: 'Gulab Jamun (2 pcs)', price: 80.0, isVeg: const Value(true), hsnCode: const Value('2106')));
    await into(menuItems).insert(MenuItemsCompanion.insert(categoryId: dessertsId, name: 'Sizzling Brownie', price: 180.0, isVeg: const Value(true), hsnCode: const Value('2106')));
  }
}
