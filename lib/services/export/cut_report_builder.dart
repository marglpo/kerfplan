import 'package:intl/intl.dart';

import '../../domain/models/cut_project.dart';
import '../../domain/models/inventory_mode.dart';
import '../../domain/optimizer/optimization_result.dart';
import '../../domain/optimizer/unplaced_part.dart';
import '../../domain/units/length.dart';
import '../../l10n/app_localizations.dart';
import '../../presentation/shared/formatting/length_format.dart';
import '../../presentation/shared/formatting/unplaced_grouping.dart';
import 'cut_report_data.dart';
import 'report_file_name.dart';

abstract final class CutReportBuilder {
  static CutReportData build({
    required CutProject project,
    required OptimizationResult result,
    required DateTime generatedAt,
    required AppLocalizations labels,
  }) {
    final l = labels;
    String length(Length value) => displayLength(l, value, project.displayUnit);
    String named(String? name, Length value) =>
        name == null ? length(value) : l.namedPartLength(name, length(value));
    final buy = project.inventoryMode == InventoryMode.buy;
    return CutReportData(
      project: project,
      result: result,
      generatedAt: generatedAt,
      brand: l.appName,
      generatedLabel: l.generatedLabel,
      generatedDate: DateFormat.yMMMd(l.localeName)
          .format(generatedAt.toLocal()),
      settingsHeading: l.cutSettingsSectionTitle,
      summaryHeading: l.reportSummary,
      purchaseHeading: l.reportPurchase,
      stockSummary: buy
          ? l.stockPiecesToBuy(result.barsToBuy!)
          : l.stockPiecesUsed(result.barsUsed),
      purchaseLine: buy
          ? l.lengthQuantity(length(project.buyStockLength!), result.barsToBuy!)
          : null,
      placedSummary: l.placedOfRequested(
        result.placedPartCount,
        result.requestedPartCount,
      ),
      wasteHeadline: l.wastePercentage(
        NumberFormat('0.0', l.localeName).format(result.wastePercent),
      ),
      unplacedHeading: l.unplacedCount(result.unplacedPartCount),
      footer: l.generatedBy(l.appName),
      disclaimer: l.verifyBeforeCutting,
      fileName: reportFileName(
        project.name,
        generatedAt,
        brand: l.appName,
        fallback: l.reportFileFallback,
      ),
      settings: [
        (label: l.units, value: unitLabel(l, project.displayUnit)),
        (label: l.kerf, value: length(project.kerf)),
        (label: l.endTrimEachEnd, value: length(project.endTrim)),
        (label: l.reusableLeftover, value: length(project.minReusable)),
      ],
      summary: [
        (label: l.requestedParts, value: '${result.requestedPartCount}'),
        (label: l.placedParts, value: '${result.placedPartCount}'),
        if (result.unplacedPartCount > 0)
          (label: l.unplacedParts, value: '${result.unplacedPartCount}'),
        (label: l.totalWaste, value: length(result.totalWaste)),
        (label: l.reusableLeftovers, value: length(result.reusableLeftovers)),
        (label: l.scrap, value: length(result.scrap)),
        (
          label: l.totalFinishedLength,
          value: length(result.totalFinishedLength),
        ),
        (label: l.totalStockUsed, value: length(result.totalUsedStockLength)),
        (label: l.kerfLoss, value: length(result.kerfLoss)),
        (label: l.trimLoss, value: length(result.trimLoss)),
      ],
      bars: [
        for (final bar in result.bars)
          CutReportBar(
            source: bar,
            title: l.barTitle(bar.barIndex + 1, length(bar.stockLength)),
            parts: [
              for (final part in bar.placedParts)
                l.cutOrderPart(
                  part.orderIndex + 1,
                  named(part.name, part.length),
                ),
            ],
            kerfLine: l.resultMetric(l.kerfLoss, length(bar.kerfLoss)),
            trimLine: bar.trimLoss.ticks > 0
                ? l.endTrimPerEnd(length(project.endTrim))
                : null,
            tailLine: l.resultMetric(
              l.leftover,
              bar.tailLeftover.ticks == 0
                  ? length(bar.tailLeftover)
                  : l.classifiedLeftover(
                      length(bar.tailLeftover),
                      bar.isTailReusable ? l.reusable : l.scrap,
                    ),
            ),
          ),
      ],
      unplaced: [
        for (final group in groupUnplaced(result.unplaced))
          CutReportUnplaced(
            source: group.part,
            quantity: group.quantity,
            description: l.lengthQuantity(
              named(group.part.name, group.part.length),
              group.quantity,
            ),
            reason: group.part.reason == UnplacedReason.tooLong
                ? l.tooLongResultReason
                : l.inventoryExhaustedResultReason,
          ),
      ],
    );
  }
}
