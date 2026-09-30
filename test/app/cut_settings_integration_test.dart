import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/optimization_coordinator.dart';
import 'package:kerfplan/app/optimization_providers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/optimizer/optimization_result.dart';
import 'package:kerfplan/domain/optimizer/unplaced_part.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

import '../support/cut_settings_fixture.dart';
import '../support/optimization_fixture.dart';

// Includes source identity, order and all physical results, not display text.
Object physicalResult(OptimizationResult result) => [
  result.barsToBuy,
  result.requestedPartCount,
  result.totalFinishedLength.ticks,
  result.totalUsedStockLength.ticks,
  result.kerfLoss.ticks,
  result.trimLoss.ticks,
  result.tailLeftovers.ticks,
  result.reusableLeftovers.ticks,
  result.scrap.ticks,
  result.totalWaste.ticks,
  result.wastePercent,
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
          part.instanceIndex,
          part.orderIndex,
          part.length.ticks,
          part.kerfAfter.ticks,
        ],
    ],
  for (final part in result.unplaced)
    [part.sourcePartId, part.instanceIndex, part.reason],
];

void main() {
  late OptimizationFixture fixture;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
  });
  tearDown(() => fixture.close());

  test('saved kerf changes Buy purchase count from one to two', () async {
    await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
    await fixture.projects.setBuyStockLength(
      fixture.id,
      Length.fromTicks(10000000),
    );
    await fixture.part(499, quantity: 2);
    await fixture.projects.updateCutSettings(fixture.id, settings(kerf: 10000));
    expect(
      (await fixture.coordinator.calculate(fixture.id)).result.barsToBuy,
      1,
    );
    await fixture.projects.updateCutSettings(fixture.id, settings(kerf: 30000));
    expect(
      (await fixture.coordinator.calculate(fixture.id)).result.barsToBuy,
      2,
    );
  });

  for (final mm in [980, 981]) {
    test(
      'saved per-end trim gives exact 980 mm usable boundary for part $mm',
      () async {
        await fixture.stock(1000);
        await fixture.part(mm);
        await fixture.projects.updateCutSettings(
          fixture.id,
          settings(trim: 100000),
        );
        final result = (await fixture.coordinator.calculate(fixture.id)).result;
        expect(result.placedPartCount, mm == 980 ? 1 : 0);
        if (mm == 981) {
          expect(result.unplaced.single.reason, UnplacedReason.tooLong);
        }
        if (mm == 980) expect(result.trimLoss.ticks, 200000);
      },
    );
  }

  test(
    'saved threshold changes reusable and scrap, preserving total waste',
    () async {
      await fixture.stock(1000);
      await fixture.part(400, quantity: 2);
      final first = (await fixture.coordinator.calculate(fixture.id)).result;
      expect(first.reusableLeftovers.ticks, 1970000);
      expect(first.scrap.ticks, 30000);
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(reusable: 2000000),
      );
      final next = (await fixture.coordinator.calculate(fixture.id)).result;
      expect(next.reusableLeftovers.ticks, 0);
      expect(next.scrap.ticks, 2000000);
      expect(next.totalWaste.ticks, 2000000);
      expect(next.totalWaste, first.totalWaste);
    },
  );

  test(
    'saved display unit changes no physical result or project revision',
    () async {
      await fixture.stock(1000, quantity: 2);
      await fixture.part(400, quantity: 3);
      await fixture.part(1200);
      final first = await fixture.coordinator.calculate(fixture.id);
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(unit: DisplayUnit.ftIn),
      );
      final next = await fixture.coordinator.calculate(fixture.id);
      expect(next.project.displayUnit, DisplayUnit.ftIn);
      expect(next.project.revision, first.project.revision);
      expect(physicalResult(next.result), physicalResult(first.result));
    },
  );

  test(
    'live result provider reloads saved settings and unit-only changes',
    () async {
      await fixture.stock(1000);
      await fixture.part(400, quantity: 2);
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(fixture.db)],
      );
      addTearDown(container.dispose);
      final provider = optimizationResultProvider(fixture.id);
      final subscription = container.listen(provider, (_, _) {});
      addTearDown(subscription.close);
      var previous = await container.read(provider.future);
      for (final input in [
        settings(reusable: 2000000),
        settings(unit: DisplayUnit.ftIn, reusable: 2000000),
      ]) {
        final ready = Completer<CalculatedProject>();
        final changes = container.listen(provider, (_, state) {
          final data = state.asData?.value;
          if (!state.isLoading &&
              data != null &&
              data.project.updatedAt != previous.project.updatedAt &&
              !ready.isCompleted) {
            ready.complete(data);
          }
        });
        await fixture.projects.updateCutSettings(fixture.id, input);
        final next = await ready.future.timeout(const Duration(seconds: 5));
        changes.close();
        expect(next.result.scrap.ticks, 2000000);
        expect(next.project.displayUnit, input.displayUnit);
        previous = next;
      }
    },
  );
}
