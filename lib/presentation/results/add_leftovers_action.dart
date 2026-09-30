import 'package:flutter/material.dart';

import '../../app/optimization_coordinator.dart';
import '../../app/reusable_leftovers.dart';
import '../../l10n/app_localizations.dart';

class AddLeftoversAction extends StatefulWidget {
  const AddLeftoversAction({
    super.key,
    required this.calculation,
    required this.onConfirmed,
    required this.enabled,
  });
  final CalculatedProject calculation;
  final Future<void> Function(CalculatedProject) onConfirmed;
  final bool enabled;

  @override
  State<AddLeftoversAction> createState() => _AddLeftoversActionState();
}

class _AddLeftoversActionState extends State<AddLeftoversAction> {
  bool _confirming = false;

  Future<void> _confirm() async {
    if (_confirming || !widget.enabled) return;
    final calculation = widget.calculation;
    final pieces = groupReusableLeftovers(calculation.result)
        .fold(0, (sum, input) => sum + input.quantity);
    if (pieces == 0) return;
    setState(() => _confirming = true);
    final l10n = AppLocalizations.of(context);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.addLeftoversTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.reusablePieces(pieces)),
                const SizedBox(height: 16),
                Text(l10n.addLeftoversMessage),
                const SizedBox(height: 12),
                Text(l10n.addLeftoversFutureHint),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.addToStock),
            ),
          ],
        ),
      );
      if (confirmed == true && mounted) await widget.onConfirmed(calculation);
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.calculation.result.bars.any(
      (bar) => bar.isTailReusable && bar.tailLeftover.ticks > 0,
    )) {
      return const SizedBox.shrink();
    }
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(minimumSize: const Size(64, 48)),
      onPressed: widget.enabled && !_confirming ? _confirm : null,
      icon: const Icon(Icons.add),
      label: Text(AppLocalizations.of(context).addLeftoversToStock),
    );
  }
}
