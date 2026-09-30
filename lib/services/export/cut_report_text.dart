import 'cut_report_data.dart';

String cutReportText(CutReportData report) => [
  report.project.name,
  ?report.project.material,
  ?report.project.note,
  '${report.generatedLabel}: ${report.generatedDate}',
  '',
  report.settingsHeading,
  for (final metric in report.settings) '${metric.label}: ${metric.value}',
  '',
  report.summaryHeading,
  report.placedSummary,
  report.stockSummary,
  report.wasteHeadline,
  for (final metric in report.summary) '${metric.label}: ${metric.value}',
  if (report.purchaseLine case final purchase?) ...[
    '',
    report.purchaseHeading,
    purchase,
  ],
  if (report.unplaced.isNotEmpty) ...[
    '',
    report.unplacedHeading,
    for (final item in report.unplaced) ...[item.description, item.reason, ''],
  ],
  for (final bar in report.bars) ...[
    '',
    bar.title,
    ...bar.parts,
    bar.kerfLine,
    ?bar.trimLine,
    bar.tailLine,
  ],
  '',
  report.footer,
  report.disclaimer,
].join('\n');
