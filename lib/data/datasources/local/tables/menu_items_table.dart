import 'package:drift/drift.dart';
import 'categories_table.dart';

class MenuItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get price => real()();
  RealColumn get taxRate => real().withDefault(const Constant(5.0))();
  TextColumn get hsnCode => text().nullable()();
  BoolColumn get isVeg => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}
