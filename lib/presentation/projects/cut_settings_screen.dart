import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../l10n/app_localizations.dart';
import 'cut_settings_form.dart';
import 'project_state_view.dart';

class CutSettingsScreen extends ConsumerWidget {
  const CutSettingsScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ProjectStateView(
    projectId: projectId,
    builder: (project) => Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).cutSettingsSectionTitle),
      ),
      body: SafeArea(
        child: CutSettingsForm(
          key: ValueKey(project.id),
          project: project,
          onSubmit: (settings) async {
            await ref
                .read(projectRepositoryProvider)
                .updateCutSettings(projectId, settings);
            if (context.mounted) context.go('/projects/$projectId');
          },
        ),
      ),
    ),
  );
}
