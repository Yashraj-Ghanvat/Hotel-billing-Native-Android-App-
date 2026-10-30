import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import '../../data/datasources/local/daos/users_dao.dart';
import '../../data/datasources/local/daos/menu_dao.dart';
import '../../data/datasources/local/daos/orders_dao.dart';
import '../../data/datasources/local/daos/bills_dao.dart';
import '../../data/datasources/local/daos/settings_dao.dart';
import '../../data/datasources/local/daos/tables_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final usersDaoProvider = Provider<UsersDao>((ref) {
  return UsersDao(ref.watch(databaseProvider));
});

final menuDaoProvider = Provider<MenuDao>((ref) {
  return MenuDao(ref.watch(databaseProvider));
});

final ordersDaoProvider = Provider<OrdersDao>((ref) {
  return OrdersDao(ref.watch(databaseProvider));
});

final billsDaoProvider = Provider<BillsDao>((ref) {
  return BillsDao(ref.watch(databaseProvider));
});

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return SettingsDao(ref.watch(databaseProvider));
});

final tablesDaoProvider = Provider<TablesDao>((ref) {
  return TablesDao(ref.watch(databaseProvider));
});
