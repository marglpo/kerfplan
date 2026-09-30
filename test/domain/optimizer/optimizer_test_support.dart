import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/optimizer/optimization_result.dart';
import 'package:kerfplan/domain/units/length.dart';

Length mm(int value) => Length.fromTicks(value * 10000);

OptimizationStock stock(
  int length, {
  int quantity = 1,
  String id = 'stock',
  int order = 0,
}) => OptimizationStock(
  sourceStockId: id,
  length: mm(length),
  quantity: quantity,
  stableOrder: order,
);

OptimizationPartGroup part(
  int length, {
  int quantity = 1,
  String id = 'part',
  String? name,
  int order = 0,
}) => OptimizationPartGroup(
  sourcePartId: id,
  name: name,
  length: mm(length),
  quantity: quantity,
  stableOrder: order,
);

OptimizationInput fixed(
  List<OptimizationStock> stock,
  List<OptimizationPartGroup> parts, {
  int kerf = 3,
  int trim = 0,
  int reusable = 100,
}) => OptimizationInput(
  mode: InventoryMode.fixed,
  fixedStock: stock,
  parts: parts,
  kerf: mm(kerf),
  endTrim: mm(trim),
  minReusable: mm(reusable),
);

OptimizationInput buy(
  int length,
  List<OptimizationPartGroup> parts, {
  int kerf = 3,
  int trim = 0,
  int reusable = 100,
}) => OptimizationInput(
  mode: InventoryMode.buy,
  buyStockLength: mm(length),
  parts: parts,
  kerf: mm(kerf),
  endTrim: mm(trim),
  minReusable: mm(reusable),
);

OptimizationResult run(OptimizationInput input) {
  final result = const FfdCutOptimizer().optimize(input);
  expectInvariants(input, result);
  return result;
}

void expectTotals(
  OptimizationResult result, {
  required int bars,
  required int placed,
  int unplaced = 0,
  required int finished,
  required int stockUsed,
  required int kerf,
  int trim = 0,
  required int tails,
  required int reusable,
  required int scrap,
  required int waste,
  required double percent,
}) {
  expect(result.barsUsed, bars);
  expect(result.requestedPartCount, placed + unplaced);
  expect(result.placedPartCount, placed);
  expect(result.unplacedPartCount, unplaced);
  expect(result.totalFinishedLength, mm(finished));
  expect(result.totalUsedStockLength, mm(stockUsed));
  expect(result.kerfLoss, mm(kerf));
  expect(result.trimLoss, mm(trim));
  expect(result.tailLeftovers, mm(tails));
  expect(result.reusableLeftovers, mm(reusable));
  expect(result.scrap, mm(scrap));
  expect(result.totalWaste, mm(waste));
  expect(result.wastePercent, closeTo(percent, 0.0000001));
}

