import 'support/app_ready.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/part_providers.dart';
import 'package:kerfplan/app/stock_providers.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/cut_settings_input.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/models/part_item.dart';
import 'package:kerfplan/domain/models/stock_input.dart';
import 'package:kerfplan/domain/models/stock_item.dart';
import 'package:kerfplan/domain/repositories/part_repository.dart';
import 'package:kerfplan/domain/repositories/stock_repository.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';

import 'support/optimization_fixture.dart';

class PartGate implements PartRepository {
  PartGate(this.delegate);
  final PartRepository delegate;
  final gate = Completer<void>();
  int calls = 0;
  @override
  Future<PartItem> createPart(String id, PartInput input) async {
    calls++;
    await gate.future;
    return delegate.createPart(id, input);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class StockGate implements StockRepository {
  StockGate(this.delegate);
  final StockRepository delegate;
  final gate = Completer<void>();
  int calls = 0;
  @override
  Future<StockItem> createStockLine(String id, StockInput input) async {
    calls++;
    await gate.future;
    return delegate.createStockLine(id, input);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late OptimizationFixture f;
  setUp(() async {
    f = OptimizationFixture();
    await f.initialize();
  });
  tearDown(() => f.close());

  Future<ProviderContainer> start(
    WidgetTester tester,
    bool part, {
    String? editId,
    PartGate? partGate,
    StockGate? stockGate,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(f.db),
        if (partGate != null)
          partRepositoryProvider.overrideWithValue(partGate),
        if (stockGate != null)
          stockRepositoryProvider.overrideWithValue(stockGate),
      ],
    );
    addTearDown(container.dispose);
    container
        .read(routerProvider)
        .go(
          '/projects/${f.id}/${part ? 'parts' : 'stock'}/${editId == null ? 'new' : '$editId/edit'}',
        );
    await completeOnboarding(f.db);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Finder field(String key) => find.byKey(ValueKey(key));
  Future<void> enter(WidgetTester tester, String key, String text) async {
    await tester.ensureVisible(field(key));
    await tester.enterText(field(key), text);
  }

  Future<void> tap(WidgetTester tester, String text) async {
    final button = find
        .ancestor(
          of: find.text(text),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        )
        .last;
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      button,
      find.byType(SingleChildScrollView).last,
      const Offset(0, -250),
    );
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
  }

  Future<List<(int, int, String?)>> rows(bool part) async => part
      ? (await f.parts.getPartLines(f.id))
            .map((r) => (r.length.ticks, r.quantity, r.name))
            .toList()
      : (await f.stocks.getStockLines(f.id))
            .map((r) => (r.length.ticks, r.quantity, r.label))
            .toList();

  for (final part in [true, false]) {
    final kind = part ? 'Part' : 'Stock';
    final labelKey = part ? 'part-name' : 'stock-label';
    final primary = part ? 'Add part' : 'Save stock length';
    for (final unit in [DisplayUnit.mm, DisplayUnit.inch, DisplayUnit.ftIn]) {
      testWidgets(
        '$kind $unit repeat entry resets all inputs and primary save still returns to Project',
        (tester) async {
          final project = (await f.projects.getProject(f.id))!;
          await f.projects.updateCutSettings(
            f.id,
            CutSettingsInput(
              displayUnit: unit,
              kerf: project.kerf,
              endTrim: project.endTrim,
              minReusable: project.minReusable,
            ),
          );
          final container = await start(tester, part);
          await enter(tester, labelKey, 'First');
          await enter(tester, 'quantity-input', '6');
          if (unit == DisplayUnit.mm) {
            await enter(tester, 'length-input', '1800');
          } else {
            if (unit == DisplayUnit.ftIn) {
              await enter(tester, 'length-feet', '3');
            }
            await enter(tester, 'length-inches', '11');
            final c = tester
                .widget<LengthInputField>(find.byType(LengthInputField))
                .controller;
            c.sixteenths = 10;
            await tester.pump();
          }
          final expected = unit == DisplayUnit.mm
              ? 18000000
              : unit == DisplayUnit.inch
              ? 2952750
              : 12096750;
          await tap(tester, 'Save & add another');
          expect(await rows(part), [(expected, 6, 'First')]);
          expect(
            container
                .read(routerProvider)
                .routeInformationProvider
                .value
                .uri
                .path,
            endsWith('/new'),
          );
          final length = tester
              .widget<LengthInputField>(find.byType(LengthInputField))
              .controller;
          expect(length.text, isEmpty);
          expect(length.feet.text, isEmpty);
          expect(length.inches.text, isEmpty);
          expect(length.sixteenths, 0);
          expect(length.initialLength, isNull);
          expect(
            tester.widget<TextFormField>(field(labelKey)).controller!.text,
            isEmpty,
          );
          expect(
            tester
                .widget<TextFormField>(field('quantity-input'))
                .controller!
                .text,
            '1',
          );
          expect(
            tester
                .widget<LengthInputField>(find.byType(LengthInputField))
                .focusNode!
                .hasFocus,
            isTrue,
          );
          if (unit == DisplayUnit.mm) {
            await enter(tester, 'length-input', '450');
          } else {
            if (unit == DisplayUnit.ftIn) {
              await enter(tester, 'length-feet', '0');
            }
            await enter(tester, 'length-inches', '6');
          }
          await enter(tester, 'quantity-input', '12');
          await tap(tester, primary);
          expect(find.byType(ProjectScreen), findsOneWidget);
          expect(await rows(part), [
            (expected, 6, 'First'),
            (unit == DisplayUnit.mm ? 4500000 : 1524000, 12, null),
          ]);
          expect((await f.projects.getProject(f.id))!.revision, 2);
        },
      );
    }
    testWidgets(
      '$kind secondary failure retains values; retry saves and clears',
      (tester) async {
        final table = part ? 'part_lines' : 'stock_lines';
        await f.db.customStatement(
          "CREATE TRIGGER fail_entry BEFORE INSERT ON $table BEGIN SELECT RAISE(ABORT, 'private detail'); END",
        );
        await start(tester, part);
        await enter(tester, labelKey, 'Keep me');
        await enter(tester, 'length-input', '1200');
        await enter(tester, 'quantity-input', '4');
        await tap(tester, 'Save & add another');
        expect(await rows(part), isEmpty);
        expect(find.textContaining('private detail'), findsNothing);
        expect(
          find.text(
            part
                ? 'Couldn\u2019t save this part. Try again.'
                : 'Couldn\u2019t save this stock length. Try again.',
          ),
          findsOneWidget,
        );
        for (final entry in [
          (labelKey, 'Keep me'),
          ('length-input', '1200'),
          ('quantity-input', '4'),
        ]) {
          expect(
            tester.widget<TextFormField>(field(entry.$1)).controller!.text,
            entry.$2,
          );
        }
        await f.db.customStatement('DROP TRIGGER fail_entry');
        await tap(tester, 'Save & add another');
        expect(await rows(part), [(12000000, 4, 'Keep me')]);
        expect(
          tester.widget<TextFormField>(field(labelKey)).controller!.text,
          isEmpty,
        );
      },
    );
    testWidgets('$kind secondary action validates before inserting', (
      tester,
    ) async {
      await start(tester, part);
      await enter(tester, 'length-input', '0');
      await tap(tester, 'Save & add another');
      expect(await rows(part), isEmpty);
      expect(
        tester.widget<TextFormField>(field('length-input')).controller!.text,
        '0',
      );
      expect((await f.projects.getProject(f.id))!.revision, 0);
    });
    testWidgets('$kind edit has no repeat-entry action', (tester) async {
      String id;
      if (part) {
        id = (await f.part(1800)).id;
      } else {
        await f.stock(6000);
        id = (await f.stocks.getStockLines(f.id)).single.id;
      }
      await start(tester, part, editId: id);
      expect(find.text('Save & add another'), findsNothing);
      await enter(tester, 'length-input', '1200');
      await tap(tester, part ? 'Save' : primary);
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect((await rows(part)).single.$1, 12000000);
    });
    testWidgets('$kind repeated taps lock both save actions until completion', (
      tester,
    ) async {
      final pg = PartGate(f.parts);
      final sg = StockGate(f.stocks);
      await start(
        tester,
        part,
        partGate: part ? pg : null,
        stockGate: part ? null : sg,
      );
      await enter(tester, 'length-input', '1800');
      await tester.ensureVisible(find.text('Save & add another'));
      await tester.tap(find.text('Save & add another'));
      await tester.pump();
      await tester.tap(find.text('Save & add another'));
      await tester.pump();
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Save & add another'),
            )
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, primary))
            .onPressed,
        isNull,
      );
      expect(part ? pg.calls : sg.calls, 1);
      (part ? pg.gate : sg.gate).complete();
      await tester.pumpAndSettle();
      expect((await rows(part)).length, 1);
      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Save & add another'),
            )
            .onPressed,
        isNotNull,
      );
    });
    testWidgets('$kind repeated entry works on small dark large-text screen', (
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
      await start(tester, part);
      await enter(tester, 'length-input', '1800');
      await tap(tester, 'Save & add another');
      expect((await rows(part)).length, 1);
      expect(tester.takeException(), isNull);
      expect(
        tester
            .getSize(find.widgetWithText(OutlinedButton, 'Save & add another'))
            .height,
        greaterThanOrEqualTo(48),
      );
    });
  }
}
