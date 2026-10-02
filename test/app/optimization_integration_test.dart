import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/optimization_coordinator.dart';
import 'package:kerfplan/app/optimization_providers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/optimizer/optimization_failure.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/units/length.dart';

import '../support/optimization_fixture.dart';

void main() {
  late OptimizationFixture fixture;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
  });
  tearDown(() => fixture.close());

  test(
    'persisted Fixed 1000 / 400 x2 maps exactly and does not write results',
    () async {
      await fixture.stock(1000);
      final part = await fixture.part(400, quantity: 2, name: 'Brace');
      final before = (await fixture.projects.getProject(fixture.id))!;
      final result = (await fixture.coordinator.calculate(fixture.id)).result;
      expect(result.barsUsed, 1);
      expect(result.tailLeftovers.ticks, 1970000);
      expect(result.totalWaste.ticks, 2000000);
      expect(result.bars.single.placedParts.first.sourcePartId, part.id);
      expect(result.bars.single.placedParts.first.name, 'Brace');
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(after.revision, before.revision);
      expect(after.updatedAt, before.updatedAt);
      expect(after.lastRunId, before.lastRunId);
      expect(fixture.db.schemaVersion, 4);
    },
  );

  test('persisted Buy 6000 / 1800 x10 returns four pieces to buy', () async {
    await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
    await fixture.projects.setBuyStockLength(
      fixture.id,
      Length.fromTicks(60000000),
    );
    await fixture.part(1800, quantity: 10);
    await fixture.stock(100); // Hidden Fixed inventory is not active input.
    final result = (await fixture.coordinator.calculate(fixture.id)).result;
    expect(result.barsToBuy, 4);
    expect(result.totalWaste.ticks, 60000000);
    expect(result.wastePercent, 25);
    expect(await fixture.db.select(fixture.db.stockLines).get(), hasLength(1));
  });

  test(
    'persisted mixed Fixed stock returns three bars and 12.5 percent waste',
    () async {
      await fixture.stock(6000);
      await fixture.stock(3000, quantity: 2);
      await fixture.part(5500);
      await fixture.part(2500, quantity: 2);
      final result = (await fixture.coordinator.calculate(fixture.id)).result;
      expect(result.barsUsed, 3);
      expect(result.wastePercent, 12.5);
    },
  );

  test(
    'stored sort order, trim, kerf and reusable threshold are mapped unchanged',
    () async {
      await fixture.stock(1000);
      final a = await fixture.part(400, name: 'A');
      final b = await fixture.part(400, name: 'B');
      await fixture.db.customStatement(
        'UPDATE projects SET end_trim_ticks = 100000, kerf_ticks = 20000, min_reusable_ticks = 2000000 WHERE id = ?',
        [fixture.id],
      );
      await fixture.db.customStatement(
        'UPDATE part_lines SET sort_order = 5 WHERE id = ?',
        [a.id],
      );
      final result = (await fixture.coordinator.calculate(fixture.id)).result;
      expect(result.bars.single.placedParts.map((part) => part.sourcePartId), [
        b.id,
        a.id,
      ]);
      expect(
        result.bars.single.placedParts.map((part) => part.sourceStableOrder),
        [1, 5],
      );
      expect(result.trimLoss.ticks, 200000);
      expect(result.kerfLoss.ticks, 20000);
      expect(result.tailLeftovers.ticks, 1780000);
      expect(result.reusableLeftovers.ticks, 0);
    },
  );

  test('missing and unusable input remain typed failures', () async {
    await expectLater(
      fixture.coordinator.calculate('missing'),
      throwsA(isA<ProjectNotFoundException>()),
    );
    await expectLater(
      fixture.coordinator.calculate(fixture.id),
      throwsA(isA<MissingCalculationInput>()),
    );
    await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
    await fixture.part(1);
    await expectLater(
      fixture.coordinator.calculate(fixture.id),
      throwsA(isA<MissingCalculationInput>()),
    );
    await fixture.projects.setBuyStockLength(
      fixture.id,
      Length.fromTicks(200000),
    );
    await fixture.db.customStatement(
      'UPDATE projects SET end_trim_ticks = 100000 WHERE id = ?',
      [fixture.id],
    );
    await expectLater(
      fixture.coordinator.calculate(fixture.id),
      throwsA(isA<OptimizationValidationException>()),
    );
  });

  test('provider reuses reads, refreshes on saved input, and ignores another project', () async {
    await fixture.stock(1000);
    final part = await fixture.part(400, quantity: 2);
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(fixture.db)],
    );
    addTearDown(container.dispose);
    final provider = optimizationResultProvider(fixture.id);
    final sub = container.listen(provider, (_, _) {});
    addTearDown(sub.close);
    final first = await container.read(provider.future);
    expect(identical(await container.read(provider.future), first), isTrue);
    await fixture.projects.createProject(ProjectMetadata(name: 'Other'));
    await container.pump();
    expect(identical(await container.read(provider.future), first), isTrue);
    final refreshed = Completer<CalculatedProject>();
    final changed = container.listen(provider, (_, value) {
      final data = value.asData?.value;
      if (!value.isLoading &&
          data != null &&
          data.project.updatedAt != first.project.updatedAt &&
          !refreshed.isCompleted) {
        refreshed.complete(data);
      }
    });
    addTearDown(changed.close);
    await fixture.parts.updatePart(
      part.id,
      PartInput(length: Length.fromTicks(3000000), quantity: 2),
    );
    // Await the provider's reactive emission instead of relying on timer delays.
    final next = await refreshed.future.timeout(const Duration(seconds: 5));
    expect(next.result.totalWaste.ticks, 4000000);
    container.invalidate(provider);
    final reloaded = await container.read(provider.future);
    expect(identical(next, reloaded), isFalse);
    expect(reloaded.result.totalWaste.ticks, next.result.totalWaste.ticks);
  });
}
