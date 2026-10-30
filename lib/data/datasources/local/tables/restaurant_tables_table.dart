import 'package:drift/drift.dart';
import 'orders_table.dart';

@DataClassName('RestaurantTable')
class RestaurantTables extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get tableNo => text().unique()();
  IntColumn get capacity => integer().withDefault(const Constant(4))();
  TextColumn get status => text().withDefault(const Constant('available'))(); // 'available', 'occupied', 'billed', 'reserved'
  IntColumn get currentOrderId => integer().nullable().references(Orders, #id)();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
}
