import 'package:drift/drift.dart';
import 'users_table.dart';

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tokenNo => integer().withDefault(const Constant(1))();
  TextColumn get orderType => text().withDefault(const Constant('takeaway'))(); // 'takeaway' or 'dine_in'
  TextColumn get tokenStatus => text().withDefault(const Constant('preparing'))(); // 'preparing', 'ready', 'completed'
  IntColumn get waiterId => integer().references(Users, #id)();
  TextColumn get status => text().withDefault(const Constant('open'))(); // 'open', 'billed', 'paid', 'cancelled'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
