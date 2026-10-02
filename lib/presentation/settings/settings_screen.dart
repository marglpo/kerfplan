import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings_providers.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/message_state.dart';
import 'settings_form.dart';
import '../billing/billing_settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ref
            .watch(appSettingsProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => MessageState(
                message: l10n.settingsLoadError,
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(appSettingsProvider),
              ),
              data: (settings) => SettingsForm(
                footer: const BillingSettingsSection(),
                initial: settings,
                onLanguageSelected: (language) async {
                  final repository = ref.read(appSettingsRepositoryProvider);
                  final current = await repository.getSettings();
                  await repository.updateSettings(
                    current.copyWith(language: language),
                  );
                },
                onSubmit: (values) => ref
                    .read(appSettingsRepositoryProvider)
                    .updateSettings(values),
              ),
            ),
      ),
    );
  }
}
