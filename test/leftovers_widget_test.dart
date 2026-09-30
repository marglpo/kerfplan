import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/optimization_providers.dart';
import 'package:kerfplan/app/project_providers.dart';
import 'package:kerfplan/app/reusable_leftovers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/repositories/stock_repository.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/results/result_screen.dart';
import 'package:kerfplan/presentation/stock/stock_card.dart';

import 'support/optimization_fixture.dart';

class BatchGate implements StockRepository {
  BatchGate(this.delegate);
  final StockRepository delegate;
  final gate = Completer<void>();
  int calls = 0;
  @override
  Future<void> addStockBatch(String id, List<StockInput> items) async {
    calls++;
    await gate.future;
    await delegate.addStockBatch(id, items);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late OptimizationFixture f;
  late int calculations;
  setUp(() async {
    f = OptimizationFixture();
    await f.initialize();
    calculations = 0;
  });
  tearDown(() => f.close());
  Future<ProviderContainer> start(
    WidgetTester tester, {
    BatchGate? gate,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(f.db),
        if (gate != null)
          reusableLeftoversProvider.overrideWithValue(ReusableLeftovers(gate)),
        optimizationResultProvider(f.id).overrideWith((ref) async {
          await ref.watch(
            projectProvider(f.id).selectAsync((p) => p?.updatedAt),
          );
          calculations++;
          return f.coordinator.calculate(f.id);
        }),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go('/projects/${f.id}/result');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> tap(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> standard() async {
    await f.stock(1000);
    await f.part(400, quantity: 2);
  }

  testWidgets(
    'confirmation counts pieces, explains future stock; Cancel leaves result unchanged',
    (tester) async {
      await standard();
      await start(tester);
      final before = (await f.projects.getProject(f.id))!;
      await tap(tester, 'Add leftovers to stock');
      expect(find.text('Add leftovers to stock?'), findsOneWidget);
      expect(find.text('1 reusable piece'), findsOneWidget);
      expect(
        find.textContaining('Fixed Inventory for future cut plans.'),
        findsOneWidget,
      );
      expect(
        find.text('Add them after the cuts are complete.'),
        findsOneWidget,
      );
      await tap(tester, 'Cancel');
      expect(find.byType(ResultScreen), findsOneWidget);
      expect((await f.stocks.getStockLines(f.id)).length, 1);
      expect((await f.projects.getProject(f.id))!.revision, before.revision);
      expect(calculations, 1);
    },
  );
  for (final part in [1000, 950]) {
    testWidgets('no active leftover action for zero/scrap tail: part $part', (
      tester,
    ) async {
      await f.stock(1000);
      await f.part(part);
      await start(tester);
      expect(find.text('Add leftovers to stock'), findsNothing);
    });
  }
  for (final mode in InventoryMode.values) {
    testWidgets(
      '$mode confirms one batch, returns to project with feedback and no recalculation',
      (tester) async {
        await standard();
        await f.projects.setBuyStockLength(
          f.id,
          Length.fromMillimeters('1000'),
        );
        await f.projects.setInventoryMode(f.id, mode);
        final gate = BatchGate(f.stocks);
        await start(tester, gate: gate);
        final before = (await f.projects.getProject(f.id))!;
        await tap(tester, 'Add leftovers to stock');
        await tap(tester, 'Add to stock');
        expect(gate.calls, 1);
        expect(find.byType(ResultScreen), findsOneWidget);
        final disabled = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Add leftovers to stock'),
        );
        expect(disabled.onPressed, isNull);
        await tester.tap(find.text('Add leftovers to stock'));
        await tester.pump();
        expect(gate.calls, 1);
        gate.gate.complete();
        await tester.pumpAndSettle();
        expect(find.byType(ProjectScreen), findsOneWidget);
        expect(
          find.text('Reusable leftovers added to stock for future cut plans.'),
          findsOneWidget,
        );
        final after = (await f.projects.getProject(f.id))!;
        expect(after.revision, before.revision + 1);
        expect(after.inventoryMode, mode);
        expect(after.buyStockLength, before.buyStockLength);
        final rows = await f.stocks.getStockLines(f.id);
        expect(rows.length, 2);
        expect(rows.last.length.ticks, 1970000);
        expect(calculations, 1);
        if (mode == InventoryMode.buy) {
          expect(find.byType(StockCard), findsNothing);
          await tap(tester, 'Fixed inventory');
        }
        expect(find.byType(StockCard), findsNWidgets(2));
        expect(find.text('197 mm'), findsOneWidget);
        expect(calculations, 1);
      },
    );
  }
  testWidgets(
    'failed batch stays on Result, hides technical details and can retry',
    (tester) async {
      await standard();
      await f.db.customStatement(
        "CREATE TRIGGER fail_leftovers BEFORE INSERT ON stock_lines BEGIN SELECT RAISE(ABORT, 'private detail'); END",
      );
      await start(tester);
      await tap(tester, 'Add leftovers to stock');
      await tap(tester, 'Add to stock');
      expect(find.byType(ResultScreen), findsOneWidget);
      expect(
        find.text('Couldn\u2019t add leftovers to stock. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect((await f.stocks.getStockLines(f.id)).length, 1);
      await f.db.customStatement('DROP TRIGGER fail_leftovers');
      await tap(tester, 'Add leftovers to stock');
      await tap(tester, 'Add to stock');
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect((await f.stocks.getStockLines(f.id)).length, 2);
    },
  );
  testWidgets(
    'small dark large-text confirmation remains scrollable and cancellable',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await standard();
      await start(tester);
      await tap(tester, 'Add leftovers to stock');
      await tap(tester, 'Cancel');
      expect(tester.takeException(), isNull);
    },
  );
}
