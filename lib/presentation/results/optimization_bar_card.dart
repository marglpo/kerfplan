import 'package:flutter/material.dart';

import '../../domain/optimizer/optimization_bar.dart';
import '../../domain/units/display_unit.dart';
import '../../domain/units/length.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import 'cut_bar_diagram.dart';

class OptimizationBarCard extends StatelessWidget {
  const OptimizationBarCard({super.key, required this.bar, required this.unit});
  final OptimizationBar bar;
  final DisplayUnit unit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String length(Length value) => displayLength(l10n, value, unit);
    final classification = bar.tailLeftover.ticks == 0
        ? ''
        : bar.isTailReusable
        ? l10n.reusable
        : l10n.scrap;
    final tail = classification.isEmpty
        ? length(bar.tailLeftover)
        : l10n.classifiedLeftover(length(bar.tailLeftover), classification);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.barTitle(bar.barIndex + 1, length(bar.stockLength)),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.partsOnBar(bar.placedParts.length)),
            const SizedBox(height: 12),
            CutBarDiagram(
              bar: bar,
              description: l10n.barDiagramDescription(
                bar.barIndex + 1,
                length(bar.stockLength),
                l10n.partsOnBar(bar.placedParts.length),
                tail,
              ),
            ),
            const SizedBox(height: 12),
            for (final part in bar.placedParts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  l10n.cutOrderPart(
                    part.orderIndex + 1,
                    part.name == null
                        ? length(part.length)
                        : l10n.namedPartLength(part.name!, length(part.length)),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            const SizedBox(height: 8),
            Text(l10n.resultMetric(l10n.kerfLoss, length(bar.kerfLoss))),
            if (bar.trimLoss.ticks > 0)
              Text(
                l10n.endTrimPerEnd(
                  length(Length.fromTicks(bar.trimLoss.ticks ~/ 2)),
                ),
              ),
            Text(
              l10n.resultMetric(l10n.leftover, tail),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
