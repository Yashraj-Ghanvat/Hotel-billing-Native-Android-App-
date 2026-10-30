import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import 'database_provider.dart';

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  final menuDao = ref.watch(menuDaoProvider);
  return menuDao.watchActiveCategories();
});

final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

final menuSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredMenuItemsStreamProvider = StreamProvider<List<MenuItem>>((ref) {
  final menuDao = ref.watch(menuDaoProvider);
  final catId = ref.watch(selectedCategoryIdProvider);
  final query = ref.watch(menuSearchQueryProvider);
  return menuDao.watchMenuItems(categoryId: catId, searchQuery: query, includeInactive: false);
});

final allMenuItemsManagementStreamProvider = StreamProvider<List<MenuItem>>((ref) {
  final menuDao = ref.watch(menuDaoProvider);
  final query = ref.watch(menuSearchQueryProvider);
  return menuDao.watchMenuItems(searchQuery: query, includeInactive: true);
});
