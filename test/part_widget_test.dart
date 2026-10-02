import 'support/app_ready.dart';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/part_providers.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/data/repositories/drift_part_repository.dart';
import 'package:kerfplan/data/repositories/drift_stock_repository.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/parts/part_card.dart';
import 'package:kerfplan/presentation/parts/part_editor_screen.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository projects;
  late DriftPartRepository parts;
  late DriftStockRepository stocks;
  late String projectId;
  setUp(() async {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    projects = DriftProjectRepository(db);
    parts = DriftPartRepository(db);
    stocks = DriftStockRepository(db);
    projectId = (await projects.createProject(ProjectMetadata(name: 'Frame')))
        .id;
  });
  tearDown(() => db.close());

  Future<ProviderContainer> start(
    WidgetTester tester, {
    String? path,
    bool failOnce = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        if (failOnce)
          partsProvider(projectId).overrideWith((ref) {
            if (failOnce) {
              failOnce = false;
              return Stream.error(StateError('private detail'));
            }
            return parts.watchParts(projectId);
          }),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(path ?? '/projects/$projectId');
    await completeOnboarding(db);
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
        180,
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

  Future<void> submit(WidgetTester tester, String text) =>
      tap(tester, find.widgetWithText(FilledButton, text));
  Future<void> metric(
    WidgetTester tester, {
    String mm = '1800',
    String quantity = '6',
    String name = 'Upright',
  }) async {
    await tester.enterText(find.byKey(const ValueKey('part-name')), name);
    await tester.enterText(find.byKey(const ValueKey('length-input')), mm);
    await tester.enterText(
      find.byKey(const ValueKey('quantity-input')),
      quantity,
    );
  }

  Future<void> menu(WidgetTester tester) async {
    await reveal(tester, find.byType(PartCard).first);
    await tap(
      tester,
      find.descendant(
        of: find.byType(PartCard).first,
        matching: find.byIcon(Icons.more_vert),
      ),
    );
  }

  Future<void> unit(String unit) => db.customStatement(
    'UPDATE projects SET display_unit = ? WHERE id = ?',
    [unit, projectId],
  );
  Future<void> fraction(WidgetTester tester, String value) async {
    await tap(tester, find.byType(DropdownButtonFormField<int>));
    await tester.ensureVisible(find.text(value).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text(value).last);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Parts empty state and Add route render; metric create returns a grouped card',
    (tester) async {
      await start(tester);
      await reveal(tester, find.text('No parts added yet.'));
      await submit(tester, 'Add part');
      expect(find.byType(PartEditorScreen), findsOneWidget);
      await metric(tester);
      await submit(tester, 'Add part');
      expect(find.byType(ProjectScreen), findsOneWidget);
      await reveal(tester, find.byType(PartCard));
      expect(find.text('Upright'), findsOneWidget);
      expect(find.text('1800 mm'), findsOneWidget);
      expect(find.text('× 6'), findsOneWidget);
      expect(find.text('1 part line'), findsOneWidget);
      expect(find.text('6 total pieces'), findsOneWidget);
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 18000000);
    },
  );

  testWidgets('tap edits part length, quantity and name', (tester) async {
    await parts.createPart(
      projectId,
      PartInput(
        length: Length.fromMillimeters('1800'),
        quantity: 6,
        name: 'Upright',
      ),
    );
    await start(tester);
    await tap(tester, find.text('1800 mm'));
    await metric(tester, mm: '450', quantity: '12', name: 'Brace');
    await submit(tester, 'Save');
    await reveal(tester, find.byType(PartCard));
    expect(find.text('450 mm'), findsOneWidget);
    expect(find.text('Brace'), findsOneWidget);
    expect(find.text('× 12'), findsOneWidget);
    expect((await projects.getProject(projectId))!.revision, 2);
  });

  testWidgets(
    'duplicate makes a separate group; deletion confirms and removes one row',
    (tester) async {
      await parts.createPart(
        projectId,
        PartInput(
          length: Length.fromMillimeters('1800'),
          quantity: 6,
          name: 'Upright',
        ),
      );
      await start(tester);
      await menu(tester);
      await tap(tester, find.text('Duplicate part'));
      expect(find.byType(PartCard), findsNWidgets(2));
      expect(find.text('2 part lines'), findsOneWidget);
      expect(find.text('12 total pieces'), findsOneWidget);
      await menu(tester);
      await tap(tester, find.text('Delete'));
      expect(
        find.text('Upright — 1800 mm × 6 will be removed from this cut list.'),
        findsOneWidget,
      );
      await tap(tester, find.text('Cancel'));
      expect(await db.select(db.partLines).get(), hasLength(2));
      await menu(tester);
      await tap(tester, find.text('Delete'));
      await tap(tester, find.text('Delete'));
      expect(find.byType(PartCard), findsOneWidget);
      expect(find.text('Part deleted'), findsOneWidget);
      expect((await projects.getProject(projectId))!.revision, 3);
    },
  );

  testWidgets(
    'blank optional name creates an unnamed part without layout errors',
    (tester) async {
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester, name: '   ');
      await submit(tester, 'Add part');
      await reveal(tester, find.byType(PartCard));
      expect((await db.select(db.partLines).getSingle()).name, isNull);
      expect(find.text('1800 mm'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'inch editor offers reduced fractions and stores exact selected length',
    (tester) async {
      await unit('inch');
      await start(tester, path: '/projects/$projectId/parts/new');
      expect(find.text('Whole inches'), findsOneWidget);
      expect(find.text('Fraction'), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('length-inches')), '47');
      await fraction(tester, '5/8');
      await submit(tester, 'Add part');
      await reveal(tester, find.byType(PartCard));
      expect(find.text('47-5/8"'), findsOneWidget);
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 12096750);
    },
  );

  testWidgets(
    'feet inches editor rejects 12 inches and accepts 3 feet 11 and 5/8',
    (tester) async {
      await unit('ftIn');
      await start(tester, path: '/projects/$projectId/parts/new');
      expect(find.text('Feet'), findsOneWidget);
      expect(find.text('Inches'), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('length-feet')), '3');
      await tester.enterText(find.byKey(const ValueKey('length-inches')), '12');
      await submit(tester, 'Add part');
      expect(
        find.text(
          'Use 0 to 11 inches. Enter additional feet in the Feet field.',
        ),
        findsOneWidget,
      );
      expect(await db.select(db.partLines).get(), isEmpty);
      await reveal(tester, find.byKey(const ValueKey('length-inches')));
      await tester.enterText(find.byKey(const ValueKey('length-inches')), '11');
      await fraction(tester, '5/8');
      await submit(tester, 'Add part');
      await reveal(tester, find.byType(PartCard));
      expect(find.text('3\' 11-5/8"'), findsOneWidget);
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 12096750);
    },
  );

  testWidgets(
    'non-sixteenth name-only edit and field focus preserve original ticks and revision',
    (tester) async {
      final part = await parts.createPart(
        projectId,
        PartInput(length: Length.fromMillimeters('1'), quantity: 1),
      );
      await unit('ftIn');
      await start(tester, path: '/projects/$projectId/parts/${part.id}/edit');
      expect(find.textContaining('Stored exactly: 1 mm.'), findsOneWidget);
      await tap(tester, find.byKey(const ValueKey('length-inches')));
      await tester.enterText(find.byKey(const ValueKey('part-name')), 'Tiny');
      await submit(tester, 'Save');
      expect((await parts.getPart(part.id))!.length.ticks, 10000);
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets(
    'fit warning uses both trims, updates as length changes and allows save',
    (tester) async {
      await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('1000'), quantity: 1),
      );
      await db.customStatement(
        'UPDATE projects SET end_trim_ticks = 100000 WHERE id = ?',
        [projectId],
      );
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester, mm: '980');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
      await tester.enterText(find.byKey(const ValueKey('length-input')), '981');
      await tester.pumpAndSettle();
      expect(
        find.text(
          'This part is longer than your largest usable stock length (980 mm).',
        ),
        findsOneWidget,
      );
      await submit(tester, 'Add part');
      expect((await db.select(db.partLines).getSingle()).lengthTicks, 9810000);
    },
  );

  testWidgets(
    'missing stock gives no fit warning; live buy configuration updates warning',
    (tester) async {
      await projects.setInventoryMode(projectId, InventoryMode.buy);
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester, mm: '6500');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
      await projects.setBuyStockLength(
        projectId,
        Length.fromMillimeters('6000'),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'This part is longer than your largest usable stock length (6000 mm).',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('imperial stock and buy editors use the same controls', (
    tester,
  ) async {
    await unit('ftIn');
    final container = await start(
      tester,
      path: '/projects/$projectId/stock/new',
    );
    await tester.enterText(find.byKey(const ValueKey('length-feet')), '8');
    await submit(tester, 'Save stock length');
    expect((await db.select(db.stockLines).getSingle()).lengthTicks, 24384000);
    await projects.setInventoryMode(projectId, InventoryMode.buy);
    container.read(routerProvider).go('/projects/$projectId/stock/buy');
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('length-feet')), '3');
    await tester.enterText(find.byKey(const ValueKey('length-inches')), '11');
    await fraction(tester, '5/8');
    await submit(tester, 'Save');
    expect(
      (await projects.getProject(projectId))!.buyStockLength!.ticks,
      12096750,
    );
    expect(find.text('3\' 11-5/8"'), findsOneWidget);
  });

  testWidgets('unknown, wrong-owner and deleted parts show not-found', (
    tester,
  ) async {
    final other = await projects.createProject(ProjectMetadata(name: 'Other'));
    final part = await parts.createPart(
      other.id,
      PartInput(length: Length.fromTicks(1), quantity: 1),
    );
    final container = await start(
      tester,
      path: '/projects/$projectId/parts/missing/edit',
    );
    expect(find.text('Part not found'), findsOneWidget);
    container
        .read(routerProvider)
        .go('/projects/$projectId/parts/${part.id}/edit');
    await tester.pumpAndSettle();
    expect(find.text('Part not found'), findsOneWidget);
    final own = await parts.createPart(
      projectId,
      PartInput(length: Length.fromTicks(1), quantity: 1),
    );
    container
        .read(routerProvider)
        .go('/projects/$projectId/parts/${own.id}/edit');
    await tester.pumpAndSettle();
    await parts.deletePart(own.id);
    await tester.pumpAndSettle();
    expect(find.text('Part not found'), findsOneWidget);
  });

  testWidgets(
    'save failure retains inputs and retry saves once without technical errors',
    (tester) async {
      await db.customStatement(
        "CREATE TRIGGER fail_part BEFORE INSERT ON part_lines BEGIN SELECT RAISE(ABORT, 'private detail'); END",
      );
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester);
      await submit(tester, 'Add part');
      expect(find.text('Couldn’t save this part. Try again.'), findsOneWidget);
      expect(find.textContaining('private detail'), findsNothing);
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('part-name')))
            .controller!
            .text,
        'Upright',
      );
      expect((await projects.getProject(projectId))!.revision, 0);
      await db.customStatement('DROP TRIGGER fail_part');
      await submit(tester, 'Add part');
      expect(await db.select(db.partLines).get(), hasLength(1));
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets('part load error retries with safe wording', (tester) async {
    await start(tester, failOnce: true);
    await reveal(tester, find.text('Couldn’t load parts.'));
    expect(find.textContaining('private detail'), findsNothing);
    await tap(tester, find.text('Retry'));
    expect(find.text('No parts added yet.'), findsOneWidget);
  });

  testWidgets('calculate is enabled when stock and parts exist', (
    tester,
  ) async {
    await stocks.createStockLine(
      projectId,
      StockInput(length: Length.fromMillimeters('6000'), quantity: 1),
    );
    await parts.createPart(
      projectId,
      PartInput(length: Length.fromMillimeters('1800'), quantity: 6),
    );
    await start(tester);
    expect(find.text('Cut plan isn’t available yet.'), findsNothing);
    expect(
      tester
          .widget<FilledButton>(find.widgetWithText(FilledButton, 'Calculate'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets(
    'invalid part fields show localized validation without persisting',
    (tester) async {
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester, mm: '0', quantity: '10000', name: 'A' * 101);
      await submit(tester, 'Add part');
      expect(
        find.text('Part name must be 100 characters or fewer.'),
        findsOneWidget,
      );
      expect(find.text('Enter a number greater than zero.'), findsOneWidget);
      expect(find.text('Quantity must be 9999 or fewer.'), findsOneWidget);
      expect(await db.select(db.partLines).get(), isEmpty);
      expect((await projects.getProject(projectId))!.revision, 0);
    },
  );

  testWidgets(
    'delete and duplicate failures keep the part with safe feedback',
    (tester) async {
      await parts.createPart(
        projectId,
        PartInput(length: Length.fromMillimeters('1800'), quantity: 6),
      );
      await db.customStatement(
        "CREATE TRIGGER reject_touch BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'private detail'); END",
      );
      await start(tester);
      await menu(tester);
      await tap(tester, find.text('Duplicate part'));
      expect(
        find.text('Couldn’t duplicate this part. Try again.'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      await menu(tester);
      await tap(tester, find.text('Delete'));
      await tap(tester, find.text('Delete'));
      expect(
        find.text('Couldn’t delete this part. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect(await db.select(db.partLines).get(), hasLength(1));
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets(
    'fixed-stock warning reacts to stock changes while preserving entered part',
    (tester) async {
      await start(tester, path: '/projects/$projectId/parts/new');
      await metric(tester, mm: '2500');
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
      final stock = await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('2440'), quantity: 1),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'This part is longer than your largest usable stock length (2440 mm).',
        ),
        findsOneWidget,
      );
      await stocks.updateStockLine(
        stock.id,
        StockInput(length: Length.fromMillimeters('3000'), quantity: 1),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('length-input')))
            .controller!
            .text,
        '2500',
      );
    },
  );

  testWidgets('large text and small screen imperial controls remain usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await unit('ftIn');
    await start(tester, path: '/projects/$projectId/parts/new');
    await reveal(tester, find.byKey(const ValueKey('length-feet')));
    await tester.enterText(find.byKey(const ValueKey('length-feet')), '8');
    await fraction(tester, '1/16');
    await submit(tester, 'Add part');
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
