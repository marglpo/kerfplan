import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/optimization_providers.dart';
import '../../app/optimization_coordinator.dart';
import '../../app/reusable_leftovers.dart';
import 'add_leftovers_action.dart';
import '../../app/project_providers.dart';
import '../../domain/repositories/project_repository.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/message_state.dart';
import 'optimization_bar_card.dart';
import 'result_summary.dart';
import 'unplaced_section.dart';
import 'result_messages.dart';
import 'share_report_action.dart';

class ResultScreen extends ConsumerStatefulWidget {
  const ResultScreen({super.key, required this.projectId});
  final String projectId;

  @override
  ConsumerState<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends ConsumerState<ResultScreen> {
  late AsyncValue<CalculatedProject> _state;
  ProviderSubscription<AsyncValue<CalculatedProject>>? _subscription;
  bool _addingLeftovers = false;
  String get projectId => widget.projectId;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  void _subscribe() {
    final provider = optimizationResultProvider(projectId);
    _state = ref.read(provider);
    _subscription = ref.listenManual(provider, (_, next) {
      if (mounted) setState(() => _state = next);
    });
  }

  @override
  void didUpdateWidget(ResultScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.projectId != projectId) {
      _subscription?.close();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  Future<void> _addLeftovers(CalculatedProject calculation) async {
    if (_addingLeftovers) return;
    final l10n = AppLocalizations.of(context);
    final service = ref.read(reusableLeftoversProvider);
    setState(() => _addingLeftovers = true);
    // Stop the live calculation BEFORE mutating stock. Otherwise Drift's
    // project update could recalculate this job using its own future offcuts.
    _subscription?.close();
    _subscription = null;
    ref.invalidate(optimizationResultProvider(projectId));
    try {
      await service.addToStock(calculation.project.id, calculation.result);
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      context.go('/projects/$projectId');
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.leftoversAddedToStock)),
      );
    } catch (_) {
      if (!mounted) return;
      _subscribe();
      setState(() => _addingLeftovers = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.leftoversAddError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = optimizationResultProvider(projectId);
    final state = _state;
    void reload() {
      if (ref.read(projectProvider(projectId)).hasError) {
        ref.invalidate(projectProvider(projectId));
      }
      ref.invalidate(provider);
    }

    return PopScope(
      canPop: !_addingLeftovers,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.cutPlanTitle),
          actions: [
            if (!_addingLeftovers &&
                !state.isLoading &&
                !state.hasError &&
                state.asData?.value != null)
              ShareReportAction(calculation: state.asData!.value),
          ],
        ),
        body: SafeArea(
          child: state.when(
            skipLoadingOnRefresh: false,
            skipLoadingOnReload: false,
            loading: () => Center(
              child: Semantics(
                label: l10n.calculating,
                child: const CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => MessageState(
              message: resultFailureMessage(l10n, error),
              actionLabel: error is ProjectNotFoundException
                  ? l10n.backToProjects
                  : l10n.retry,
              onAction: error is ProjectNotFoundException
                  ? () => context.go('/')
                  : reload,
            ),
            data: (calculation) {
              final result = calculation.result;
              final hasUnplaced = result.unplaced.isNotEmpty;
              final headerCount = hasUnplaced ? 2 : 1;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: headerCount + result.bars.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ResultSummary(calculation: calculation);
                  }
                  if (hasUnplaced && index == 1) {
                    return UnplacedSection(
                      parts: result.unplaced,
                      unit: calculation.project.displayUnit,
                    );
                  }
                  if (index == headerCount + result.bars.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.verifyBeforeCutting,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  final bar = result.bars[index - headerCount];
                  return OptimizationBarCard(
                    key: ValueKey('result-bar-${bar.barIndex}'),
                    bar: bar,
                    unit: calculation.project.displayUnit,
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: state.isLoading || _addingLeftovers
                      ? null
                      : reload,
                  child: Text(l10n.recalculate),
                ),
                if (!state.isLoading && !state.hasError && state.asData != null)
                  AddLeftoversAction(
                    calculation: state.asData!.value,
                    enabled: !_addingLeftovers,
                    onConfirmed: _addLeftovers,
                  ),
                OutlinedButton(
                  onPressed: _addingLeftovers
                      ? null
                      : () => context.go('/projects/$projectId'),
                  child: Text(l10n.editCutList),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
