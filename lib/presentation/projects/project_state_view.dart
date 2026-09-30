import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/message_state.dart';

/// Shared loading, error and deleted states for both project routes.
class ProjectStateView extends ConsumerWidget {
  const ProjectStateView({
    super.key,
    required this.projectId,
    required this.builder,
  });

  final String projectId;
  final Widget Function(CutProject) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(projectProvider(projectId))
        .when(
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: MessageState(
                message: l10n.projectLoadError,
                actionLabel: l10n.retry,
                onAction: () => ref.invalidate(projectProvider(projectId)),
              ),
            ),
          ),
          data: (project) => project == null
              ? Scaffold(
                  appBar: AppBar(),
                  body: SafeArea(
                    child: MessageState(
                      message: l10n.projectNotFound,
                      actionLabel: l10n.backToProjects,
                      onAction: () => context.go('/'),
                    ),
                  ),
                )
              : builder(project),
        );
  }
}
