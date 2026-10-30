// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bills_dao.dart';

// ignore_for_file: type=lint
mixin _$BillsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BillsTable get bills => attachedDatabase.bills;
  $OrdersTable get orders => attachedDatabase.orders;
  BillsDaoManager get managers => BillsDaoManager(this);
}

class BillsDaoManager {
  final _$BillsDaoMixin _db;
  BillsDaoManager(this._db);
  $$BillsTableTableManager get bills =>
      $$BillsTableTableManager(_db.attachedDatabase, _db.bills);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db.attachedDatabase, _db.orders);
}
