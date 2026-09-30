import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/optimization_coordinator.dart';
import '../../app/optimization_providers.dart';
import '../../app/part_providers.dart';
import '../../app/stock_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../l10n/app_localizations.dart';
import '../results/result_messages.dart';

class CalculateAction extends ConsumerStatefulWidget {
  const CalculateAction({super.key, required this.project});
  final CutProject project;
  @override
  ConsumerState<CalculateAction> createState() => _CalculateActionState();
}

class _CalculateActionState extends ConsumerState<CalculateAction> {
  bool _busy = false;
  Object? _error;
  ProviderSubscription<AsyncValue<CalculatedProject>>? _subscription;

  Future<void> _calculate() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final provider = optimizationResultProvider(widget.project.id);
    ref.invalidate(provider);
    _subscription = ref.listenManual(provider, (_, _) {});
    try {
      await ref.read(provider.future);
      if (mounted) {
        context.go('/projects/${widget.project.id}/result');
        // Keep the completed provider alive until Result subscribes this frame.
        await WidgetsBinding.instance.endOfFrame;
      }
    } catch (error) {
      if (mounted) setState(() => _error = error);
    } finally {
      _subscription?.close();
      _subscription = null;
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stock = ref.watch(stockLinesProvider(widget.project.id));
    final parts = ref.watch(partsProvider(widget.project.id));
    final loaded =
        !stock.isLoading &&
        !parts.isLoading &&
        !stock.hasError &&
        !parts.hasError;
    final requirement = loaded
        ? calculationRequirement(
            widget.project,
            stock.requireValue,
            parts.requireValue,
          )
        : null;
    final enabled = loaded && requirement == null && !_busy;
    final message = _error != null
        ? resultFailureMessage(l10n, _error!)
        : stock.hasError || parts.hasError
        ? l10n.resultLoadError
        : requirement == null
        ? null
        : requirementMessage(l10n, requirement);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton(
          onPressed: enabled ? _calculate : null,
          child: Text(_busy ? l10n.calculating : l10n.calculate),
        ),
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Semantics(
              liveRegion: true,
              child: Text(message, textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }
}
