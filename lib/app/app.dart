import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'settings_providers.dart';
import '../domain/models/app_theme_mode.dart';
import '../domain/models/app_language.dart';
import 'billing/billing_lifecycle.dart';
import '../domain/models/measurement_system.dart';
import '../presentation/onboarding/measurement_setup_screen.dart';
import '../presentation/shared/widgets/message_state.dart';

class KerfPlanApp extends ConsumerWidget {
  const KerfPlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    return MaterialApp.router(
      builder: (context, child) => settings.when(
        loading: () => Scaffold(
          appBar: AppBar(title: Text(AppLocalizations.of(context).appName)),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => Scaffold(
          body: MessageState(
            message: AppLocalizations.of(context).settingsLoadError,
            actionLabel: AppLocalizations.of(context).retry,
            onAction: () => ref.invalidate(appSettingsProvider),
          ),
        ),
        data: (preferences) {
          if (!preferences.onboardingCompleted) {
            final locales = WidgetsBinding.instance.platformDispatcher.locales;
            final country = locales.isEmpty ? null : locales.first.countryCode;
            return MeasurementSetupScreen(
              recommended: MeasurementSystem.recommend(country),
              onContinue: (system) async {
                final repository = ref.read(appSettingsRepositoryProvider);
                final current = await repository.getSettings();
                await repository.updateSettings(
                  current.copyWith(
                    measurementSystem: system,
                    defaultDisplayUnit: system.defaultUnit,
                    onboardingCompleted: true,
                  ),
                );
              },
            );
          }
          return BillingLifecycle(child: child!);
        },
      ),
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: [
        for (final language in AppLanguage.values.skip(1)) language.locale!,
      ],
      locale: ref.watch(
        appSettingsProvider.select(
          (state) => state.asData?.value.language.locale,
        ),
      ),
      localeResolutionCallback: (device, _) =>
          AppLanguage.resolveSystem(device),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: AppTheme.mode(
        ref.watch(
          appSettingsProvider.select(
            (state) => state.asData?.value.themeMode ?? AppThemeMode.system,
          ),
        ),
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
