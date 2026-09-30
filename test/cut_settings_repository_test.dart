import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/repositories/project_repository.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

import 'support/optimization_fixture.dart';
import 'support/cut_settings_fixture.dart';

void main() {
  late OptimizationFixture fixture;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
  });
  tearDown(() => fixture.close());

  for (final sample in [
    ('kerf', settings(kerf: 40000), 1),
    ('trim', settings(trim: 100000), 1),
    ('threshold', settings(reusable: 2000000), 1),
    ('all lengths', settings(kerf: 40000, trim: 100000, reusable: 2000000), 1),
    ('unit only', settings(unit: DisplayUnit.inch), 0),
    ('unit and kerf', settings(unit: DisplayUnit.ftIn, kerf: 40000), 1),
    ('all zeros', settings(kerf: 0, trim: 0, reusable: 0), 1),
  ]) {
    test('${sample.$1} saves atomically with exact revision delta', () async {
      final before = (await fixture.projects.getProject(fixture.id))!;
      await fixture.projects.updateCutSettings(fixture.id, sample.$2);
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(after.revision, before.revision + sample.$3);
      expect(after.updatedAt.isAfter(before.updatedAt), isTrue);
      expect(after.displayUnit, sample.$2.displayUnit);
      expect(after.kerf, sample.$2.kerf);
      expect(after.endTrim, sample.$2.endTrim);
      expect(after.minReusable, sample.$2.minReusable);
      // A second save of identical data is a true no-op, including its timestamp.
      await fixture.projects.updateCutSettings(fixture.id, sample.$2);
      final identical = (await fixture.projects.getProject(fixture.id))!;
      expect(identical.revision, after.revision);
      expect(identical.updatedAt, after.updatedAt);
    });
  }

  test(
    'settings preserve unrelated project fields and hidden stock data',
    () async {
      await fixture.projects.updateProjectMetadata(
        fixture.id,
        ProjectMetadata(name: 'Frame', material: 'Steel', note: 'Wall'),
      );
      await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
      await fixture.projects.setBuyStockLength(
        fixture.id,
        Length.fromTicks(24384000),
      );
      await fixture.stock(1000);
      await fixture.part(400);
      await (fixture.db.update(fixture.db.projects)
            ..where((p) => p.id.equals(fixture.id)))
          .write(const ProjectsCompanion(lastRunId: Value('preserved-run')));
      final before = (await fixture.projects.getProject(fixture.id))!;
      final stock = await fixture.stocks.getStockLines(fixture.id);
      final parts = await fixture.parts.getPartLines(fixture.id);
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(
          unit: DisplayUnit.ftIn,
          kerf: 40000,
          trim: 100000,
          reusable: 2000000,
        ),
      );
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(
        [
          after.id,
          after.name,
          after.material,
          after.note,
          after.inventoryMode,
          after.buyStockLength,
          after.createdAt,
          after.lastRunId,
        ],
        [
          before.id,
          before.name,
          before.material,
          before.note,
          before.inventoryMode,
          before.buyStockLength,
          before.createdAt,
          before.lastRunId,
        ],
      );
      expect(
        (await fixture.stocks.getStockLines(fixture.id)).single.id,
        stock.single.id,
      );
      expect(
        (await fixture.parts.getPartLines(fixture.id)).single.id,
        parts.single.id,
      );
      expect(fixture.db.schemaVersion, 2);
    },
  );

  test(
    'unit-only round trip leaves every physical tick and revision unchanged',
    () async {
      await fixture.stock(1000);
      await fixture.part(400);
      await fixture.projects.setBuyStockLength(
        fixture.id,
        Length.fromTicks(24384000),
      );
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(trim: 123457),
      );
      final before = (await fixture.projects.getProject(fixture.id))!;
      for (final unit in [DisplayUnit.inch, DisplayUnit.ftIn, DisplayUnit.mm]) {
        await fixture.projects.updateCutSettings(
          fixture.id,
          settings(unit: unit, trim: 123457),
        );
        final project = (await fixture.projects.getProject(fixture.id))!;
        expect(project.revision, before.revision);
        expect(
          [
            project.kerf.ticks,
            project.endTrim.ticks,
            project.minReusable.ticks,
            project.buyStockLength!.ticks,
          ],
          [30000, 123457, 1000000, 24384000],
        );
        expect(
          (await fixture.stocks.getStockLines(fixture.id)).single.length.ticks,
          10000000,
        );
        expect(
          (await fixture.parts.getPartLines(fixture.id)).single.length.ticks,
          4000000,
        );
      }
    },
  );

  test('deleted project fails clearly', () async {
    await fixture.projects.deleteProject(fixture.id);
    await expectLater(
      fixture.projects.updateCutSettings(fixture.id, settings()),
      throwsA(isA<ProjectNotFoundException>()),
    );
  });

  test(
    'revision overflow rolls back settings and timestamp atomically',
    () async {
      await (fixture.db.update(fixture.db.projects)
            ..where((p) => p.id.equals(fixture.id)))
          .write(const ProjectsCompanion(revision: Value(0x7FFFFFFFFFFFFFFF)));
      final before = (await fixture.projects.getProject(fixture.id))!;
      await expectLater(
        fixture.projects.updateCutSettings(fixture.id, settings(kerf: 40000)),
        throwsStateError,
      );
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(after.kerf, before.kerf);
      expect(after.updatedAt, before.updatedAt);
      expect(after.revision, before.revision);
    },
  );
}
