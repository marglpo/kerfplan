import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/part_providers.dart';
import '../../app/stock_providers.dart';
import '../../domain/models/part_fit.dart';
import '../../domain/models/cut_project.dart';
import '../../domain/models/part_item.dart';
import '../../l10n/app_localizations.dart';
import '../projects/project_state_view.dart';
import '../shared/widgets/message_state.dart';
import 'part_form.dart';

class PartEditorScreen extends ConsumerWidget {
  const PartEditorScreen({super.key, required this.projectId, this.partId});
  final String projectId;
  final String? partId;

  Widget _form(
    BuildContext context,
    WidgetRef ref,
    CutProject project,
    PartItem? part,
  ) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(partId == null ? l10n.addPart : l10n.editPart),
      ),
      body: SafeArea(
        child: PartForm(
          key: ValueKey(partId ?? projectId),
          unit: project.displayUnit,
          usableStock: PartFit.largestUsable(
            project,
            ref.read(stockLinesProvider(projectId)).asData?.value ?? [],
          ),
          initialPart: part,
          onSubmitAnother: partId == null
              ? (input) async {
                  await ref
                      .read(partRepositoryProvider)
                      .createPart(projectId, input);
                }
              : null,
          onSubmit: (input) async {
            final repository = ref.read(partRepositoryProvider);
            if (partId == null) {
              await repository.createPart(projectId, input);
            } else {
              await repository.updatePart(partId!, input);
            }
            if (context.mounted) context.go('/projects/$projectId');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stockLinesProvider(projectId));
    final l10n = AppLocalizations.of(context);
    final partState = partId == null
        ? null
        : ref.watch(partsProvider(projectId));
    return ProjectStateView(
      projectId: projectId,
      builder: (project) {
        if (partId == null) return _form(context, ref, project, null);
        return partState!.when(
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(),
            body: MessageState(
              message: l10n.partLoadError,
              actionLabel: l10n.retry,
              onAction: () => ref.invalidate(partsProvider(projectId)),
            ),
          ),
          data: (items) {
            final part = items.where((item) => item.id == partId).firstOrNull;
            if (part == null) {
              return Scaffold(
                appBar: AppBar(),
                body: MessageState(
                  message: l10n.partNotFound,
                  actionLabel: l10n.backToProject,
                  onAction: () => context.go('/projects/$projectId'),
                ),
              );
            }
            return _form(context, ref, project, part);
          },
        );
      },
    );
  }
}
