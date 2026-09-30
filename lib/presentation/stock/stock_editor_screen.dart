import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/stock_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../domain/models/stock_item.dart';
import '../../l10n/app_localizations.dart';
import '../projects/project_state_view.dart';
import '../shared/widgets/message_state.dart';
import 'stock_form.dart';

class StockEditorScreen extends ConsumerWidget {
  const StockEditorScreen({super.key, required this.projectId, this.stockId});
  final String projectId;
  final String? stockId;

  Widget _form(
    BuildContext context,
    WidgetRef ref,
    CutProject project,
    StockItem? stock,
  ) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          stockId == null ? l10n.addStockLength : l10n.editStockLength,
        ),
      ),
      body: SafeArea(
        child: StockForm(
          key: ValueKey(stockId ?? projectId),
          unit: project.displayUnit,
          initialStock: stock,
          onSubmitAnother: stockId == null
              ? (input) async {
                  await ref
                      .read(stockRepositoryProvider)
                      .createStockLine(projectId, input);
                }
              : null,
          onSubmit: (input) async {
            final repository = ref.read(stockRepositoryProvider);
            if (stockId == null) {
              await repository.createStockLine(projectId, input);
            } else {
              await repository.updateStockLine(stockId!, input);
            }
            if (context.mounted) context.go('/projects/$projectId');
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stockState = stockId == null
        ? null
        : ref.watch(stockLinesProvider(projectId));
    return ProjectStateView(
      projectId: projectId,
      builder: (project) {
        if (stockId == null) return _form(context, ref, project, null);
        return stockState!.when(
          loading: () => Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            appBar: AppBar(),
            body: MessageState(
              message: l10n.stockLoadError,
              actionLabel: l10n.retry,
              onAction: () => ref.invalidate(stockLinesProvider(projectId)),
            ),
          ),
          data: (items) {
            final stock = items.where((item) => item.id == stockId).firstOrNull;
            if (stock == null) {
              return Scaffold(
                appBar: AppBar(),
                body: MessageState(
                  message: l10n.stockNotFound,
                  actionLabel: l10n.backToProject,
                  onAction: () => context.go('/projects/$projectId'),
                ),
              );
            }
            return _form(context, ref, project, stock);
          },
        );
      },
    );
  }
}
