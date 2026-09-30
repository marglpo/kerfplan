import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_failure.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/optimizer/unplaced_part.dart';
import 'package:kerfplan/domain/units/length.dart';

import 'optimizer_test_support.dart';

void main() {
  const optimizer = FfdCutOptimizer();
  Matcher failure(OptimizationFailure reason) => throwsA(
    isA<OptimizationValidationException>().having(
      (error) => error.reason,
      'reason',
      reason,
    ),
  );

  test(
    'FFD heuristic uses three bars where a feasible two-bar packing exists',
    () {
      // 6+2+2 and 5+3+2 fit two 10 bars. FFD deliberately retains its baseline:
      // [6,3], [5,2,2], [2]. This is not a minimum-waste guarantee.
      final result = run(
        buy(
          10,
          [
            part(6, id: 'six'),
            part(5, id: 'five'),
            part(3, id: 'three'),
            part(2, id: 'two', quantity: 3),
          ],
          kerf: 0,
          reusable: 0,
        ),
      );
      expect(result.bars.map((bar) => bar.placedParts.map((p) => p.length)), [
        [mm(6), mm(3)],
        [mm(5), mm(2), mm(2)],
        [mm(2)],
      ]);
      expect(result.totalUsedStockLength, mm(30));
      expect(result.totalFinishedLength, mm(20));
      expect(result.totalWaste, mm(10));
      expect(6 + 2 + 2, 10);
      expect(5 + 3 + 2, 10);
    },
  );

  test('open bars use first fit, not best fit', () {
    final result = run(
      buy(10, [
        part(8, id: '8'),
        part(6, id: '6'),
        part(3, id: '3'),
        part(1, id: '1'),
      ], kerf: 0),
    );
    // Before 1: first bar has 2 free, second has 1. First fit chooses bar zero.
    expect(
      result.bars.map((bar) => bar.placedParts.map((p) => p.sourcePartId)),
      [
        ['8', '1'],
        ['6', '3'],
      ],
    );
  });

  test(
    'a fitting open bar is preferred to an unopened exact-fit stock bar',
    () {
      final result = run(
        fixed(
          [stock(1000), stock(100, id: 'exact')],
          [part(800, id: 'large'), part(100, id: 'small')],
          kerf: 0,
        ),
      );
      expect(result.barsUsed, 1);
      expect(result.bars.single.sourceStockId, 'stock');
      expect(result.bars.single.placedParts.length, 2);
    },
  );

  test('stable source order precedes instance index and source ID', () {
    final result = run(
      fixed(
        [
          stock(1000, id: 'a', order: 2, quantity: 2),
          stock(1000, id: 'z', order: 1, quantity: 2),
        ],
        [
          part(1000, id: 'a', order: 2, quantity: 2),
          part(1000, id: 'z', order: 1, quantity: 2),
        ],
      ),
    );
    expect(
      result.bars.map(
        (bar) => (bar.sourceStockId, bar.physicalStockInstanceIndex),
      ),
      [('z', 0), ('z', 1), ('a', 0), ('a', 1)],
    );
    expect(
      result.bars.map(
        (bar) => (
          bar.placedParts.single.sourcePartId,
          bar.placedParts.single.instanceIndex,
        ),
      ),
      [('z', 0), ('z', 1), ('a', 0), ('a', 1)],
    );
  });

  test('empty fixed jobs return all-zero accounting even without stock', () {
    expectTotals(
      run(fixed([], [])),
      bars: 0,
      placed: 0,
      finished: 0,
      stockUsed: 0,
      kerf: 0,
      tails: 0,
      reusable: 0,
      scrap: 0,
      waste: 0,
      percent: 0,
    );
    expect(run(fixed([stock(1000)], [])).barsToBuy, isNull);
  });

  test('empty Buy job opens no bars; oversized Buy parts are only tooLong', () {
    expect(run(buy(1000, [])).barsToBuy, 0);
    final result = run(buy(1000, [part(1200, quantity: 3)]));
    expect(result.barsToBuy, 0);
    expect(
      result.unplaced.map((p) => p.reason),
      everyElement(UnplacedReason.tooLong),
    );
    expect(result.wastePercent, 0.0);
  });

  test('Fixed demand without configured stock fails clearly', () {
    expect(
      () => optimizer.optimize(fixed([], [part(1)])),
      failure(OptimizationFailure.noFixedStock),
    );
  });

  test(
    'all configured fixed stock unusable after trim makes parts tooLong',
    () {
      final result = run(
        fixed(
          [stock(20), stock(19, id: 'short')],
          [part(1, quantity: 2)],
          trim: 10,
        ),
      );
      expect(result.bars, isEmpty);
      expect(
        result.unplaced.map((p) => p.reason),
        everyElement(UnplacedReason.tooLong),
      );
      expect(result.totalWaste, mm(0));
    },
  );

  test(
    'Buy requires a positive length and usable stock even with no requests',
    () {
      final missing = OptimizationInput(
        mode: InventoryMode.buy,
        parts: [],
        kerf: mm(0),
        endTrim: mm(0),
        minReusable: mm(0),
      );
      expect(
        () => optimizer.optimize(missing),
        failure(OptimizationFailure.missingBuyStock),
      );
      for (final input in [
        buy(0, []),
        buy(19, [], trim: 10),
        buy(20, [], trim: 10),
      ]) {
        expect(
          () => optimizer.optimize(input),
          failure(OptimizationFailure.noUsableBuyStock),
        );
      }
    },
  );

  test('invalid stock lengths, quantities, orders and identities reject', () {
    for (final invalid in [
      stock(0),
      stock(1, quantity: 0),
      stock(1, quantity: -1),
      stock(1, order: -1),
      stock(1, id: ''),
    ]) {
      expect(
        () => optimizer.optimize(fixed([invalid], [])),
        failure(OptimizationFailure.invalidStock),
      );
    }
    expect(
      () => optimizer.optimize(fixed([stock(1), stock(2)], [])),
      failure(OptimizationFailure.invalidStock),
    );
  });

  test(
    'invalid part order and duplicate identities reject before expansion',
    () {
      for (final invalid in [part(1, order: -1), part(1, id: '')]) {
        expect(
          () => optimizer.optimize(buy(1000, [invalid])),
          failure(OptimizationFailure.invalidPart),
        );
      }
      expect(
        () => optimizer.optimize(buy(1000, [part(1), part(2)])),
        failure(OptimizationFailure.invalidPart),
      );
    },
  );

  test('Length prevents negative kerf, trim and reusable threshold at construction', () {
    for (var i = 0; i < 3; i++) {
      expect(
        () => OptimizationInput(
          mode: InventoryMode.fixed,
          parts: [],
          kerf: Length.fromTicks(i == 0 ? -1 : 0),
          endTrim: Length.fromTicks(i == 1 ? -1 : 0),
          minReusable: Length.fromTicks(i == 2 ? -1 : 0),
        ),
        throwsRangeError,
      );
    }
  });

  test(
    'zero reusable threshold never reclassifies kerf or trim as reusable',
    () {
      final result = run(
        buy(1000, [part(400, quantity: 2)], trim: 10, reusable: 0),
      );
      expect(result.reusableLeftovers, mm(177));
      expect(result.scrap, mm(23));
      final exact = run(buy(1000, [part(980)], trim: 10, reusable: 0));
      expect(
        exact.bars.single.isTailReusable,
        isTrue,
      ); // Inclusive threshold, zero value.
      expect(exact.reusableLeftovers, mm(0));
      expect(exact.scrap, mm(20));
    },
  );

  test('input and nested result lists are immutable and optimization has no side effects', () {
    final stocks = [stock(1000, quantity: 2)];
    final parts = [part(100, id: 'small'), part(900, id: 'large')];
    final input = fixed(stocks, parts);
    final beforeParts = List.of(parts);
    final beforeStocks = List.of(stocks);
    final result = run(input);
    expect(parts, beforeParts);
    expect(stocks, beforeStocks);
    expect(input.parts.map((p) => p.sourcePartId), ['small', 'large']);
    stocks.clear();
    parts.clear();
    expect(input.fixedStock, hasLength(1));
    expect(input.parts, hasLength(2));
    expect(() => input.parts.clear(), throwsUnsupportedError);
    expect(() => input.fixedStock.clear(), throwsUnsupportedError);
    expect(() => result.bars.clear(), throwsUnsupportedError);
    expect(() => result.bars.first.placedParts.clear(), throwsUnsupportedError);
    expect(() => result.unplaced.clear(), throwsUnsupportedError);
    expect(snapshot(run(input)), snapshot(result));
  });

  test(
    'huge unused physical inventory is not expanded or counted as waste',
    () {
      final result = run(
        fixed([stock(1000, quantity: Length.maxTicks)], [part(900)]),
      );
      expect(result.barsUsed, 1);
      expect(result.totalUsedStockLength, mm(1000));
    },
  );

  test('maximum Length and huge kerf do not overflow capacity checks', () {
    final maximum = Length.fromTicks(Length.maxTicks);
    final exact = OptimizationInput(
      mode: InventoryMode.buy,
      buyStockLength: maximum,
      parts: [
        OptimizationPartGroup(
          sourcePartId: 'max',
          length: maximum,
          quantity: 1,
          stableOrder: 0,
        ),
      ],
      kerf: maximum,
      endTrim: mm(0),
      minReusable: maximum,
    );
    expect(run(exact).totalWaste.ticks, 0);
    final input = OptimizationInput(
      mode: InventoryMode.fixed,
      fixedStock: [
        OptimizationStock(
          sourceStockId: 'max',
          length: maximum,
          quantity: 1,
          stableOrder: 0,
        ),
      ],
      parts: [
        OptimizationPartGroup(
          sourcePartId: 'tiny',
          length: Length.fromTicks(1),
          quantity: 2,
          stableOrder: 0,
        ),
      ],
      kerf: maximum,
      endTrim: mm(0),
      minReusable: mm(0),
    );
    final result = run(input);
    expect(result.placedPartCount, 1);
    expect(result.unplaced.single.reason, UnplacedReason.inventoryExhausted);
    expect(result.tailLeftovers.ticks, Length.maxTicks - 1);
  });

  test(
    'trims near integer limits are classified without multiplication overflow',
    () {
      final maximum = Length.fromTicks(Length.maxTicks);
      final input = OptimizationInput(
        mode: InventoryMode.fixed,
        fixedStock: [
          OptimizationStock(
            sourceStockId: 'max',
            length: maximum,
            quantity: 1,
            stableOrder: 0,
          ),
        ],
        parts: [part(1)],
        kerf: mm(0),
        endTrim: maximum,
        minReusable: mm(0),
      );
      expect(run(input).unplaced.single.reason, UnplacedReason.tooLong);
      final nearHalf = OptimizationInput(
        mode: InventoryMode.buy,
        buyStockLength: maximum,
        parts: [
          OptimizationPartGroup(
            sourcePartId: 'tick',
            length: Length.fromTicks(1),
            quantity: 1,
            stableOrder: 0,
          ),
        ],
        kerf: maximum,
        endTrim: Length.fromTicks(Length.maxTicks ~/ 2),
        minReusable: mm(0),
      );
      final result = run(nearHalf);
      expect(result.bars.single.usableLength.ticks, 1);
      expect(result.trimLoss.ticks, Length.maxTicks - 1);
    },
  );

  test(
    'aggregate length overflow is a typed failure rather than wrapped output',
    () {
      final maximum = Length.fromTicks(Length.maxTicks);
      final input = OptimizationInput(
        mode: InventoryMode.buy,
        buyStockLength: maximum,
        parts: [
          OptimizationPartGroup(
            sourcePartId: 'max',
            length: maximum,
            quantity: 2,
            stableOrder: 0,
          ),
        ],
        kerf: mm(0),
        endTrim: mm(0),
        minReusable: mm(0),
      );
      expect(
        () => optimizer.optimize(input),
        failure(OptimizationFailure.arithmeticOverflow),
      );
    },
  );

  test('requested count overflow rejects before quantity expansion', () {
    expect(
      () => optimizer.optimize(
        buy(1000, [part(1, quantity: Length.maxTicks), part(1, id: 'other')]),
      ),
      failure(OptimizationFailure.arithmeticOverflow),
    );
  });

  test('varied deterministic workloads conserve length and identities in both modes', () {
    for (var seed = 0; seed < 40; seed++) {
      final parts = [
        for (var i = 0; i < 9; i++)
          part(
            1 + (seed * 83 + i * 199) % 2100,
            id: 'part-$i',
            name: i.isEven ? 'Group $i' : null,
            quantity: 1 + (seed + i) % 5,
            order: i % 3,
          ),
      ];
      final stocks = [
        for (var i = 0; i < 4; i++)
          stock(
            500 + i * 500,
            id: 'stock-$i',
            quantity: 1 + (seed + i) % 3,
            order: i % 2,
          ),
      ];
      final kerf = seed % 7;
      final trim = seed % 13;
      final threshold = seed * 5;
      final fixedResult = run(
        fixed(stocks, parts, kerf: kerf, trim: trim, reusable: threshold),
      );
      final buyResult = run(
        buy(2000, parts, kerf: kerf, trim: trim, reusable: threshold),
      );
      for (final missing in fixedResult.unplaced) {
        expect(
          missing.reason,
          missing.length > mm(2000 - 2 * trim)
              ? UnplacedReason.tooLong
              : UnplacedReason.inventoryExhausted,
        );
      }
      expect(
        buyResult.unplaced.map((p) => p.reason),
        everyElement(UnplacedReason.tooLong),
      );
      expect(
        snapshot(
          run(
            fixed(
              stocks.reversed.toList(),
              parts.reversed.toList(),
              kerf: kerf,
              trim: trim,
              reusable: threshold,
            ),
          ),
        ),
        snapshot(fixedResult),
      );
    }
  });

  test(
    '300 expanded parts and 100 fixed bars stay within a generous host budget',
    () {
      final input = fixed(
        [stock(6000, quantity: 100)],
        [part(1800, quantity: 300)],
      );
      final watch = Stopwatch()..start();
      final result = optimizer.optimize(input);
      watch.stop();
      expectInvariants(input, result);
      expect(result.placedPartCount, 300);
      expect(result.barsUsed, 100);
      expect(watch.elapsedMilliseconds, lessThan(1000));
    },
  );
}
