import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/project_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../l10n/app_localizations.dart';

enum _ProjectAction { edit, duplicate, delete }

class ProjectCard extends ConsumerStatefulWidget {
  const ProjectCard({super.key, required this.project});
  final CutProject project;

  @override
  ConsumerState<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<ProjectCard> {
  bool _busy = false;

  Future<void> _act(_ProjectAction action) async {
    if (_busy) return;
    final project = widget.project;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (action == _ProjectAction.edit) {
      context.go('/projects/${project.id}/edit');
      return;
    }
    if (action == _ProjectAction.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.deleteProjectTitle),
          content: Text(l10n.deleteProjectMessage(project.name)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      final repository = ref.read(projectRepositoryProvider);
      if (action == _ProjectAction.duplicate) {
        final copy = await repository.duplicateProject(
          project.id,
          copyLabel: l10n.copyLabel,
        );
        if (mounted) context.go('/projects/${copy.id}');
      } else {
        await repository.deleteProject(project.id);
        // Deletion may already have removed this card via the Drift stream.
        if (messenger.mounted) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.projectDeleted)));
        }
      }
    } catch (_) {
      if (messenger.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              action == _ProjectAction.delete
                  ? l10n.projectDeleteError
                  : l10n.projectDuplicateError,
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final l10n = AppLocalizations.of(context);
    final date = DateFormat.yMMMd(l10n.localeName)
        .add_jm()
        .format(project.updatedAt.toLocal());
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InkWell(
                  onTap: _busy
                      ? null
                      : () => context.go('/projects/${project.id}'),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (project.material != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            project.material!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(
                          l10n.updatedLabel(date),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_ProjectAction>(
                enabled: !_busy,
                tooltip: l10n.projectActions(project.name),
                icon: const Icon(Icons.more_vert),
                onSelected: _act,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _ProjectAction.edit,
                    child: Text(l10n.editDetails),
                  ),
                  PopupMenuItem(
                    value: _ProjectAction.duplicate,
                    child: Text(l10n.duplicate),
                  ),
                  PopupMenuItem(
                    value: _ProjectAction.delete,
                    child: Text(l10n.delete),
                  ),
                ],
              ),
            ],
          ),
          if (_busy) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}
