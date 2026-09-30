import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/presentation/results/bar_diagram_geometry.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/units/length.dart';

import '../../domain/optimizer/optimizer_test_support.dart' as support;

void main() {
  test(
    '400 + kerf 3 + 400 + 197 tail fills exactly 1000 with no trailing kerf',
    () {
      final bar = support
          .run(
            support.fixed(
              [support.stock(1000)],
              [support.part(400, quantity: 2)],
            ),
          )
          .bars
          .single;
      final geometry = BarDiagramGeometry(bar);
      expect(geometry.totalTicks, 10000000);
      expect(geometry.segments.map((s) => s.kind), [
        BarSegmentKind.part,
        BarSegmentKind.kerf,
        BarSegmentKind.part,
        BarSegmentKind.tail,
      ]);
      expect(geometry.segments.map((s) => s.lengthTicks), [
        4000000,
        30000,
        4000000,
        1970000,
      ]);
      expect(geometry.segments.map((s) => s.endTicks), [
        4000000,
        4030000,
        8030000,
        10000000,
      ]);
      expect(
        geometry.segments.fold<double>(
          0,
          (total, s) => total + s.lengthTicks / geometry.totalTicks,
        ),
        closeTo(1, 1e-12),
      );
    },
  );
  test('trim strips occupy both ends of the complete stock', () {
    final bar = support
        .run(
          support.fixed(
            [support.stock(1000)],
            [support.part(400, quantity: 2)],
            trim: 10,
          ),
        )
        .bars
        .single;
    final geometry = BarDiagramGeometry(bar);
    expect(geometry.segments.first.kind, BarSegmentKind.trim);
    expect(geometry.segments.last.kind, BarSegmentKind.trim);
    expect(geometry.segments.first.lengthTicks, 100000);
    expect(geometry.segments.last.lengthTicks, 100000);
    expect(geometry.segments.last.endTicks, 10000000);
  });
  test('exact fit creates no zero tail or phantom kerf segments', () {
    final bar = support
        .run(support.fixed([support.stock(1000)], [support.part(1000)]))
        .bars
        .single;
    final geometry = BarDiagramGeometry(bar);
    expect(geometry.segments, hasLength(1));
    expect(geometry.segments.single.kind, BarSegmentKind.part);
    expect(geometry.segments.single.endTicks, geometry.totalTicks);
  });
  test('one-tick parts retain exact geometry at large stock lengths', () {
    final result = const FfdCutOptimizer().optimize(
      OptimizationInput(
        mode: InventoryMode.buy,
        buyStockLength: Length.fromTicks(Length.maxTicks),
        parts: [
          OptimizationPartGroup(
            sourcePartId: 'tiny',
            length: Length.fromTicks(1),
            quantity: 1,
            stableOrder: 0,
          ),
        ],
        kerf: Length.fromTicks(0),
        endTrim: Length.fromTicks(0),
        minReusable: Length.fromTicks(0),
      ),
    );
    final geometry = BarDiagramGeometry(result.bars.single);
    expect(geometry.segments.first.lengthTicks, 1);
    expect(geometry.segments.last.endTicks, Length.maxTicks);
  });
}
