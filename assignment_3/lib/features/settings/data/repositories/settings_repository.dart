import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sembast/sembast.dart';
import '../../../../core/database/database_service.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/app_settings.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final DatabaseService _databaseService;
  final _store = StoreRef<String, Map<String, dynamic>>(AppConstants.settingsStore);

  SettingsRepository(this._databaseService);

  Future<AppSettings> getSettings() async {
    final db = await _databaseService.database;
    final snapshot = await _store.record(AppConstants.settingsKey).get(db);
    
    if (snapshot == null) {
      return AppSettings.defaultSettings();
    }
    
    return AppSettings.fromJson(snapshot);
  }

  Future<void> saveSettings(AppSettings settings) async {
    final db = await _databaseService.database;
    await _store.record(AppConstants.settingsKey).put(db, settings.toJson());
  }

  Stream<AppSettings> watchSettings() async* {
    final db = await _databaseService.database;
    
    yield* _store.record(AppConstants.settingsKey).onSnapshot(db).map((snapshot) {
      if (snapshot == null) {
        return AppSettings.defaultSettings();
      }
      return AppSettings.fromJson(snapshot.value);
    });
  }
}

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  final databaseService = ref.watch(databaseServiceProvider);
  return SettingsRepository(databaseService);
}