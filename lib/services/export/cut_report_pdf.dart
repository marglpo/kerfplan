import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'cut_report_data.dart';
import 'pdf_bar_diagram.dart';

/// PDF-native, paginated report. Font bytes come only from the app bundle.
final class CutReportPdf {
  CutReportPdf({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;
  final AssetBundle _bundle;

  Future<Uint8List> build(CutReportData report) async {
    final regular = pw.Font.ttf(
      await _bundle.load('assets/fonts/NotoSans-Regular.ttf'),
    );
    final bold = pw.Font.ttf(
      await _bundle.load('assets/fonts/NotoSans-Bold.ttf'),
    );
    final symbols = pw.Font.ttf(
      await _bundle.load('assets/fonts/NotoSansMath-Regular.ttf'),
    );
    final document = pw.Document(
      title: report.project.name,
      author: report.brand,
      creator: report.brand,
      theme: pw.ThemeData.withFont(
        base: regular,
        bold: bold,
        italic: regular,
        boldItalic: bold,
        fontFallback: [symbols],
      ),
    );
    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        // A bar/part can span pages; don't inherit MultiPage's 20-page limit.
        maxPages:
            20 +
            report.result.placedPartCount +
            report.bars.length * 2 +
            report.unplaced.length,
        footer: (context) => pw.Padding(
          padding: const pw.EdgeInsets.only(top: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Divider(color: PdfColors.grey600),
              pw.Text(
                report.disclaimer,
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    report.footer,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  pw.Text(
                    '${context.pageNumber} / ${context.pagesCount}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ],
          ),
        ),
        build: (_) => [
          pw.Text(
            report.brand,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            report.project.name,
            style: pw.TextStyle(fontSize: 21, fontWeight: pw.FontWeight.bold),
          ),
          if (report.project.material case final material?)
            pw.Text(material, style: const pw.TextStyle(fontSize: 12)),
          if (report.project.note case final note?)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 6),
              child: pw.Text(note, style: const pw.TextStyle(fontSize: 10)),
            ),
          pw.SizedBox(height: 6),
          pw.Text(
            '${report.generatedLabel}: ${report.generatedDate}',
            style: const pw.TextStyle(fontSize: 9),
          ),
          _heading(report.settingsHeading),
          _metrics(report.settings),
          _heading(report.summaryHeading),
          pw.Text(
            report.stockSummary,
            style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            report.placedSummary,
            style: const pw.TextStyle(fontSize: 11),
          ),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            child: pw.Text(
              report.wasteHeadline,
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          _metrics(report.summary),
          if (report.purchaseLine case final purchase?)
            pw.Container(
              margin: const pw.EdgeInsets.only(top: 12),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 1.5)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    report.purchaseHeading,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    purchase,
                    style: pw.TextStyle(
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          if (report.unplaced.isNotEmpty) ...[
            pw.NewPage(freeSpace: 90),
            pw.SizedBox(height: 14),
            pw.Table(
              columnWidths: {0: const pw.FlexColumnWidth()},
              children: [
                pw.TableRow(
                  repeat: true,
                  children: [_heading(report.unplacedHeading)],
                ),
                for (final item in report.unplaced)
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              item.description,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Text(
                              item.reason,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
          for (final bar in report.bars) ...[
            pw.NewPage(freeSpace: 130),
            pw.SizedBox(height: 14),
            // Repeating bar heading identifies cuts even when one bar's long
            // cutting list continues onto another page. Individual rows wrap.
            // Short lists stay with their diagram and leftover on one page.
            pw.Inseparable(
              canSpan: bar.parts.length > 8,
              child: pw.Table(
                columnWidths: {0: const pw.FlexColumnWidth()},
                children: [
                  pw.TableRow(repeat: true, children: [_heading(bar.title)]),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 9),
                        child: pdfBarDiagram(bar.source),
                      ),
                    ],
                  ),
                  for (final part in bar.parts)
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 3),
                          child: pw.Text(
                            part,
                            style: const pw.TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              bar.kerfLine,
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                            if (bar.trimLine case final trim?)
                              pw.Text(
                                trim,
                                style: const pw.TextStyle(fontSize: 10),
                              ),
                            pw.Text(
                              bar.tailLine,
                              style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _heading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 10, bottom: 7),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
    ),
  );

  pw.Widget _metrics(List<ReportMetric> metrics) => pw.Table(
    columnWidths: {
      0: const pw.FlexColumnWidth(),
      1: const pw.FlexColumnWidth(),
    },
    border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
    children: [
      for (var i = 0; i < metrics.length; i += 2)
        pw.TableRow(
          children: [
            for (var j = i; j < i + 2; j++)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                child: j >= metrics.length
                    ? pw.SizedBox()
                    : pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            metrics[j].label,
                            style: const pw.TextStyle(fontSize: 8),
                          ),
                          pw.Text(
                            metrics[j].value,
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
          ],
        ),
    ],
  );
}
