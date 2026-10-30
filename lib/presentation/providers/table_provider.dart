import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/app_database.dart';
import 'database_provider.dart';

final selectedTableIdProvider = StateProvider<int?>((ref) => null);

final tablesStreamProvider = StreamProvider<List<RestaurantTable>>((ref) {
  final tablesDao = ref.watch(tablesDaoProvider);
  return tablesDao.watchAllTables();
});
