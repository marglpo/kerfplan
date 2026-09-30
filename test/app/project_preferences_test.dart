import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/optimization_providers.dart';
import 'package:kerfplan/app/project_creation.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/domain/models/app_preferences.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/repositories/app_settings_repository.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

import '../support/optimization_fixture.dart';

final imperialDefaults = AppPreferences(
  defaultDisplayUnit: DisplayUnit.ftIn,
  defaultKerf: Length.fromInchFraction(1, 8),
  defaultReusable: Length.fromInchFraction(4, 1),
  themeMode: AppThemeMode.dark,
);

class CountingPreferences implements AppSettingsRepository {
  int reads = 0;
  bool fail = false;
  @override
  Future<AppPreferences> getSettings() async {
    if (fail) throw StateError('private detail');
    return ++reads == 1 ? imperialDefaults : AppPreferences.defaults;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late OptimizationFixture f;
  late DriftAppSettingsRepository settings;
  late ProjectCreation creation;
  setUp(() async {
    f = OptimizationFixture();
    await f.initialize();
    settings = DriftAppSettingsRepository(f.db);
    creation = ProjectCreation(settings, f.projects);
  });
  tearDown(() => f.close());
  test(
    'creation without ever opening Settings initializes fresh defaults',
    () async {
      expect(await f.db.select(f.db.appSettings).get(), isEmpty);
      final p = await creation.create(ProjectMetadata(name: 'Fresh'));
      expect(p.displayUnit, DisplayUnit.mm);
      expect(p.kerf.ticks, 30000);
      expect(p.minReusable.ticks, 1000000);
      expect((await f.db.select(f.db.appSettings).get()).length, 1);
    },
  );
  test('new project inherits one exact saved snapshot and preserves other initial rules', () async {
    await settings.updateSettings(imperialDefaults);
    final p = await creation.create(ProjectMetadata(name: 'Imperial'));
    expect(p.displayUnit, DisplayUnit.ftIn);
    expect(p.kerf.ticks, 31750);
    expect(p.minReusable.ticks, 1016000);
    expect(p.endTrim.ticks, 0);
    expect(p.inventoryMode, InventoryMode.fixed);
    expect(p.buyStockLength, isNull);
    expect(p.revision, 0);
    expect(p.lastRunId, isNull);
  });
  test('changing preferences does not mutate existing projects, stock, parts, or active result', () async {
    await f.stock(1000);
    await f.part(400, quantity: 2);
    final a = await f.db.select(f.db.projects).getSingle();
    final stock = await f.db.select(f.db.stockLines).get();
    final parts = await f.db.select(f.db.partLines).get();
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(f.db)],
    );
    addTearDown(container.dispose);
    final provider = optimizationResultProvider(f.id);
    final sub = container.listen(provider, (_, _) {});
    addTearDown(sub.close);
    final result = await container.read(provider.future);
    await settings.updateSettings(imperialDefaults);
    final b = await creation.create(ProjectMetadata(name: 'B'));
    await settings.updateSettings(AppPreferences.defaults);
    await pumpEventQueue();
    expect(
      await (f.db.select(
        f.db.projects,
      )..where((r) => r.id.equals(a.id))).getSingle(),
      a,
    );
    final persistedB = (await f.projects.getProject(b.id))!;
    expect(persistedB.displayUnit, DisplayUnit.ftIn);
    expect(persistedB.kerf.ticks, 31750);
    expect(persistedB.minReusable.ticks, 1016000);
    expect(persistedB.revision, 0);
    expect(persistedB.updatedAt, b.updatedAt);
    expect(await f.db.select(f.db.stockLines).get(), stock);
    expect(await f.db.select(f.db.partLines).get(), parts);
    expect(identical(await container.read(provider.future), result), isTrue);
  });
  test('creation reads preferences once rather than fetching each default independently', () async {
    final source = CountingPreferences();
    final creator = ProjectCreation(source, f.projects);
    final p = await creator.create(ProjectMetadata(name: 'Consistent'));
    expect(source.reads, 1);
    expect(p.displayUnit, DisplayUnit.ftIn);
    expect(p.kerf.ticks, 31750);
    expect(p.minReusable.ticks, 1016000);
  });
  test('settings read failure does not silently create a project with fallback values', () async {
    final source = CountingPreferences()..fail = true;
    final before = await f.db.select(f.db.projects).get();
    await expectLater(
      ProjectCreation(source, f.projects).create(ProjectMetadata(name: 'No')),
      throwsStateError,
    );
    expect(await f.db.select(f.db.projects).get(), before);
  });
}
