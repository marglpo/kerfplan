import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/project_providers.dart';
import '../../app/stock_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../domain/models/inventory_mode.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import 'stock_card.dart';

class ProjectStockSection extends ConsumerStatefulWidget {
  const ProjectStockSection({super.key, required this.project});
  final CutProject project;
  @override
  ConsumerState<ProjectStockSection> createState() =>
      _ProjectStockSectionState();
}

class _ProjectStockSectionState extends ConsumerState<ProjectStockSection> {
  bool _saving = false;
  bool _failed = false;
  Future<void> _setMode(InventoryMode mode) async {
    if (_saving) return;
    setState(() {
      _saving = true;
      _failed = false;
    });
    try {
      await ref
          .read(projectRepositoryProvider)
          .setInventoryMode(widget.project.id, mode);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.stockSectionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) => SegmentedButton<InventoryMode>(
                direction: constraints.maxWidth < 360
                    ? Axis.vertical
                    : Axis.horizontal,
                style: SegmentedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                segments: [
                  ButtonSegment(
                    value: InventoryMode.fixed,
                    label: Text(l10n.fixedInventory),
                  ),
                  ButtonSegment(
                    value: InventoryMode.buy,
                    label: Text(l10n.buyStock),
                  ),
                ],
                selected: {project.inventoryMode},
                onSelectionChanged: _saving
                    ? null
                    : (selection) => _setMode(selection.single),
              ),
            ),
            if (_saving) const LinearProgressIndicator(),
            if (_failed)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Semantics(
                  liveRegion: true,
                  child: Text(
                    l10n.stockModeSaveError,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (project.inventoryMode == InventoryMode.fixed)
              _FixedStock(project: project)
            else ...[
              if (project.buyStockLength == null)
                Text(
                  l10n.buyStockLengthMissing,
                  style: Theme.of(context).textTheme.bodyLarge,
                )
              else
                Text(
                  displayLength(
                    l10n,
                    project.buyStockLength!,
                    project.displayUnit,
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              const SizedBox(height: 12),
              Text(l10n.buyStockHelper),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    context.go('/projects/${project.id}/stock/buy'),
                child: Text(
                  project.buyStockLength == null
                      ? l10n.setBuyStockLength
                      : l10n.editStockLength,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _FixedStock extends ConsumerWidget {
  const _FixedStock({required this.project});
  final CutProject project;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(stockLinesProvider(project.id))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Column(
            children: [
              Text(l10n.stockLoadError),
              TextButton(
                onPressed: () => ref.invalidate(stockLinesProvider(project.id)),
                child: Text(l10n.retry),
              ),
            ],
          ),
          data: (items) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (items.isEmpty)
                Text(l10n.noStockYet)
              else ...[
                Text(
                  l10n.stockSummary(items.length),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  l10n.totalPieces(
                    items.fold(0, (total, stock) => total + stock.quantity),
                  ),
                ),
                for (final stock in items)
                  StockCard(
                    key: ValueKey(stock.id),
                    stock: stock,
                    unit: project.displayUnit,
                  ),
              ],
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () =>
                    context.go('/projects/${project.id}/stock/new'),
                icon: const Icon(Icons.add),
                label: Text(l10n.addStockLength),
              ),
            ],
          ),
        );
  }
}
