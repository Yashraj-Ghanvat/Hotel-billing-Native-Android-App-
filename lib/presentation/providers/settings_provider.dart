import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final settingsStreamProvider = StreamProvider<Map<String, String>>((ref) {
  final settingsDao = ref.watch(settingsDaoProvider);
  return settingsDao.watchAllSettings();
});
