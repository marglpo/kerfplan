import '../../domain/optimizer/optimization_bar.dart';

enum BarSegmentKind { part, kerf, tail, trim }

final class BarSegment {
  const BarSegment(this.kind, this.startTicks, this.endTicks, {this.partIndex});
  final BarSegmentKind kind;
  final int startTicks;
  final int endTicks;
  final int? partIndex;
  int get lengthTicks => endTicks - startTicks;
}

/// Layout of existing output only. No placement, waste, or kerf calculation.
/// Tick positions stay exact; floating-point ratios are used only for painting.
final class BarDiagramGeometry {
  BarDiagramGeometry(OptimizationBar bar) : totalTicks = bar.stockLength.ticks {
    var cursor = 0;
    final pieces = <BarSegment>[];
    void add(BarSegmentKind kind, int ticks, {int? index}) {
      if (ticks == 0) return;
      if (ticks < 0 || ticks > totalTicks - cursor) {
        throw StateError('Invalid bar diagram segment');
      }
      pieces.add(BarSegment(kind, cursor, cursor + ticks, partIndex: index));
      cursor += ticks;
    }

    final leftTrim = bar.trimLoss.ticks ~/ 2;
    add(BarSegmentKind.trim, leftTrim);
    for (final part in bar.placedParts) {
      add(BarSegmentKind.part, part.length.ticks, index: part.orderIndex);
      add(BarSegmentKind.kerf, part.kerfAfter.ticks);
    }
    add(BarSegmentKind.tail, bar.tailLeftover.ticks);
    add(BarSegmentKind.trim, bar.trimLoss.ticks - leftTrim);
    if (totalTicks <= 0 || cursor != totalTicks) {
      throw StateError('Bar diagram does not account for the whole stock');
    }
    segments = List.unmodifiable(pieces);
  }
  final int totalTicks;
  late final List<BarSegment> segments;
}
