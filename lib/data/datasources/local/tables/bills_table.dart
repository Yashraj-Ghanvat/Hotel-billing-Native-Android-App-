import 'package:drift/drift.dart';
import 'orders_table.dart';
import 'users_table.dart';

class Bills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id)();
  TextColumn get billNo => text().unique()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  TextColumn get discountType => text().withDefault(const Constant('flat'))();
  RealColumn get taxAmount => real()();
  RealColumn get cgstAmount => real().withDefault(const Constant(0.0))();
  RealColumn get sgstAmount => real().withDefault(const Constant(0.0))();
  RealColumn get roundOff => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
  TextColumn get paymentMode => text()(); // 'cash', 'card', 'upi', 'split'
  BoolColumn get isVoid => boolean().withDefault(const Constant(false))();
  TextColumn get voidReason => text().nullable()();
  IntColumn get voidByUserId => integer().nullable().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
