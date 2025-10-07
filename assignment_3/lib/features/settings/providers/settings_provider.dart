import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/app_settings.dart';
import '../data/repositories/settings_repository.dart';

part 'settings_provider.g.dart';

@riverpod
class Settings extends _$Settings {
  @override
  Stream<AppSettings> build() {
    final repository = ref.watch(settingsRepositoryProvider);
    return repository.watchSettings();
  }

  Future<void> updateFontSize(double fontSize) async {
    final repository = ref.read(settingsRepositoryProvider);
    final currentSettings = await repository.getSettings();
    final updatedSettings = currentSettings.copyWith(fontSize: fontSize);
    await repository.saveSettings(updatedSettings);
  }

  Future<void> toggleDarkMode() async {
    final repository = ref.read(settingsRepositoryProvider);
    final currentSettings = await repository.getSettings();
    final updatedSettings = currentSettings.copyWith(
      isDarkMode: !currentSettings.isDarkMode,
    );
    await repository.saveSettings(updatedSettings);
  }
}