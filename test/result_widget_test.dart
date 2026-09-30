import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/optimization_coordinator.dart';
import 'package:kerfplan/app/optimization_providers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/results/result_screen.dart';
import 'package:kerfplan/presentation/results/optimization_bar_card.dart';
import 'package:kerfplan/presentation/results/cut_bar_diagram.dart';

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
    bool result = true,
    String? projectId,
    Future<CalculatedProject> Function()? load,
    bool settle = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(fixture.db),
        if (load != null)
          optimizationResultProvider(fixture.id).overrideWith((ref) => load()),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(routerProvider)
        .go('/projects/${projectId ?? fixture.id}${result ? '/result' : ''}');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    if (settle) await tester.pumpAndSettle();
    return container;
  }

  Future<void> reveal(WidgetTester tester, Finder target) async {
    if (target.evaluate().isEmpty) {
      await tester.scrollUntilVisible(
        target,
        220,
        scrollable: find
            .descendant(
              of: find.byType(ResultScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
    }
    await tester.ensureVisible(target);
    await tester.pumpAndSettle();
  }

  Future<void> standard() async {
    await fixture.stock(1000);
    await fixture.part(400, quantity: 2, name: 'Brace');
  }

  for (final sample in [
    (InventoryMode.fixed, false, false, false),
    (InventoryMode.fixed, true, false, false),
    (InventoryMode.fixed, false, true, false),
    (InventoryMode.fixed, true, true, true),
    (InventoryMode.buy, false, true, false),
    (InventoryMode.buy, true, false, false),
    (InventoryMode.buy, true, true, true),
  ]) {
    testWidgets(
      'Calculate enablement: mode=${sample.$1}, stock=${sample.$2}, parts=${sample.$3}',
      (tester) async {
        await fixture.projects.setInventoryMode(fixture.id, sample.$1);
        if (sample.$2) {
          if (sample.$1 == InventoryMode.fixed) {
            await fixture.stock(1000);
          } else {
            await fixture.projects.setBuyStockLength(
              fixture.id,
              Length.fromTicks(10000000),
            );
          }
        }
        if (sample.$3) await fixture.part(400);
        await start(tester, result: false);
        final button = tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Calculate'),
        );
        expect(button.onPressed != null, sample.$4);
      },
    );
  }

  testWidgets(
    'too-long parts enable Calculate and navigate to a valid all-unplaced result',
    (tester) async {
      await fixture.stock(1000);
      await fixture.part(1200, quantity: 3);
      await start(tester, result: false);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Calculate'),
            )
            .onPressed,
        isNotNull,
      );
      await tester.tap(find.text('Calculate'));
      await tester.pumpAndSettle();
      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.text('0 stock pieces used'), findsOneWidget);
      expect(find.text('Waste: 0.0%'), findsOneWidget);
      await reveal(tester, find.text('Placed 0 of 3 parts'));
      await reveal(tester, find.text('Unplaced parts (3)'));
      expect(
        find.text('This part is longer than the largest usable stock length.'),
        findsOneWidget,
      );
      expect(find.byType(OptimizationBarCard), findsNothing);
    },
  );

  testWidgets(
    'Calculate loads once despite duplicate taps and renders exact Fixed result',
    (tester) async {
      await standard();
      var loads = 0;
      await start(
        tester,
        result: false,
        load: () {
          loads++;
          return fixture.coordinator.calculate(fixture.id);
        },
      );
      final button = find.text('Calculate');
      await tester.tap(button);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(loads, 1);
      expect(find.text('Cut plan'), findsOneWidget);
      expect(find.text('1 stock piece used'), findsOneWidget);
      expect(find.text('Waste: 20.0%'), findsOneWidget);
      await reveal(tester, find.text('Reusable leftovers: 197 mm'));
      expect(find.text('Total waste: 200 mm'), findsOneWidget);
      await reveal(tester, find.byType(OptimizationBarCard));
      expect(find.text('Bar 1 · 1000 mm'), findsOneWidget);
      expect(find.text('1. Brace — 400 mm'), findsOneWidget);
      expect(find.text('2. Brace — 400 mm'), findsOneWidget);
      expect(find.text('Leftover: 197 mm · Reusable'), findsOneWidget);
      final bar = tester
          .widget<OptimizationBarCard>(find.byType(OptimizationBarCard))
          .bar;
      expect(bar.placedParts.map((part) => part.kerfAfter.ticks), [30000, 0]);
    },
  );

  testWidgets(
    'Buy result shows standard length, purchase count and rounded waste',
    (tester) async {
      await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
      await fixture.projects.setBuyStockLength(
        fixture.id,
        Length.fromTicks(60000000),
      );
      await fixture.part(1800, quantity: 10);
      await start(tester);
      expect(find.text('4 stock pieces to buy'), findsOneWidget);
      expect(find.text('Buy 6000 mm × 4'), findsOneWidget);
      expect(find.text('Waste: 25.0%'), findsOneWidget);
      await reveal(tester, find.byKey(const ValueKey('result-bar-3')));
      expect(find.text('Bar 4 · 6000 mm'), findsOneWidget);
    },
  );

  testWidgets(
    'partial placement keeps bars and localized inventory-exhausted groups',
    (tester) async {
      await fixture.stock(1000);
      await fixture.part(900, quantity: 2, name: 'Frame');
      await start(tester);
      await reveal(tester, find.text('Placed 1 of 2 parts'));
      await reveal(tester, find.text('Unplaced parts (1)'));
      expect(
        find.text('Not enough stock remains to place this part.'),
        findsOneWidget,
      );
      await reveal(tester, find.byType(OptimizationBarCard));
      expect(find.text('1. Frame — 900 mm'), findsOneWidget);
    },
  );

  testWidgets(
    'unplaced grouping never merges different source rows of equal length',
    (tester) async {
      await fixture.stock(1000);
      await fixture.part(1200, quantity: 2, name: 'Frame');
      await fixture.part(1200, quantity: 3, name: 'Shelf');
      await start(tester);
      await reveal(tester, find.text('Unplaced parts (5)'));
      expect(find.text('Frame'), findsOneWidget);
      expect(find.text('Shelf'), findsOneWidget);
      expect(find.text('1200 mm × 2'), findsOneWidget);
      expect(find.text('1200 mm × 3'), findsOneWidget);
    },
  );

  testWidgets('Recalculate reloads once and Edit cut list returns to Project', (
    tester,
  ) async {
    await standard();
    var loads = 0;
    await start(
      tester,
      load: () {
        loads++;
        return fixture.coordinator.calculate(fixture.id);
      },
    );
    expect(loads, 1);
    await tester.tap(find.text('Recalculate'));
    await tester.pumpAndSettle();
    expect(loads, 2);
    await tester.tap(find.text('Edit cut list'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(find.byType(ResultScreen), findsNothing);
  });

  testWidgets(
    'active result updates from saved inputs and reopening recomputes',
    (tester) async {
      await fixture.stock(1000);
      final part = await fixture.part(400, quantity: 2);
      final container = await start(tester);
      expect(find.text('Waste: 20.0%'), findsOneWidget);
      await fixture.parts.updatePart(
        part.id,
        PartInput(length: Length.fromTicks(3000000), quantity: 2),
      );
      await tester.pumpAndSettle();
      expect(find.text('Waste: 40.0%'), findsOneWidget);
      await tester.tap(find.text('Edit cut list'));
      await tester.pumpAndSettle();
      await fixture.parts.updatePart(
        part.id,
        PartInput(length: Length.fromTicks(2000000), quantity: 2),
      );
      container.read(routerProvider).go('/projects/${fixture.id}/result');
      await tester.pumpAndSettle();
      expect(find.text('Waste: 60.0%'), findsOneWidget);
    },
  );

  testWidgets('deleted project replaces current result with not-found', (
    tester,
  ) async {
    await standard();
    await start(tester);
    await fixture.projects.deleteProject(fixture.id);
    await tester.pumpAndSettle();
    expect(find.text('Cut list not found'), findsOneWidget);
    expect(find.text('Waste: 20.0%'), findsNothing);
    await tester.tap(find.text('Back to projects'));
    await tester.pumpAndSettle();
    expect(find.text('No cut lists yet'), findsOneWidget);
  });

  testWidgets('unknown project ID renders not-found on direct Result route', (
    tester,
  ) async {
    await start(tester, projectId: 'missing');
    expect(find.text('Cut list not found'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('async loading state has no stale summary', (tester) async {
    await standard();
    final pending = Completer<CalculatedProject>();
    await start(tester, load: () => pending.future, settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    expect(find.text('Waste: 20.0%'), findsNothing);
    pending.complete(await fixture.coordinator.calculate(fixture.id));
    await tester.pumpAndSettle();
    expect(find.text('Waste: 20.0%'), findsOneWidget);
  });

  testWidgets('repository failure hides technical details and Retry reloads', (
    tester,
  ) async {
    await standard();
    // Only this isolated test database is affected.
    await fixture.db.customStatement(
      'ALTER TABLE part_lines RENAME TO unavailable_parts',
    );
    await start(tester);
    expect(find.text('Couldn’t calculate this cut list.'), findsOneWidget);
    expect(find.textContaining('SqliteException'), findsNothing);
    await fixture.db.customStatement(
      'ALTER TABLE unavailable_parts RENAME TO part_lines',
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Waste: 20.0%'), findsOneWidget);
  });

  testWidgets(
    'invalid trimmed Buy configuration shows friendly input guidance',
    (tester) async {
      await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
      await fixture.projects.setBuyStockLength(
        fixture.id,
        Length.fromTicks(200000),
      );
      await fixture.part(1);
      await fixture.db.customStatement(
        'UPDATE projects SET end_trim_ticks = 100000 WHERE id = ?',
        [fixture.id],
      );
      await start(tester);
      expect(find.text('Stock is too short after end trim.'), findsOneWidget);
      expect(find.textContaining('noUsableBuyStock'), findsNothing);
    },
  );

  testWidgets(
    'trim, zero-tail classification and diagram semantics are readable',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await fixture.stock(1000);
        await fixture.part(980);
        await fixture.db.customStatement(
          'UPDATE projects SET end_trim_ticks = 100000 WHERE id = ?',
          [fixture.id],
        );
        await start(tester);
        await reveal(tester, find.byType(OptimizationBarCard));
        expect(find.text('End trim: 10 mm each end'), findsOneWidget);
        expect(find.text('Leftover: 0 mm'), findsOneWidget);
        expect(find.text('Leftover: 0 mm · Scrap'), findsNothing);
        expect(
          find.bySemanticsLabel('Stock bar 1, 1000 mm, 1 part, leftover 0 mm.'),
          findsOneWidget,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets('one-decimal waste and all secondary summary lengths are shown', (
    tester,
  ) async {
    await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
    await fixture.projects.setBuyStockLength(
      fixture.id,
      Length.fromTicks(10000000),
    );
    await fixture.part(100, quantity: 50);
    await start(tester);
    expect(find.text('Waste: 16.7%'), findsOneWidget);
    await reveal(tester, find.text('Total finished length: 5000 mm'));
    expect(find.text('Requested parts: 50'), findsOneWidget);
    expect(find.text('Placed parts: 50'), findsOneWidget);
    expect(find.text('Total stock used: 6000 mm'), findsOneWidget);
    expect(find.text('Scrap: 512 mm'), findsOneWidget);
    expect(find.text('Kerf loss: 132 mm'), findsOneWidget);
    expect(find.text('Trim loss: 0 mm'), findsOneWidget);
    expect(find.text('Unplaced parts: 0'), findsNothing);
  });

  testWidgets('Recalculate hides old results during an actual pending reload', (
    tester,
  ) async {
    await standard();
    final pending = Completer<CalculatedProject>();
    var calls = 0;
    await start(
      tester,
      load: () => ++calls == 1
          ? fixture.coordinator.calculate(fixture.id)
          : pending.future,
    );
    await tester.tap(find.text('Recalculate'));
    await tester.pump();
    expect(find.text('Waste: 20.0%'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Recalculate'),
          )
          .onPressed,
      isNull,
    );
    pending.complete(await fixture.coordinator.calculate(fixture.id));
    await tester.pumpAndSettle();
    expect(find.text('Waste: 20.0%'), findsOneWidget);
  });

  testWidgets('Calculate failure stays on Project and permits retry', (
    tester,
  ) async {
    await standard();
    var fail = true;
    await start(
      tester,
      result: false,
      load: () async {
        if (fail) throw StateError('private calculation detail');
        return fixture.coordinator.calculate(fixture.id);
      },
    );
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(find.text('Couldn’t calculate this cut list.'), findsOneWidget);
    expect(find.textContaining('private calculation detail'), findsNothing);
    fail = false;
    await tester.tap(find.text('Calculate'));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);
    await tester.tap(find.text('Edit cut list'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Calculate'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('100-bar result uses lazy cards and keeps optimizer order', (
    tester,
  ) async {
    await fixture.stock(6000, quantity: 100);
    await fixture.part(1800, quantity: 300);
    await start(tester);
    expect(find.text('100 stock pieces used'), findsOneWidget);
    await reveal(tester, find.byKey(const ValueKey('result-bar-0')));
    expect(find.byType(OptimizationBarCard).evaluate().length, lessThan(10));
    expect(find.text('Bar 1 · 6000 mm'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('result length formatting respects imperial display units', (
    tester,
  ) async {
    await fixture.stock(1000);
    await fixture.part(400, quantity: 2);
    await fixture.db.customStatement(
      "UPDATE projects SET display_unit = 'ftIn' WHERE id = ?",
      [fixture.id],
    );
    await start(tester);
    await reveal(tester, find.byType(OptimizationBarCard));
    expect(find.text('Bar 1 · ≈ 3\' 3-3/8"'), findsOneWidget);
    expect(find.text('Leftover: ≈ 0\' 7-3/4" · Reusable'), findsOneWidget);
  });

  for (final size in [const Size(320, 640), const Size(640, 320)]) {
    testWidgets(
      'small screen $size renders tiny part segments and accessible actions',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 2;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await fixture.stock(6000);
        await fixture.parts.createPart(
          fixture.id,
          PartInput(length: Length.fromTicks(1), quantity: 1),
        );
        await start(tester);
        await reveal(tester, find.byType(CutBarDiagram));
        expect(tester.getSize(find.byType(CutBarDiagram)).height, 64);
        expect(
          tester
              .getSize(find.widgetWithText(FilledButton, 'Recalculate'))
              .height,
          greaterThanOrEqualTo(48),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
