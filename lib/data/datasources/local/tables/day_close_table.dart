import 'package:drift/drift.dart';

class DayClose extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime()();
  RealColumn get openingCash => real()();
  RealColumn get closingCash => real()();
  RealColumn get totalSales => real()();
  IntColumn get totalOrders => integer()();
  RealColumn get discrepancy => real()();
  TextColumn get closedByUserId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
