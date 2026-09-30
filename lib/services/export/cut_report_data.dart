import '../../domain/models/cut_project.dart';
import '../../domain/optimizer/optimization_bar.dart';
import '../../domain/optimizer/optimization_result.dart';
import '../../domain/optimizer/unplaced_part.dart';

typedef ReportMetric = ({String label, String value});

/// One immutable, localized snapshot for text and PDF. The original immutable
/// domain values remain available; all optimization totals come from result.
final class CutReportData {
  CutReportData({
    required this.project,
    required this.result,
    required this.generatedAt,
    required this.brand,
    required this.generatedLabel,
    required this.generatedDate,
    required this.settingsHeading,
    required this.summaryHeading,
    required this.purchaseHeading,
    required this.stockSummary,
    required this.purchaseLine,
    required this.placedSummary,
    required this.wasteHeadline,
    required this.unplacedHeading,
    required this.footer,
    required this.disclaimer,
    required this.fileName,
    required Iterable<ReportMetric> settings,
    required Iterable<ReportMetric> summary,
    required Iterable<CutReportBar> bars,
    required Iterable<CutReportUnplaced> unplaced,
  }) : settings = List.unmodifiable(settings),
       summary = List.unmodifiable(summary),
       bars = List.unmodifiable(bars),
       unplaced = List.unmodifiable(unplaced);

  final CutProject project;
  final OptimizationResult result;
  final DateTime generatedAt;
  final String brand,
      generatedLabel,
      generatedDate,
      settingsHeading,
      summaryHeading;
  final String purchaseHeading, stockSummary, placedSummary, wasteHeadline;
  final String? purchaseLine;
  final String unplacedHeading, footer, disclaimer, fileName;
  final List<ReportMetric> settings, summary;
  final List<CutReportBar> bars;
  final List<CutReportUnplaced> unplaced;
}

final class CutReportBar {
  CutReportBar({
    required this.source,
    required this.title,
    required Iterable<String> parts,
    required this.kerfLine,
    required this.trimLine,
    required this.tailLine,
  }) : parts = List.unmodifiable(parts);
  final OptimizationBar source;
  final String title, kerfLine, tailLine;
  final String? trimLine;
  final List<String> parts;
}

final class CutReportUnplaced {
  const CutReportUnplaced({
    required this.source,
    required this.quantity,
    required this.description,
    required this.reason,
  });
  final UnplacedPart source;
  final int quantity;
  final String description, reason;
}
