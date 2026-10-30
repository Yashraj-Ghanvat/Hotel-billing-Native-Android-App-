import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 2, max: 50)();
  TextColumn get role => text()(); // 'admin', 'cashier', 'waiter'
  TextColumn get pinHash => text()();
  TextColumn get salt => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
