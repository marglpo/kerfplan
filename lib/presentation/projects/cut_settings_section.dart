import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/models/cut_project.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';

class CutSettingsSection extends StatelessWidget {
  const CutSettingsSection({super.key, required this.project});
  final CutProject project;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cutSettingsSectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.resultMetric(
                l10n.units,
                unitLabel(l10n, project.displayUnit),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.resultMetric(
                l10n.kerf,
                displayLength(l10n, project.kerf, project.displayUnit),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.endTrimPerEnd(
                displayLength(l10n, project.endTrim, project.displayUnit),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.resultMetric(
                l10n.reusableLeftover,
                displayLength(l10n, project.minReusable, project.displayUnit),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () =>
                  context.go('/projects/${project.id}/cut-settings'),
              child: Text(l10n.editCutSettings),
            ),
          ],
        ),
      ),
    );
  }
}
