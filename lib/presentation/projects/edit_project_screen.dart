import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../l10n/app_localizations.dart';
import 'project_metadata_form.dart';
import 'project_state_view.dart';

class EditProjectScreen extends ConsumerWidget {
  const EditProjectScreen({super.key, required this.projectId});
  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ProjectStateView(
      projectId: projectId,
      builder: (project) => Scaffold(
        appBar: AppBar(title: Text(l10n.editDetails)),
        body: SafeArea(
          child: ProjectMetadataForm(
            key: ValueKey(project.id),
            initialProject: project,
            submitLabel: l10n.save,
            onSubmit: (metadata) async {
              await ref
                  .read(projectRepositoryProvider)
                  .updateProjectMetadata(projectId, metadata);
              if (context.mounted) context.go('/projects/$projectId');
            },
          ),
        ),
      ),
    );
  }
}
