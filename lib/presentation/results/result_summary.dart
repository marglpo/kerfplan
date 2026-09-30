import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/optimization_coordinator.dart';
import '../../domain/models/inventory_mode.dart';
import '../../domain/units/length.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';

class ResultSummary extends StatelessWidget {
  const ResultSummary({super.key, required this.calculation});
  final CalculatedProject calculation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final project = calculation.project;
    final result = calculation.result;
    final theme = Theme.of(context).textTheme;
    String length(Length value) =>
        displayLength(l10n, value, project.displayUnit);
    Widget metric(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(l10n.resultMetric(label, value), style: theme.bodyLarge),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(project.name, style: theme.titleMedium),
            const SizedBox(height: 12),
            Text(
              project.inventoryMode == InventoryMode.buy
                  ? l10n.stockPiecesToBuy(result.barsToBuy!)
                  : l10n.stockPiecesUsed(result.barsUsed),
              style: theme.headlineSmall,
            ),
            if (project.inventoryMode == InventoryMode.buy)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.buySummary(
                    length(project.buyStockLength!),
                    result.barsToBuy!,
                  ),
                  style: theme.titleLarge,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              l10n.wastePercentage(
                NumberFormat(
                  '0.0',
                  l10n.localeName,
                ).format(result.wastePercent),
              ),
              style: theme.headlineMedium,
            ),
            metric(l10n.totalWaste, length(result.totalWaste)),
            metric(l10n.reusableLeftovers, length(result.reusableLeftovers)),
            metric(l10n.scrap, length(result.scrap)),
            Text(l10n.reusableExplanation(length(project.minReusable))),
            const Divider(height: 32),
            Text(
              l10n.placedOfRequested(
                result.placedPartCount,
                result.requestedPartCount,
              ),
              style: theme.titleMedium,
            ),
            metric(l10n.requestedParts, '${result.requestedPartCount}'),
            metric(l10n.placedParts, '${result.placedPartCount}'),
            if (result.unplacedPartCount > 0)
              metric(l10n.unplacedParts, '${result.unplacedPartCount}'),
            metric(
              l10n.totalFinishedLength,
              length(result.totalFinishedLength),
            ),
            metric(l10n.totalStockUsed, length(result.totalUsedStockLength)),
            metric(l10n.kerfLoss, length(result.kerfLoss)),
            metric(l10n.trimLoss, length(result.trimLoss)),
          ],
        ),
      ),
    );
  }
}
