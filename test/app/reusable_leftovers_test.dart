import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/reusable_leftovers.dart';
import 'package:kerfplan/domain/optimizer/optimization_bar.dart';
import 'package:kerfplan/domain/optimizer/optimization_result.dart';
import 'package:kerfplan/domain/units/length.dart';

Length ticks(int value) => Length.fromTicks(value);
OptimizationResult tails(List<(int, bool)> values) => OptimizationResult(
  bars: [
    for (var i = 0; i < values.length; i++)
      OptimizationBar(
        barIndex: i,
        sourceStockId: 'stock-$i',
        physicalStockInstanceIndex: 0,
        stockLength: ticks(60000000),
        usableLength: ticks(59800000),
        placedParts: [],
        kerfLoss: ticks(30000),
        trimLoss: ticks(200000),
        tailLeftover: ticks(values[i].$1),
        isTailReusable: values[i].$2,
      ),
  ],
  unplaced: [],
  requestedPartCount: 0,
  totalFinishedLength: ticks(0),
  totalUsedStockLength: ticks(0),
  kerfLoss: ticks(0),
  trimLoss: ticks(0),
  tailLeftovers: ticks(0),
  reusableLeftovers: ticks(0),
  scrap: ticks(0),
  totalWaste: ticks(0),
  barsToBuy: null,
);

void main() {
  test('groups exact tails in first appearance order with null labels', () {
    final groups = groupReusableLeftovers(
      tails([(9970000, true), (9970000, true), (35000000, true)]),
    );
    expect(groups.map((g) => (g.length.ticks, g.quantity)), [
      (9970000, 2),
      (35000000, 1),
    ]);
    expect(groups.every((g) => g.label == null), isTrue);
  });
  test('ignores scrap and zero even when optimizer marks zero reusable', () {
    expect(
      groupReusableLeftovers(tails([(9999999, false), (0, true), (0, false)])),
      isEmpty,
    );
  });
  test('does not infer stock from kerf, trim or aggregate totals', () {
    expect(groupReusableLeftovers(tails([(0, false)])), isEmpty);
  });
  test(
    'preserves sub-millimeter ticks instead of grouping formatted values',
    () {
      final groups = groupReusableLeftovers(
        tails([(15875, true), (15876, true), (15875, true)]),
      );
      expect(groups.map((g) => (g.length.ticks, g.quantity)), [
        (15875, 2),
        (15876, 1),
      ]);
    },
  );
  test('does not reinterpret optimizer classification', () {
    final groups = groupReusableLeftovers(
      tails([(1, true), (100000000, false)]),
    );
    expect(groups.single.length.ticks, 1);
  });
  test('large equal groups respect existing quantity bounds without dropping pieces', () {
    final groups = groupReusableLeftovers(
      tails(List.filled(10001, (15875, true))),
    );
    expect(groups.map((g) => g.quantity), [9999, 2]);
    expect(groups.every((g) => g.length.ticks == 15875), isTrue);
  });
}
