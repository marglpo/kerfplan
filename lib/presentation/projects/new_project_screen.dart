import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_creation.dart';
import '../../l10n/app_localizations.dart';
import 'project_metadata_form.dart';

class NewProjectScreen extends ConsumerWidget {
  const NewProjectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.newProjectTitle)),
      body: SafeArea(
        child: ProjectMetadataForm(
          submitLabel: l10n.createCutList,
          onSubmit: (metadata) async {
            final project = await ref
                .read(projectCreationProvider)
                .create(metadata);
            if (context.mounted) context.go('/projects/${project.id}');
          },
        ),
      ),
    );
  }
}
