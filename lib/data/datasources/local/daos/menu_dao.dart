import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/categories_table.dart';
import '../tables/menu_items_table.dart';

part 'menu_dao.g.dart';

@DriftAccessor(tables: [Categories, MenuItems])
class MenuDao extends DatabaseAccessor<AppDatabase> with _$MenuDaoMixin {
  MenuDao(AppDatabase db) : super(db);

  // --- Categories ---
  Stream<List<Category>> watchActiveCategories() {
    return (select(categories)
      ..where((c) => c.isActive.equals(true))
      ..orderBy([(c) => OrderingTerm(expression: c.displayOrder)]))
        .watch();
  }

  Future<List<Category>> getAllCategories() {
    return (select(categories)..orderBy([(c) => OrderingTerm(expression: c.displayOrder)])).get();
  }

  Future<int> createCategory(CategoriesCompanion category) => into(categories).insert(category);
  Future<bool> updateCategory(Category category) => update(categories).replace(category);

  // --- Menu Items ---
  Stream<List<MenuItem>> watchMenuItems({int? categoryId, String? searchQuery, bool includeInactive = false}) {
    final query = select(menuItems);
    if (!includeInactive) {
      query.where((m) => m.isActive.equals(true));
    }
    if (categoryId != null) {
      query.where((m) => m.categoryId.equals(categoryId));
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      query.where((m) => m.name.like('%${searchQuery.trim()}%'));
    }
    return query.watch();
  }

  Future<List<MenuItem>> getMenuItems({int? categoryId, bool includeInactive = false}) {
    final query = select(menuItems);
    if (!includeInactive) {
      query.where((m) => m.isActive.equals(true));
    }
    if (categoryId != null) {
      query.where((m) => m.categoryId.equals(categoryId));
    }
    return query.get();
  }

  Future<MenuItem?> getMenuItemById(int id) {
    return (select(menuItems)..where((m) => m.id.equals(id))).getSingleOrNull();
  }

  Future<int> createMenuItem(MenuItemsCompanion item) => into(menuItems).insert(item);
  Future<bool> updateMenuItem(MenuItem item) => update(menuItems).replace(item);
  Future<int> toggleMenuItemActive(int id, bool isActive) {
    return (update(menuItems)..where((m) => m.id.equals(id))).write(
      MenuItemsCompanion(isActive: Value(isActive)),
    );
  }
}
