import 'package:flutter/material.dart';

import '../../domain/optimizer/optimization_bar.dart';
import 'bar_diagram_geometry.dart';

class CutBarDiagram extends StatelessWidget {
  const CutBarDiagram({
    super.key,
    required this.bar,
    required this.description,
  });
  final OptimizationBar bar;
  final String description;

  @override
  Widget build(BuildContext context) => Semantics(
    label: description,
    image: true,
    container: true,
    child: ExcludeSemantics(
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: CustomPaint(
          painter: _BarPainter(
            bar,
            Theme.of(context).colorScheme,
            MediaQuery.textScalerOf(context),
          ),
        ),
      ),
    ),
  );
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.bar, this.colors, this.textScaler)
    : geometry = BarDiagramGeometry(bar);
  final OptimizationBar bar;
  final BarDiagramGeometry geometry;
  final ColorScheme colors;
  final TextScaler textScaler;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final bounds = Offset.zero & size;
    canvas.save();
    canvas.clipRect(bounds);
    for (final segment in geometry.segments) {
      final left = segment.startTicks / geometry.totalTicks * size.width;
      final right = segment.endTicks / geometry.totalTicks * size.width;
      final rect = Rect.fromLTRB(left, 0, right, size.height);
      final color = switch (segment.kind) {
        BarSegmentKind.part => colors.primaryContainer,
        BarSegmentKind.kerf => colors.onSurface,
        BarSegmentKind.tail =>
          bar.isTailReusable
              ? colors.tertiaryContainer
              : colors.surfaceContainerHighest,
        BarSegmentKind.trim => colors.surfaceContainerHighest,
      };
      canvas.drawRect(rect, Paint()..color = color);
      if (segment.kind == BarSegmentKind.kerf) {
        // A minimum-width marker doesn't change the proportional segment layout.
        canvas.drawLine(
          Offset((left + right) / 2, 0),
          Offset((left + right) / 2, size.height),
          Paint()
            ..color = colors.onSurface
            ..strokeWidth = 1,
        );
      } else {
        canvas.drawRect(
          rect,
          Paint()
            ..color = colors.outline
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.75,
        );
      }
      if (segment.kind == BarSegmentKind.trim ||
          (segment.kind == BarSegmentKind.tail && !bar.isTailReusable)) {
        canvas.save();
        canvas.clipRect(rect);
        for (var x = left - size.height; x < right; x += 10) {
          canvas.drawLine(
            Offset(x, size.height),
            Offset(x + size.height, 0),
            Paint()
              ..color = colors.outline
              ..strokeWidth = 1,
          );
        }
        canvas.restore();
      }
      if (segment.kind == BarSegmentKind.part && rect.width >= 24) {
        final text = TextPainter(
          text: TextSpan(
            text: '${segment.partIndex! + 1}',
            style: TextStyle(
              color: colors.onPrimaryContainer,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
          textScaler: textScaler,
        )..layout();
        if (text.width + 8 <= rect.width && text.height + 8 <= rect.height) {
          text.paint(
            canvas,
            Offset(
              left + (rect.width - text.width) / 2,
              (rect.height - text.height) / 2,
            ),
          );
        }
        text.dispose();
      }
    }
    canvas.restore();
    canvas.drawRect(
      bounds.deflate(1),
      Paint()
        ..color = colors.onSurface
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.bar != bar ||
      oldDelegate.colors != colors ||
      oldDelegate.textScaler != textScaler;
}
