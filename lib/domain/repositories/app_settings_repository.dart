import '../models/app_preferences.dart';

abstract interface class AppSettingsRepository {
  Stream<AppPreferences> watchSettings();
  Future<AppPreferences> getSettings();
  Future<void> updateSettings(AppPreferences settings);
}
