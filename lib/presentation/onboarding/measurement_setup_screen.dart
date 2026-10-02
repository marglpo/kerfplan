import 'package:flutter/material.dart';

import '../../domain/models/measurement_system.dart';
import '../../l10n/app_localizations.dart';

/// One-step first-launch setup. The recommendation never overrides a choice.
class MeasurementSetupScreen extends StatefulWidget {
  const MeasurementSetupScreen({
    super.key,
    required this.recommended,
    required this.onContinue,
  });

  final MeasurementSystem recommended;
  final Future<void> Function(MeasurementSystem) onContinue;

  @override
  State<MeasurementSetupScreen> createState() => _MeasurementSetupScreenState();
}

class _MeasurementSetupScreenState extends State<MeasurementSetupScreen> {
  late MeasurementSystem _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.recommended;
  }

  Future<void> _continue() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await widget.onContinue(_selected);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsSaveError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 24),
                Icon(
                  Icons.straighten,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l.appName,
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(l.onboardingIntro, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                Text(l.howDoYouMeasure, style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                for (final system in MeasurementSystem.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        key: ValueKey('setup-${system.storageValue}'),
                        minVerticalPadding: 16,
                        leading: Icon(
                          _selected == system
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                        ),
                        title: Text(
                          system == MeasurementSystem.metric
                              ? l.metric
                              : l.imperial,
                        ),
                        subtitle: Text(
                          [
                            system == MeasurementSystem.metric
                                ? l.metricDescription
                                : l.imperialDescription,
                            if (system == widget.recommended)
                              l.recommendedForRegion,
                          ].join('\n'),
                        ),
                        selected: _selected == system,
                        onTap: _saving
                            ? null
                            : () => setState(() => _selected = system),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(l.measurementCanChangeLater),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _continue,
                  child: Text(l.continueAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