/// Independent conservation checks run against every successful contract case.
void expectInvariants(OptimizationInput input, OptimizationResult result) {
  var finished = 0;
  var used = 0;
  var kerf = 0;
  var trim = 0;
  var tails = 0;
  var reusable = 0;
  final identities = <(String, int)>{};
  final physicalBars = <(String, int)>{};
  final groups = {for (final group in input.parts) group.sourcePartId: group};
  for (var i = 0; i < result.bars.length; i++) {
    final bar = result.bars[i];
    expect(bar.barIndex, i);
    expect(bar.placedParts, isNotEmpty);
    final barFinished = bar.placedParts.fold(
      0,
      (sum, part) => sum + part.length.ticks,
    );
    expect(bar.kerfLoss.ticks, (bar.placedParts.length - 1) * input.kerf.ticks);
    expect(bar.trimLoss.ticks, 2 * input.endTrim.ticks);
    expect(bar.tailLeftover.ticks, greaterThanOrEqualTo(0));
    expect(
      barFinished + bar.kerfLoss.ticks + bar.tailLeftover.ticks,
      bar.usableLength.ticks,
    );
    expect(
      barFinished +
          bar.kerfLoss.ticks +
          bar.tailLeftover.ticks +
          bar.trimLoss.ticks,
      bar.stockLength.ticks,
    );
    expect(bar.isTailReusable, bar.tailLeftover >= input.minReusable);
    for (var j = 0; j < bar.placedParts.length; j++) {
      final placed = bar.placedParts[j];
      final group = groups[placed.sourcePartId]!;
      expect(placed.orderIndex, j);
      expect(
        placed.kerfAfter,
        j == bar.placedParts.length - 1 ? mm(0) : input.kerf,
      );
      expect(placed.name, group.name);
      expect(placed.sourceStableOrder, group.stableOrder);
      expect(placed.length, group.length);
      expect(placed.instanceIndex, inInclusiveRange(0, group.quantity - 1));
      expect(
        identities.add((placed.sourcePartId, placed.instanceIndex)),
        isTrue,
      );
    }
    if (input.mode == InventoryMode.fixed) {
      final source = input.fixedStock.singleWhere(
        (row) => row.sourceStockId == bar.sourceStockId,
      );
      expect(bar.stockLength, source.length);
      expect(
        bar.physicalStockInstanceIndex,
        inInclusiveRange(0, source.quantity - 1),
      );
      expect(
        physicalBars.add((bar.sourceStockId!, bar.physicalStockInstanceIndex!)),
        isTrue,
      );
    } else {
      expect(bar.sourceStockId, isNull);
      expect(bar.physicalStockInstanceIndex, isNull);
      expect(bar.stockLength, input.buyStockLength);
    }
    finished += barFinished;
    used += bar.stockLength.ticks;
    kerf += bar.kerfLoss.ticks;
    trim += bar.trimLoss.ticks;
    tails += bar.tailLeftover.ticks;
    if (bar.isTailReusable) reusable += bar.tailLeftover.ticks;
  }
  final placedCount = identities.length;
  for (final unplaced in result.unplaced) {
    final group = groups[unplaced.sourcePartId]!;
    expect(unplaced.name, group.name);
    expect(unplaced.sourceStableOrder, group.stableOrder);
    expect(unplaced.length, group.length);
    expect(unplaced.instanceIndex, inInclusiveRange(0, group.quantity - 1));
    expect(
      identities.add((unplaced.sourcePartId, unplaced.instanceIndex)),
      isTrue,
    );
  }
  expect(result.placedPartCount, placedCount);
  expect(
    result.requestedPartCount,
    input.parts.fold(0, (sum, group) => sum + group.quantity),
  );
  expect(identities.length, result.requestedPartCount);
  expect(result.totalFinishedLength.ticks, finished);
  expect(result.totalUsedStockLength.ticks, used);
  expect(result.kerfLoss.ticks, kerf);
  expect(result.trimLoss.ticks, trim);
  expect(result.tailLeftovers.ticks, tails);
  expect(result.reusableLeftovers.ticks, reusable);
  expect(
    result.totalFinishedLength + result.totalWaste,
    result.totalUsedStockLength,
  );
  expect(
    result.trimLoss + result.kerfLoss + result.tailLeftovers,
    result.totalWaste,
  );
  expect(result.reusableLeftovers + result.scrap, result.totalWaste);
  expect(
    result.barsToBuy,
    input.mode == InventoryMode.buy ? result.barsUsed : null,
  );
}

/// Complete value snapshot without introducing serialization into production.
Object snapshot(OptimizationResult result) => [
  for (final bar in result.bars)
    [
      bar.barIndex,
      bar.sourceStockId,
      bar.physicalStockInstanceIndex,
      bar.stockLength.ticks,
      bar.usableLength.ticks,
      bar.kerfLoss.ticks,
      bar.trimLoss.ticks,
      bar.tailLeftover.ticks,
      bar.isTailReusable,
      for (final part in bar.placedParts)
        [
          part.sourcePartId,
          part.name,
          part.instanceIndex,
          part.sourceStableOrder,
          part.orderIndex,
          part.length.ticks,
          part.kerfAfter.ticks,
        ],
    ],
  [
    for (final part in result.unplaced)
      [
        part.sourcePartId,
        part.name,
        part.instanceIndex,
        part.sourceStableOrder,
        part.length.ticks,
        part.reason,
      ],
  ],
  result.requestedPartCount,
  result.placedPartCount,
  result.unplacedPartCount,
  result.barsUsed,
  result.barsToBuy,
  result.totalFinishedLength.ticks,
  result.totalUsedStockLength.ticks,
  result.kerfLoss.ticks,
  result.trimLoss.ticks,
  result.tailLeftovers.ticks,
  result.reusableLeftovers.ticks,
  result.scrap.ticks,
  result.totalWaste.ticks,
  result.wastePercent,
];
