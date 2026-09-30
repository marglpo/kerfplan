import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/stock_providers.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/data/repositories/drift_stock_repository.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/stock/stock_card.dart';
import 'package:kerfplan/presentation/stock/stock_editor_screen.dart';
import 'package:kerfplan/presentation/stock/project_stock_section.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository projects;
  late DriftStockRepository stocks;
  late String projectId;

  setUp(() async {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    projects = DriftProjectRepository(db);
    stocks = DriftStockRepository(db);
    projectId = (await projects.createProject(ProjectMetadata(name: 'Frame')))
        .id;
  });
  tearDown(() => db.close());

  Future<ProviderContainer> start(
    WidgetTester tester, {
    String? path,
    bool failStockOnce = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        if (failStockOnce)
          stockLinesProvider(projectId).overrideWith((ref) {
            if (failStockOnce) {
              failStockOnce = false;
              return Stream.error(StateError('private detail'));
            }
            return stocks.watchStockLines(projectId);
          }),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(path ?? '/projects/$projectId');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder.first);
    await tester.pumpAndSettle();
    await tester.tap(finder.first);
    await tester.pumpAndSettle();
  }

  Future<void> saveStock(
    WidgetTester tester, {
    String length = '6000',
    String quantity = '10',
    String label = 'Warehouse',
  }) async {
    await tester.enterText(find.byKey(const ValueKey('length-input')), length);
    await tester.enterText(
      find.byKey(const ValueKey('quantity-input')),
      quantity,
    );
    await tester.enterText(find.byKey(const ValueKey('stock-label')), label);
    await tapText(tester, 'Save stock length');
  }

  Future<void> menu(WidgetTester tester) async {
    final finder = find.descendant(
      of: find.byType(StockCard).first,
      matching: find.byIcon(Icons.more_vert),
    );
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Fixed empty state, Parts placeholder and disabled Calculate render',
    (tester) async {
      await start(tester);
      expect(find.text('No stock lengths added yet.'), findsOneWidget);
      expect(find.text('Add stock length'), findsOneWidget);
      expect(find.text('Add stock to continue.'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Calculate'),
            )
            .onPressed,
        isNull,
      );
      await tester.scrollUntilVisible(
        find.text('No parts added yet.'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ProjectScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('No parts added yet.'), findsOneWidget);
    },
  );

  testWidgets(
    'Add navigation and stock creation persist and update the project',
    (tester) async {
      await start(tester);
      await tapText(tester, 'Add stock length');
      expect(find.byType(StockEditorScreen), findsOneWidget);
      await saveStock(tester);
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect(find.text('6000 mm'), findsOneWidget);
      expect(find.text('Warehouse'), findsOneWidget);
      expect(find.text('1 stock length'), findsOneWidget);
      expect(find.text('10 total pieces'), findsOneWidget);
      expect(
        (await db.select(db.stockLines).getSingle()).lengthTicks,
        60000000,
      );
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets(
    'stock tap edits length and quantity and updates visible values',
    (tester) async {
      await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('6000'), quantity: 10),
      );
      await start(tester);
      await tapText(tester, '6000 mm');
      expect(find.text('Edit stock length'), findsOneWidget);
      await saveStock(tester, length: '3000', quantity: '5', label: 'Rack A');
      expect(find.text('3000 mm'), findsOneWidget);
      expect(find.text('5 total pieces'), findsOneWidget);
      expect(find.text('Rack A'), findsOneWidget);
      expect((await projects.getProject(projectId))!.revision, 2);
    },
  );

  testWidgets('quantity stepper works without typing and has 48dp targets', (
    tester,
  ) async {
    await start(tester, path: '/projects/$projectId/stock/new');
    final quantity = find.byKey(const ValueKey('quantity-input'));
    expect(tester.widget<TextFormField>(quantity).controller!.text, '1');
    expect(
      tester.getSize(find.byTooltip('Increase quantity')).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byTooltip('Decrease quantity')).width,
      greaterThanOrEqualTo(48),
    );
    await tester.tap(find.byTooltip('Increase quantity'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(quantity).controller!.text, '2');
    await tester.tap(find.byTooltip('Decrease quantity'));
    await tester.pumpAndSettle();
    expect(tester.widget<TextFormField>(quantity).controller!.text, '1');
    await tester.enterText(quantity, '9999');
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.add))
          .onPressed,
      isNull,
    );
  });

  testWidgets('duplicate renders another persisted row and correct summary', (
    tester,
  ) async {
    await stocks.createStockLine(
      projectId,
      StockInput(length: Length.fromMillimeters('6000'), quantity: 10),
    );
    await start(tester);
    await menu(tester);
    await tapText(tester, 'Duplicate stock length');
    expect(find.byType(StockCard), findsNWidgets(2));
    expect(find.text('2 stock lengths'), findsOneWidget);
    expect(find.text('20 total pieces'), findsOneWidget);
    expect((await projects.getProject(projectId))!.revision, 2);
  });

  testWidgets(
    'delete confirms, cancel preserves, and deletion removes the row',
    (tester) async {
      await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('6000'), quantity: 10),
      );
      await start(tester);
      await menu(tester);
      await tapText(tester, 'Delete');
      expect(find.text('Delete stock length?'), findsOneWidget);
      expect(
        find.text('6000 mm × 10 will be removed from this cut list.'),
        findsOneWidget,
      );
      await tapText(tester, 'Cancel');
      expect((await projects.getProject(projectId))!.revision, 1);
      await menu(tester);
      await tapText(tester, 'Delete');
      await tapText(tester, 'Delete');
      expect(find.byType(StockCard), findsNothing);
      expect(find.text('No stock lengths added yet.'), findsOneWidget);
      expect(find.text('Stock length deleted'), findsOneWidget);
      expect((await projects.getProject(projectId))!.revision, 2);
    },
  );

  testWidgets(
    'Buy mode saves one length, hides Fixed rows, and preserves both modes',
    (tester) async {
      final stock = await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('6000'), quantity: 10),
      );
      await start(tester);
      await tapText(tester, 'Buy stock');
      expect(find.byType(StockCard), findsNothing);
      expect(
        find.descendant(
          of: find.byType(ProjectStockSection),
          matching: find.text('Set the stock length you plan to buy.'),
        ),
        findsOneWidget,
      );
      await tapText(tester, 'Set stock length');
      expect(find.byKey(const ValueKey('quantity-input')), findsNothing);
      await tester.enterText(
        find.byKey(const ValueKey('length-input')),
        '3000',
      );
      await tapText(tester, 'Save');
      expect(find.text('3000 mm'), findsOneWidget);
      expect(await db.select(db.stockLines).get(), hasLength(1));
      expect((await projects.getProject(projectId))!.revision, 3);
      await tapText(tester, 'Fixed inventory');
      expect(find.text('6000 mm'), findsOneWidget);
      expect(find.byType(StockCard), findsOneWidget);
      expect((await stocks.getStockLine(stock.id))!.quantity, 10);
      expect(
        (await projects.getProject(projectId))!.buyStockLength!.ticks,
        30000000,
      );
      await tapText(tester, 'Buy stock');
      expect(find.text('3000 mm'), findsOneWidget);
    },
  );

  testWidgets('missing or wrong-project stock ID shows not-found', (
    tester,
  ) async {
    final other = await projects.createProject(ProjectMetadata(name: 'Other'));
    final stock = await stocks.createStockLine(
      other.id,
      StockInput(length: Length.fromMillimeters('6000'), quantity: 1),
    );
    final container = await start(
      tester,
      path: '/projects/$projectId/stock/missing/edit',
    );
    expect(find.text('Stock length not found'), findsOneWidget);
    container
        .read(routerProvider)
        .go('/projects/$projectId/stock/${stock.id}/edit');
    await tester.pumpAndSettle();
    expect(find.text('Stock length not found'), findsOneWidget);
    await tapText(tester, 'Back to cut list');
    expect(find.byType(ProjectScreen), findsOneWidget);
  });

  testWidgets('deleting stock while its editor is open shows not-found', (
    tester,
  ) async {
    final stock = await stocks.createStockLine(
      projectId,
      StockInput(length: Length.fromMillimeters('6000'), quantity: 1),
    );
    await start(tester, path: '/projects/$projectId/stock/${stock.id}/edit');
    await stocks.deleteStockLine(stock.id);
    await tester.pumpAndSettle();
    expect(find.text('Stock length not found'), findsOneWidget);
  });

  testWidgets('deleting project while adding stock shows project not-found', (
    tester,
  ) async {
    await start(tester, path: '/projects/$projectId/stock/new');
    await projects.deleteProject(projectId);
    await tester.pumpAndSettle();
    expect(find.text('Cut list not found'), findsOneWidget);
  });

  testWidgets('invalid length, quantity and label do not persist', (
    tester,
  ) async {
    await start(tester, path: '/projects/$projectId/stock/new');
    await saveStock(tester, length: '0', quantity: '10000', label: 'A' * 81);
    expect(find.text('Enter a number greater than zero.'), findsOneWidget);
    expect(find.text('Quantity must be 9999 or fewer.'), findsOneWidget);
    expect(find.text('Label must be 80 characters or fewer.'), findsOneWidget);
    expect(await db.select(db.stockLines).get(), isEmpty);
    expect((await projects.getProject(projectId))!.revision, 0);
  });

  testWidgets('metric unit presentation parses comma meters exactly', (
    tester,
  ) async {
    await db.customStatement(
      "UPDATE projects SET display_unit = 'm' WHERE id = ?",
      [projectId],
    );
    await start(tester, path: '/projects/$projectId/stock/new');
    expect(find.text('m'), findsOneWidget);
    await saveStock(tester, length: '2,44', quantity: '1');
    expect(find.text('2.44 m'), findsOneWidget);
    expect((await db.select(db.stockLines).getSingle()).lengthTicks, 24400000);
  });

  testWidgets(
    'imperial fallback preserves exact length for a label-only edit',
    (tester) async {
      final stock = await stocks.createStockLine(
        projectId,
        StockInput(length: Length.fromMillimeters('1'), quantity: 1),
      );
      await db.customStatement(
        "UPDATE projects SET display_unit = 'ftIn' WHERE id = ?",
        [projectId],
      );
      await start(tester, path: '/projects/$projectId/stock/${stock.id}/edit');
      expect(find.textContaining('Stored exactly: 1 mm.'), findsOneWidget);
      await tester.enterText(find.byKey(const ValueKey('stock-label')), 'Rack');
      await tapText(tester, 'Save stock length');
      expect((await stocks.getStockLine(stock.id))!.length.ticks, 10000);
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets(
    'stock save failure keeps input and retry succeeds without extra revision',
    (tester) async {
      await db.customStatement(
        "CREATE TRIGGER fail_stock BEFORE INSERT ON stock_lines BEGIN SELECT RAISE(ABORT, 'private detail'); END",
      );
      await start(tester, path: '/projects/$projectId/stock/new');
      await saveStock(tester);
      expect(
        find.text('Couldn’t save this stock length. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect(
        tester
            .widget<TextFormField>(find.byKey(const ValueKey('stock-label')))
            .controller!
            .text,
        'Warehouse',
      );
      expect((await projects.getProject(projectId))!.revision, 0);
      await db.customStatement('DROP TRIGGER fail_stock');
      await tapText(tester, 'Save stock length');
      expect(find.byType(StockCard), findsOneWidget);
      expect((await projects.getProject(projectId))!.revision, 1);
    },
  );

  testWidgets('mode failure preserves old mode and surfaces localized error', (
    tester,
  ) async {
    await db.customStatement(
      "CREATE TRIGGER fail_mode BEFORE UPDATE ON projects BEGIN SELECT RAISE(ABORT, 'private detail'); END",
    );
    await start(tester);
    await tapText(tester, 'Buy stock');
    expect(find.text('Couldn’t change stock mode. Try again.'), findsOneWidget);
    expect(
      (await projects.getProject(projectId))!.inventoryMode,
      InventoryMode.fixed,
    );
    expect((await projects.getProject(projectId))!.revision, 0);
  });

  testWidgets('stock load error retries without showing technical exception', (
    tester,
  ) async {
    await start(tester, failStockOnce: true);
    expect(find.text('Couldn’t load stock.'), findsOneWidget);
    expect(find.textContaining('private detail'), findsNothing);
    await tapText(tester, 'Retry');
    expect(find.text('No stock lengths added yet.'), findsOneWidget);
  });

  testWidgets('stock delete failure keeps the row and revision', (
    tester,
  ) async {
    await stocks.createStockLine(
      projectId,
      StockInput(length: Length.fromMillimeters('6000'), quantity: 1),
    );
    await db.customStatement(
      "CREATE TRIGGER fail_delete BEFORE DELETE ON stock_lines BEGIN SELECT RAISE(ABORT, 'private detail'); END",
    );
    await start(tester);
    await menu(tester);
    await tapText(tester, 'Delete');
    await tapText(tester, 'Delete');
    expect(
      find.text('Couldn’t delete this stock length. Try again.'),
      findsOneWidget,
    );
    expect(find.byType(StockCard), findsOneWidget);
    expect((await projects.getProject(projectId))!.revision, 1);
  });

  testWidgets('large-text small-screen stock section and input remain usable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await start(tester);
    await tapText(tester, 'Add stock length');
    await tester.enterText(find.byKey(const ValueKey('length-input')), '6000');
    await tapText(tester, 'Save stock length');
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
