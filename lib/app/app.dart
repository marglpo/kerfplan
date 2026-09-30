import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'settings_providers.dart';
import '../domain/models/app_theme_mode.dart';
import 'billing/billing_lifecycle.dart';

class KerfPlanApp extends ConsumerWidget {
  const KerfPlanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      builder: (context, child) => BillingLifecycle(child: child!),
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
