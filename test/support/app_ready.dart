import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';

/// Existing workflow tests start in the post-setup state. Dedicated setup
/// tests exercise a genuinely fresh install separately.
Future<void> completeOnboarding(AppDatabase db) async {
  final repository = DriftAppSettingsRepository(db);
  final current = await repository.getSettings();
  await repository.updateSettings(current.copyWith(onboardingCompleted: true));
}
