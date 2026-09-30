import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'cut_settings_section.dart';
import 'project_state_view.dart';
import '../stock/project_stock_section.dart';
import '../parts/project_parts_section.dart';
import 'calculate_action.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ProjectStateView(
      projectId: projectId,
      builder: (project) => Scaffold(
        appBar: AppBar(
          title: Text(project.name),
          actions: [
            IconButton(
              tooltip: l10n.editDetails,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.go('/projects/$projectId/edit'),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (project.material != null)
                _Section(title: l10n.materialLabel, text: project.material!),
              if (project.note != null)
                _Section(title: l10n.noteLabel, text: project.note!),
              ProjectStockSection(key: ValueKey(project.id), project: project),
              ProjectPartsSection(project: project),
              CutSettingsSection(project: project),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CalculateAction(project: project),
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    ),
  );
}
