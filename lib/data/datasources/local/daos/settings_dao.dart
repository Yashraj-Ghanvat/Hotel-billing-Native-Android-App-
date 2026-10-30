import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/settings_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(AppDatabase db) : super(db);

  Stream<Map<String, String>> watchAllSettings() {
    return select(settings).watch().map((rows) {
      return {for (var item in rows) item.key: item.value};
    });
  }

  Future<Map<String, String>> getAllSettings() async {
    final rows = await select(settings).get();
    return {for (var item in rows) item.key: item.value};
  }

  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) async {
    await into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }

  Future<void> updateBatchSettings(Map<String, String> settingsMap) async {
    return transaction(() async {
      for (var entry in settingsMap.entries) {
        await into(settings).insertOnConflictUpdate(
          SettingsCompanion.insert(key: entry.key, value: entry.value),
        );
      }
    });
  }
}
