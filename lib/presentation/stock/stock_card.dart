import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/stock_providers.dart';
import '../../domain/models/stock_item.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';

enum _StockAction { duplicate, delete }

class StockCard extends ConsumerStatefulWidget {
  const StockCard({super.key, required this.stock, required this.unit});
  final StockItem stock;
  final DisplayUnit unit;
  @override
  ConsumerState<StockCard> createState() => _StockCardState();
}

class _StockCardState extends ConsumerState<StockCard> {
  bool _busy = false;
  Future<void> _act(_StockAction action) async {
    if (_busy) return;
    final stock = widget.stock;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    if (action == _StockAction.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.deleteStockTitle),
          content: Text(
            l10n.deleteStockMessage(
              displayLength(l10n, stock.length, widget.unit),
              stock.quantity,
            ),
          ),
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
      final repository = ref.read(stockRepositoryProvider);
      if (action == _StockAction.duplicate) {
        await repository.duplicateStockLine(stock.id);
      } else {
        await repository.deleteStockLine(stock.id);
        if (messenger.mounted) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.stockDeleted)));
        }
      }
    } catch (_) {
      if (messenger.mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              action == _StockAction.delete
                  ? l10n.stockDeleteError
                  : l10n.stockDuplicateError,
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
    final stock = widget.stock;
    final l10n = AppLocalizations.of(context);
    final length = displayLength(l10n, stock.length, widget.unit);
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
                      : () => context.go(
                          '/projects/${stock.projectId}/stock/${stock.id}/edit',
                        ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          length,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          l10n.stockQuantity(stock.quantity),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (stock.label != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            stock.label!,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              PopupMenuButton<_StockAction>(
                enabled: !_busy,
                tooltip: l10n.stockActions(length),
                onSelected: _act,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _StockAction.duplicate,
                    child: Text(l10n.duplicateStock),
                  ),
                  PopupMenuItem(
                    value: _StockAction.delete,
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
