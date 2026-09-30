import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_failure.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/optimizer/unplaced_part.dart';
import 'package:kerfplan/domain/units/length.dart';

import 'optimizer_test_support.dart';

void main() {
  test('01 exact single part with zero kerf', () {
    expectTotals(
      run(fixed([stock(1000)], [part(1000)], kerf: 0)),
      bars: 1,
      placed: 1,
      finished: 1000,
      stockUsed: 1000,
      kerf: 0,
      tails: 0,
      reusable: 0,
      scrap: 0,
      waste: 0,
      percent: 0,
    );
  });
  test('02 exact single part needs no final kerf', () {
    expectTotals(
      run(fixed([stock(1000)], [part(1000)])),
      bars: 1,
      placed: 1,
      finished: 1000,
      stockUsed: 1000,
      kerf: 0,
      tails: 0,
      reusable: 0,
      scrap: 0,
      waste: 0,
      percent: 0,
    );
  });
  test('03 two 400 parts have one kerf and a 197 tail', () {
    expectTotals(
      run(fixed([stock(1000)], [part(400, quantity: 2)])),
      bars: 1,
      placed: 2,
      finished: 800,
      stockUsed: 1000,
      kerf: 3,
      tails: 197,
      reusable: 197,
      scrap: 3,
      waste: 200,
      percent: 20,
    );
  });
  test('04 too-long part opens no bar and contributes no finished length', () {
    final result = run(fixed([stock(1000)], [part(1200)]));
    expect(result.unplaced.single.reason, UnplacedReason.tooLong);
    expectTotals(
      result,
      bars: 0,
      placed: 0,
      unplaced: 1,
      finished: 0,
      stockUsed: 0,
      kerf: 0,
      tails: 0,
      reusable: 0,
      scrap: 0,
      waste: 0,
      percent: 0,
    );
  });
  test('05 three 2500 parts on two 6000 bars', () {
    final result = run(
      fixed([stock(6000, quantity: 2)], [part(2500, quantity: 3)]),
    );
    expect(result.bars.map((bar) => bar.placedParts.length), [2, 1]);
    expect(result.bars.map((bar) => bar.tailLeftover), [mm(997), mm(3500)]);
    expectTotals(
      result,
      bars: 2,
      placed: 3,
      finished: 7500,
      stockUsed: 12000,
      kerf: 3,
      tails: 4497,
      reusable: 4497,
      scrap: 3,
      waste: 4500,
      percent: 37.5,
    );
  });
  test('06 buy ten 1800 parts on 6000 stock', () {
    final result = run(buy(6000, [part(1800, quantity: 10)]));
    expect(result.barsToBuy, 4);
    expect(result.bars.map((bar) => bar.placedParts.length), [3, 3, 3, 1]);
    expect(result.bars.map((bar) => bar.tailLeftover), [
      mm(594),
      mm(594),
      mm(594),
      mm(4200),
    ]);
    expectTotals(
      result,
      bars: 4,
      placed: 10,
      finished: 18000,
      stockUsed: 24000,
      kerf: 18,
      tails: 5982,
      reusable: 5982,
      scrap: 18,
      waste: 6000,
      percent: 25,
    );
  });
  test('07 mixed stock selects the shortest fitting unopened bar', () {
    final result = run(
      fixed(
        [stock(6000), stock(3000, quantity: 2, id: 'short')],
        [part(5500), part(2500, quantity: 2, id: 'small')],
      ),
    );
    expect(result.bars.map((bar) => bar.stockLength), [
      mm(6000),
      mm(3000),
      mm(3000),
    ]);
    expect(result.bars.map((bar) => bar.tailLeftover), [
      mm(500),
      mm(500),
      mm(500),
    ]);
    expectTotals(
      result,
      bars: 3,
      placed: 3,
      finished: 10500,
      stockUsed: 12000,
      kerf: 0,
      tails: 1500,
      reusable: 1500,
      scrap: 0,
      waste: 1500,
      percent: 12.5,
    );
  });
  test('08 trim is taken from each end, allowing exact usable fit', () {
    final result = run(fixed([stock(1000)], [part(980)], trim: 10));
    expect(result.bars.single.usableLength, mm(980));
    expectTotals(
      result,
      bars: 1,
      placed: 1,
      finished: 980,
      stockUsed: 1000,
      kerf: 0,
      trim: 20,
      tails: 0,
      reusable: 0,
      scrap: 20,
      waste: 20,
      percent: 2,
    );
  });
  test('09 buy fifty 100 parts', () {
    final result = run(buy(1000, [part(100, quantity: 50)]));
    expect(result.barsToBuy, 6);
    expect(result.bars.map((bar) => bar.placedParts.length), [
      9,
      9,
      9,
      9,
      9,
      5,
    ]);
    expect(result.bars.map((bar) => bar.tailLeftover), [
      mm(76),
      mm(76),
      mm(76),
      mm(76),
      mm(76),
      mm(488),
    ]);
    expectTotals(
      result,
      bars: 6,
      placed: 50,
      finished: 5000,
      stockUsed: 6000,
      kerf: 132,
      tails: 868,
      reusable: 488,
      scrap: 512,
      waste: 1000,
      percent: 16.6666667,
    );
  });
  test('10 invalid part length and quantity return typed failures', () {
    for (final invalid in [
      part(0),
      part(1, quantity: 0),
      part(1, quantity: -1),
    ]) {
      expect(
        () => const FfdCutOptimizer().optimize(fixed([stock(1000)], [invalid])),
        throwsA(
          isA<OptimizationValidationException>().having(
            (e) => e.reason,
            'reason',
            OptimizationFailure.invalidPart,
          ),
        ),
      );
    }
    // Negative measurements cannot be constructed in the shared Length type.
    expect(() => Length.fromTicks(-1), throwsRangeError);
  });
  test('11 exact imperial eight-foot stock and sixteenth-inch part', () {
    final result = run(
      OptimizationInput(
        mode: InventoryMode.fixed,
        fixedStock: [
          OptimizationStock(
            sourceStockId: '8ft',
            length: Length.fromInchFraction(96, 1),
            quantity: 1,
            stableOrder: 0,
          ),
        ],
        parts: [
          OptimizationPartGroup(
            sourcePartId: 'sixteenth',
            length: Length.fromInchFraction(1, 16),
            quantity: 1,
            stableOrder: 0,
          ),
        ],
        kerf: mm(3),
        endTrim: mm(0),
        minReusable: mm(100),
      ),
    );
    expect(result.placedPartCount, 1);
    expect(result.totalUsedStockLength.ticks, 24384000);
    expect(result.totalFinishedLength.ticks, 15875);
    expect(result.kerfLoss.ticks, 0);
    expect(result.tailLeftovers.ticks, 24368125);
    expect(result.reusableLeftovers.ticks, 24368125);
    expect(result.scrap.ticks, 0);
  });
  test('12 reusable boundary is inclusive', () {
    final result = run(fixed([stock(1000)], [part(900)], kerf: 0));
    expect(result.bars.single.isTailReusable, isTrue);
    expectTotals(
      result,
      bars: 1,
      placed: 1,
      finished: 900,
      stockUsed: 1000,
      kerf: 0,
      tails: 100,
      reusable: 100,
      scrap: 0,
      waste: 100,
      percent: 10,
    );
  });
  test('13 tail one below threshold is scrap', () {
    final result = run(fixed([stock(1000)], [part(901)], kerf: 0));
    expect(result.bars.single.isTailReusable, isFalse);
    expectTotals(
      result,
      bars: 1,
      placed: 1,
      finished: 901,
      stockUsed: 1000,
      kerf: 0,
      tails: 99,
      reusable: 0,
      scrap: 99,
      waste: 99,
      percent: 9.9,
    );
  });
  test('14 kerf changes whether two 499 parts share a bar', () {
    expectTotals(
      run(buy(1000, [part(499, quantity: 2)], kerf: 1)),
      bars: 1,
      placed: 2,
      finished: 998,
      stockUsed: 1000,
      kerf: 1,
      tails: 1,
      reusable: 0,
      scrap: 2,
      waste: 2,
      percent: 0.2,
    );
    final result = run(buy(1000, [part(499, quantity: 2)], kerf: 3));
    expect(result.bars.map((bar) => bar.tailLeftover), [mm(501), mm(501)]);
    expectTotals(
      result,
      bars: 2,
      placed: 2,
      finished: 998,
      stockUsed: 2000,
      kerf: 0,
      tails: 1002,
      reusable: 1002,
      scrap: 0,
      waste: 1002,
      percent: 50.1,
    );
  });
  test('15 consumed stock is inventory exhausted, not too long', () {
    final result = run(fixed([stock(1000)], [part(900, quantity: 2)]));
    expect(result.bars.single.placedParts.single.instanceIndex, 0);
    expect(result.unplaced.single.instanceIndex, 1);
    expect(result.unplaced.single.reason, UnplacedReason.inventoryExhausted);
    expectTotals(
      result,
      bars: 1,
      placed: 1,
      unplaced: 1,
      finished: 900,
      stockUsed: 1000,
      kerf: 0,
      tails: 100,
      reusable: 100,
      scrap: 0,
      waste: 100,
      percent: 10,
    );
  });
  test('16 complete output and explicit tie order are deterministic', () {
    final stocks = [
      stock(1000, id: 'b', quantity: 2),
      stock(1000, id: 'a', quantity: 2),
    ];
    final parts = [
      part(1000, id: 'b', quantity: 2),
      part(1000, id: 'a', quantity: 2),
    ];
    final result = run(fixed(stocks, parts));
    expect(
      result.bars.map(
        (bar) => (bar.sourceStockId, bar.physicalStockInstanceIndex),
      ),
      [('a', 0), ('b', 0), ('a', 1), ('b', 1)],
    );
    expect(
      result.bars.map(
        (bar) => (
          bar.placedParts.single.sourcePartId,
          bar.placedParts.single.instanceIndex,
        ),
      ),
      [('a', 0), ('b', 0), ('a', 1), ('b', 1)],
    );
    for (var i = 0; i < 12; i++) {
      expect(
        snapshot(
          run(
            fixed(
              i.isEven ? stocks.reversed.toList() : stocks,
              i.isEven ? parts.reversed.toList() : parts,
            ),
          ),
        ),
        snapshot(result),
      );
    }
  });
  test('17 equal-length groups retain labels and source identities', () {
    final result = run(
      buy(6000, [
        part(1800, quantity: 2, id: 'frame', name: 'Frame', order: 0),
        part(1800, quantity: 2, id: 'shelf', name: 'Shelf', order: 1),
      ]),
    );
    expect(
      result.bars
          .expand((bar) => bar.placedParts)
          .map((p) => (p.sourcePartId, p.name, p.instanceIndex)),
      [
        ('frame', 'Frame', 0),
        ('frame', 'Frame', 1),
        ('shelf', 'Shelf', 0),
        ('shelf', 'Shelf', 1),
      ],
    );
  });
  test('18 kerfAfter ends with zero', () {
    final result = run(fixed([stock(1000)], [part(300, quantity: 3)]));
    expect(result.bars.single.placedParts.map((p) => p.kerfAfter), [
      mm(3),
      mm(3),
      mm(0),
    ]);
    expectTotals(
      result,
      bars: 1,
      placed: 3,
      finished: 900,
      stockUsed: 1000,
      kerf: 6,
      tails: 94,
      reusable: 0,
      scrap: 100,
      waste: 100,
      percent: 10,
    );
  });
  test('19 trim plus kerf plus tail equals total waste', () {
    final result = run(
      fixed([stock(1000)], [part(400, quantity: 2)], trim: 10),
    );
    expect(result.bars.single.usableLength, mm(980));
    expectTotals(
      result,
      bars: 1,
      placed: 2,
      finished: 800,
      stockUsed: 1000,
      kerf: 3,
      trim: 20,
      tails: 177,
      reusable: 177,
      scrap: 23,
      waste: 200,
      percent: 20,
    );
  });
  test('20 shortest unopened stock wins over input order', () {
    final result = run(
      fixed([stock(6000), stock(3000, id: 'short')], [part(2500)]),
    );
    expect(result.bars.single.sourceStockId, 'short');
    expect(result.totalUsedStockLength, mm(3000));
  });
  test('21 decreasing sort handles long part before short part', () {
    final result = run(
      fixed(
        [stock(3000, id: 'short'), stock(6000, id: 'long')],
        [part(2500, id: 'small'), part(5500, id: 'large')],
      ),
    );
    expect(result.placedPartCount, 2);
    expect(
      result.bars.map(
        (bar) => (bar.sourceStockId, bar.placedParts.single.sourcePartId),
      ),
      [('long', 'large'), ('short', 'small')],
    );
  });
  test('22 unused inventory contributes no waste or stock usage', () {
    expectTotals(
      run(fixed([stock(1000, quantity: 10)], [part(900)])),
      bars: 1,
      placed: 1,
      finished: 900,
      stockUsed: 1000,
      kerf: 0,
      tails: 100,
      reusable: 100,
      scrap: 0,
      waste: 100,
      percent: 10,
    );
  });
  test('23 buy stock consumed entirely by trims is invalid', () {
    expect(
      () => const FfdCutOptimizer().optimize(buy(20, [part(1)], trim: 10)),
      throwsA(
        isA<OptimizationValidationException>().having(
          (e) => e.reason,
          'reason',
          OptimizationFailure.noUsableBuyStock,
        ),
      ),
    );
  });
  test('24 unusable fixed stock is ignored safely', () {
    final result = run(
      fixed([stock(20, id: 'unusable'), stock(1000)], [part(900)], trim: 10),
    );
    expect(result.bars.single.sourceStockId, 'stock');
    expect(result.placedPartCount, 1);
  });
  test('25 counts include unplaced requests but finished length does not', () {
    final result = run(
      fixed([stock(1000)], [part(900), part(1200, quantity: 2, id: 'large')]),
    );
    expect(result.unplaced.map((p) => p.reason), [
      UnplacedReason.tooLong,
      UnplacedReason.tooLong,
    ]);
    expectTotals(
      result,
      bars: 1,
      placed: 1,
      unplaced: 2,
      finished: 900,
      stockUsed: 1000,
      kerf: 0,
      tails: 100,
      reusable: 100,
      scrap: 0,
      waste: 100,
      percent: 10,
    );
  });
}
