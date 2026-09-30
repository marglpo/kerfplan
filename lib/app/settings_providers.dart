import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database_provider.dart';
import '../data/repositories/drift_app_settings_repository.dart';
import '../domain/models/app_preferences.dart';
import '../domain/repositories/app_settings_repository.dart';

final appSettingsRepositoryProvider = Provider<AppSettingsRepository>(
  (ref) => DriftAppSettingsRepository(ref.watch(appDatabaseProvider)),
);

final appSettingsProvider = StreamProvider<AppPreferences>(
  (ref) => ref.watch(appSettingsRepositoryProvider).watchSettings(),
  retry: (count, error) => null,
);
