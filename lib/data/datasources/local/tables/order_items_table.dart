import 'package:drift/drift.dart';
import 'orders_table.dart';
import 'menu_items_table.dart';

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id, onDelete: KeyAction.cascade)();
  IntColumn get itemId => integer().references(MenuItems, #id)();
  IntColumn get quantity => integer()();
  RealColumn get priceAtOrder => real()();
  RealColumn get taxRateAtOrder => real().withDefault(const Constant(5.0))();
  TextColumn get notes => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))(); // 'pending', 'kot_sent', 'served', 'cancelled'
  IntColumn get kotPrintedQuantity => integer().withDefault(const Constant(0))();
}
