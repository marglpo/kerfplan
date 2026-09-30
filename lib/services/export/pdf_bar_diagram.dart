import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../domain/optimizer/optimization_bar.dart';
import '../../presentation/results/bar_diagram_geometry.dart';

/// Uses the same tested tick segments as the on-screen diagram. Only page
/// coordinates are doubles; no measurements or optimizer totals are derived.
pw.Widget pdfBarDiagram(OptimizationBar bar) {
  final geometry = BarDiagramGeometry(bar);
  return pw.LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints!.maxWidth;
      const height = 36.0;
      return pw.Stack(
        children: [
          pw.CustomPaint(
            size: PdfPoint(width, height),
            painter: (canvas, size) {
              for (final segment in geometry.segments) {
                final left = segment.startTicks / geometry.totalTicks * size.x;
                final right = segment.endTicks / geometry.totalTicks * size.x;
                canvas
                  ..setFillColor(switch (segment.kind) {
                    BarSegmentKind.part => PdfColors.grey200,
                    BarSegmentKind.kerf => PdfColors.black,
                    BarSegmentKind.tail =>
                      bar.isTailReusable ? PdfColors.white : PdfColors.grey300,
                    BarSegmentKind.trim => PdfColors.grey400,
                  })
                  ..drawRect(left, 0, right - left, size.y)
                  ..fillPath();
                canvas
                  ..setStrokeColor(PdfColors.grey700)
                  ..setLineWidth(0.5);
                if (segment.kind == BarSegmentKind.kerf) {
                  canvas
                    ..drawLine(
                      (left + right) / 2,
                      0,
                      (left + right) / 2,
                      size.y,
                    )
                    ..strokePath();
                } else {
                  canvas
                    ..drawRect(left, 0, right - left, size.y)
                    ..strokePath();
                }
                if (segment.kind == BarSegmentKind.trim ||
                    (segment.kind == BarSegmentKind.tail &&
                        !bar.isTailReusable)) {
                  canvas
                    ..saveContext()
                    ..drawRect(left, 0, right - left, size.y)
                    ..clipPath();
                  for (var x = left - size.y; x < right; x += 8) {
                    canvas
                      ..drawLine(x, 0, x + size.y, size.y)
                      ..strokePath();
                  }
                  canvas.restoreContext();
                }
              }
              canvas
                ..setStrokeColor(PdfColors.black)
                ..setLineWidth(1)
                ..drawRect(0, 0, size.x, size.y)
                ..strokePath();
            },
          ),
          for (final segment in geometry.segments)
            if (segment.kind == BarSegmentKind.part &&
                segment.lengthTicks / geometry.totalTicks * width >=
                    12 + '${segment.partIndex! + 1}'.length * 7)
              pw.Positioned(
                left: segment.startTicks / geometry.totalTicks * width,
                top: 10,
                child: pw.SizedBox(
                  width: segment.lengthTicks / geometry.totalTicks * width,
                  child: pw.Center(
                    child: pw.Text(
                      '${segment.partIndex! + 1}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
        ],
      );
    },
  );
}
