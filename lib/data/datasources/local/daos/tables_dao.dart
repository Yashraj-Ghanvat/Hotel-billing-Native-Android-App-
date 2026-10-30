import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/restaurant_tables_table.dart';

part 'tables_dao.g.dart';

@DriftAccessor(tables: [RestaurantTables])
class TablesDao extends DatabaseAccessor<AppDatabase> with _$TablesDaoMixin {
  TablesDao(AppDatabase db) : super(db);

  Stream<List<RestaurantTable>> watchAllTables() {
    return (select(restaurantTables)..orderBy([(t) => OrderingTerm(expression: t.displayOrder)])).watch();
  }

  Future<List<RestaurantTable>> getAllTables() {
    return (select(restaurantTables)..orderBy([(t) => OrderingTerm(expression: t.displayOrder)])).get();
  }

  Future<RestaurantTable?> getTableById(int id) {
    return (select(restaurantTables)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<int> createTable(RestaurantTablesCompanion table) => into(restaurantTables).insert(table);

  Future<bool> updateTable(RestaurantTable table) => update(restaurantTables).replace(table);

  Future<int> deleteTable(int id) {
    return (delete(restaurantTables)..where((t) => t.id.equals(id))).go();
  }

  Future<int> updateTableStatus(int tableId, String status, {int? orderId}) {
    return (update(restaurantTables)..where((t) => t.id.equals(tableId))).write(
      RestaurantTablesCompanion(
        status: Value(status),
        currentOrderId: Value(orderId),
      ),
    );
  }

  /// Transaction to merge source table into target table
  Future<void> mergeTables(int sourceTableId, int targetTableId) async {
    return transaction(() async {
      final sourceTable = await getTableById(sourceTableId);
      final targetTable = await getTableById(targetTableId);
      if (sourceTable != null && targetTable != null && sourceTable.currentOrderId != null) {
        // If target table has no active order, move order
        if (targetTable.currentOrderId == null) {
          await updateTableStatus(targetTableId, 'occupied', orderId: sourceTable.currentOrderId);
          await updateTableStatus(sourceTableId, 'available', orderId: null);
        }
      }
    });
  }
}
