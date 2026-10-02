import 'support/app_ready.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/cut_settings_screen.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/parts/part_card.dart';
import 'package:kerfplan/presentation/stock/stock_card.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';

import 'support/cut_settings_fixture.dart';
import 'support/optimization_fixture.dart';

void main() {
  late OptimizationFixture fixture;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
  });
  tearDown(() => fixture.close());

  Future<ProviderContainer> start(
    WidgetTester tester, {
    String suffix = '/cut-settings',
  }) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(fixture.db)],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go('/projects/${fixture.id}$suffix');
    await completeOnboarding(fixture.db);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> reveal(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        finder,
        220,
        scrollable: find.byType(Scrollable).first,
      );
    }
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await reveal(tester, finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enter(WidgetTester tester, String label, String value) async {
    final field = find.widgetWithText(TextFormField, label);
    await reveal(tester, field);
    await tester.enterText(field, value);
    await tester.pumpAndSettle();
  }

  Future<void> save(WidgetTester tester) =>
      tap(tester, find.widgetWithText(FilledButton, 'Save'));

  testWidgets(
    'project summary shows all settings and navigates to editor and back',
    (tester) async {
      await start(tester, suffix: '');
      await reveal(tester, find.text('Edit cut settings'));
      expect(find.text('Units: mm'), findsOneWidget);
      expect(find.text('Kerf: 3 mm'), findsOneWidget);
      expect(find.text('End trim: 0 mm each end'), findsOneWidget);
      expect(find.text('Reusable leftover: 100 mm'), findsOneWidget);
      await tap(tester, find.text('Edit cut settings'));
      expect(find.byType(CutSettingsScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ProjectScreen), findsOneWidget);
    },
  );

  testWidgets('save kerf and per-end trim updates summary and revision once', (
    tester,
  ) async {
    await start(tester);
    await enter(tester, 'Kerf', '4');
    await enter(tester, 'End trim (each end)', '10');
    await save(tester);
    expect(find.byType(ProjectScreen), findsOneWidget);
    await reveal(tester, find.text('Edit cut settings'));
    expect(find.text('Kerf: 4 mm'), findsOneWidget);
    expect(find.text('End trim: 10 mm each end'), findsOneWidget);
    expect((await fixture.projects.getProject(fixture.id))!.revision, 1);
  });

  for (final unit in [DisplayUnit.mm, DisplayUnit.inch, DisplayUnit.ftIn]) {
    testWidgets('all zero settings save in $unit', (tester) async {
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(unit: unit, kerf: 0, reusable: 0),
      );
      final before = (await fixture.projects.getProject(fixture.id))!;
      await start(tester);
      // Touch the controls so the imperial path validates newly entered zero.
      if (unit == DisplayUnit.mm) {
        await enter(tester, 'Kerf', '0.0');
        await enter(tester, 'End trim (each end)', '0');
        await enter(tester, 'Reusable leftover', '0');
      } else {
        final fields = find.byKey(const ValueKey('length-inches'));
        for (var i = 0; i < 3; i++) {
          await reveal(tester, fields.at(i));
          await tester.enterText(fields.at(i), '00');
        }
      }
      await save(tester);
      expect(find.byType(ProjectScreen), findsOneWidget);
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(
        [after.kerf.ticks, after.endTrim.ticks, after.minReusable.ticks],
        [0, 0, 0],
      );
      expect(after.updatedAt, before.updatedAt);
    });
  }

  for (final label in ['Kerf', 'End trim (each end)', 'Reusable leftover']) {
    testWidgets('negative $label blocks saving and switching units', (
      tester,
    ) async {
      await start(tester);
      await enter(tester, label, '-1');
      await tap(tester, find.widgetWithText(ChoiceChip, 'in'));
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'mm'))
            .selected,
        isTrue,
      );
      await save(tester);
      expect(find.byType(CutSettingsScreen), findsOneWidget);
      expect(
        find.text('Enter a number greater than or equal to zero.'),
        findsOneWidget,
      );
      expect((await fixture.projects.getProject(fixture.id))!.revision, 0);
    });
  }

  testWidgets(
    'pending unit round trip preserves non-sixteenth lengths on untouched Save',
    (tester) async {
      await fixture.projects.updateCutSettings(
        fixture.id,
        settings(trim: 123457),
      );
      final before = (await fixture.projects.getProject(fixture.id))!;
      await start(tester);
      for (final unit in ['in', 'ft + in', 'mm']) {
        await tap(tester, find.widgetWithText(ChoiceChip, unit));
        expect(tester.takeException(), isNull);
      }
      await save(tester);
      final after = (await fixture.projects.getProject(fixture.id))!;
      expect(after.kerf.ticks, 30000);
      expect(after.endTrim.ticks, 123457);
      expect(after.minReusable.ticks, 1000000);
      expect(after.revision, before.revision);
      expect(after.updatedAt, before.updatedAt);
    },
  );

  testWidgets(
    'unit save updates Stock and Part cards without recreating rows',
    (tester) async {
      await fixture.stock(2438);
      await fixture.part(1200, name: 'Brace');
      await start(tester);
      await tap(tester, find.widgetWithText(ChoiceChip, 'ft + in'));
      await save(tester);
      await reveal(tester, find.byType(StockCard));
      expect(
        find.descendant(
          of: find.byType(StockCard),
          matching: find.textContaining("8' 0\""),
        ),
        findsOneWidget,
      );
      await reveal(tester, find.byType(PartCard));
      expect(
        find.descendant(
          of: find.byType(PartCard),
          matching: find.textContaining("3' 11-1/4\""),
        ),
        findsOneWidget,
      );
      expect(
        (await fixture.stocks.getStockLines(fixture.id)).single.length.ticks,
        24380000,
      );
      expect(
        (await fixture.parts.getPartLines(fixture.id)).single.length.ticks,
        12000000,
      );
      expect((await fixture.projects.getProject(fixture.id))!.revision, 2);
    },
  );

  testWidgets('unit save updates Buy stock formatting', (tester) async {
    await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
    await fixture.projects.setBuyStockLength(
      fixture.id,
      Length.fromTicks(24384000),
    );
    await start(tester);
    await tap(tester, find.widgetWithText(ChoiceChip, 'ft + in'));
    await save(tester);
    expect(find.text("8' 0\""), findsOneWidget);
    expect(
      (await fixture.projects.getProject(fixture.id))!.buyStockLength!.ticks,
      24384000,
    );
  });

  for (final mode in InventoryMode.values) {
    testWidgets('$mode unusable trim warns but Save succeeds', (tester) async {
      await fixture.projects.setInventoryMode(fixture.id, mode);
      if (mode == InventoryMode.buy) {
        await fixture.projects.setBuyStockLength(
          fixture.id,
          Length.fromTicks(10000000),
        );
      } else {
        await fixture.stock(1000);
      }
      await start(tester);
      await enter(tester, 'End trim (each end)', '500');
      expect(
        find.text('No usable stock length remains after end trim.'),
        findsOneWidget,
      );
      await save(tester);
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect(
        (await fixture.projects.getProject(fixture.id))!.endTrim.ticks,
        5000000,
      );
    });
  }

  testWidgets('some unusable Fixed stock never shows global warning', (
    tester,
  ) async {
    await fixture.stock(1000);
    await fixture.stock(2000);
    await start(tester);
    await enter(tester, 'End trim (each end)', '600');
    expect(
      find.text('No usable stock length remains after end trim.'),
      findsNothing,
    );
    expect(
      find.text('Some stock pieces are too short after end trim.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'missing active Buy stock does not warn using hidden Fixed stock',
    (tester) async {
      await fixture.stock(1000);
      await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
      await start(tester);
      await enter(tester, 'End trim (each end)', '500');
      expect(
        find.text('No usable stock length remains after end trim.'),
        findsNothing,
      );
    },
  );

  testWidgets('saved trim refreshes open Part warning and its formatted unit', (
    tester,
  ) async {
    await fixture.stock(1000);
    final part = await fixture.part(981);
    await start(tester, suffix: '/parts/${part.id}/edit');
    expect(find.textContaining('longer than your largest'), findsNothing);
    await fixture.projects.updateCutSettings(
      fixture.id,
      settings(trim: 100000),
    );
    await tester.pumpAndSettle();
    expect(
      find.text(
        'This part is longer than your largest usable stock length (980 mm).',
      ),
      findsOneWidget,
    );
    await fixture.projects.updateCutSettings(
      fixture.id,
      settings(unit: DisplayUnit.ftIn, trim: 100000),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining("3' 2-9/16\""), findsOneWidget);
  });

  testWidgets('open Result changes units and physical results stay exact', (
    tester,
  ) async {
    await fixture.stock(1000);
    await fixture.part(400, quantity: 2);
    await start(tester, suffix: '/result');
    expect(find.text('Total waste: 200 mm'), findsOneWidget);
    final before = await fixture.coordinator.calculate(fixture.id);
    await fixture.projects.updateCutSettings(
      fixture.id,
      settings(unit: DisplayUnit.ftIn),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining("Total waste: \u2248 0' 7-7/8\""),
      findsOneWidget,
    );
    final after = await fixture.coordinator.calculate(fixture.id);
    expect(after.result.totalWaste, before.result.totalWaste);
    expect(after.project.revision, before.project.revision);
  });

  testWidgets('deleted project while editing shows not-found state', (
    tester,
  ) async {
    await start(tester);
    await fixture.projects.deleteProject(fixture.id);
    await tester.pumpAndSettle();
    expect(find.text('Cut list not found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'failed save keeps pending values and shows localized retryable error',
    (tester) async {
      await fixture.db.customStatement(
        "CREATE TRIGGER fail_settings BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'private detail'); END",
      );
      await start(tester);
      await enter(tester, 'Kerf', '4');
      await save(tester);
      expect(
        find.text('Couldn\u2019t save cut settings. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect(
        (await fixture.projects.getProject(fixture.id))!.kerf.ticks,
        30000,
      );
      expect(
        tester
            .widget<LengthInputField>(find.byType(LengthInputField).first)
            .controller
            .length
            .ticks,
        40000,
      );
      await fixture.db.customStatement('DROP TRIGGER fail_settings');
      await save(tester);
      expect(find.byType(ProjectScreen), findsOneWidget);
    },
  );

  testWidgets('small dark large-text imperial settings can switch and save', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await start(tester);
    await tap(tester, find.widgetWithText(ChoiceChip, 'ft + in'));
    await save(tester);
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
