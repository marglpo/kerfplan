import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/export_providers.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/domain/models/inventory_mode.dart';
import 'package:kerfplan/domain/models/part_input.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/results/result_screen.dart';
import 'package:kerfplan/services/export/cut_report_data.dart';
import 'package:kerfplan/services/export/share_service.dart';

import 'support/optimization_fixture.dart';

void main() {
  late OptimizationFixture fixture;
  late List<ShareParams> shared;
  late List<String> copied;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
    shared = [];
    copied = [];
  });
  tearDown(() => fixture.close());

  Future<ProviderContainer> start(
    WidgetTester tester, {
    bool buy = false,
    bool platformFails = false,
    ShareResultStatus status = ShareResultStatus.dismissed,
    Future<Uint8List> Function(CutReportData)? pdf,
  }) async {
    if (buy) {
      await fixture.projects.setInventoryMode(fixture.id, InventoryMode.buy);
      await fixture.projects.setBuyStockLength(
        fixture.id,
        Length.fromTicks(60000000),
      );
      await fixture.part(1800, quantity: 10);
    } else {
      await fixture.stock(1000);
      await fixture.part(400, quantity: 2);
    }
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null),
    );
    final service = ReportShareService(
      share: (params) async {
        if (platformFails) {
          throw PlatformException(code: 'private native detail');
        }
        shared.add(params);
        return ShareResult('', status);
      },
    );
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(fixture.db),
        reportShareServiceProvider.overrideWithValue(service),
        reportPdfBuilderProvider.overrideWithValue(
          pdf ?? (_) async => Uint8List.fromList([37, 80, 68, 70]),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go('/projects/${fixture.id}/result');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> openShare(WidgetTester tester) async {
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();
  }

  Future<void> choose(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text));
    await tester.pumpAndSettle();
    await tester.tap(find.text(text));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'Fixed sheet exposes accessible Text/PDF actions without Buy copy',
    (tester) async {
      await start(tester);
      final handle = tester.ensureSemantics();
      try {
        await openShare(tester);
        expect(find.text('Share cut plan'), findsOneWidget);
        expect(find.text('Share text'), findsOneWidget);
        expect(find.text('Share PDF'), findsOneWidget);
        expect(find.text('Copy buy list'), findsNothing);
        for (final label in ['Share text', 'Share PDF']) {
          expect(find.bySemanticsLabel(label), findsOneWidget);
          expect(
            tester.getSize(find.widgetWithText(ListTile, label)).height,
            greaterThanOrEqualTo(48),
          );
        }
      } finally {
        handle.dispose();
      }
    },
  );

  testWidgets('Share Text sends real result; dismissal returns safely', (
    tester,
  ) async {
    await start(tester);
    await openShare(tester);
    await choose(tester, 'Share text');
    expect(shared.single.text, contains('Leftover: 197 mm'));
    expect(shared.single.text, contains('Waste: 20.0%'));
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.textContaining('Couldn'), findsNothing);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Share'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets(
    'Buy copy uses SDK clipboard and gives localized success feedback',
    (tester) async {
      await start(tester, buy: true);
      await openShare(tester);
      await choose(tester, 'Copy buy list');
      expect(copied, ['6000 mm \u00d7 4']);
      expect(find.text('Buy list copied'), findsOneWidget);
      expect(shared, isEmpty);
    },
  );

  testWidgets(
    'Share PDF sends file type and useful name through platform boundary',
    (tester) async {
      await start(tester);
      await openShare(tester);
      await choose(tester, 'Share PDF');
      expect(shared.single.files!.single.mimeType, 'application/pdf');
      expect(
        shared.single.fileNameOverrides!.single,
        startsWith('KerfPlan_Workshop_'),
      );
      expect(shared.single.fileNameOverrides!.single, endsWith('.pdf'));
      expect(find.byType(ResultScreen), findsOneWidget);
      expect(find.textContaining('Couldn'), findsNothing);
    },
  );

  testWidgets('PDF generation failure stays on Result and permits retry', (
    tester,
  ) async {
    var calls = 0;
    await start(
      tester,
      pdf: (_) async {
        calls++;
        if (calls == 1) throw StateError('private font detail');
        return Uint8List.fromList([37, 80, 68, 70]);
      },
    );
    await openShare(tester);
    await choose(tester, 'Share PDF');
    expect(
      find.text('Couldn\u2019t create the PDF. Try again.'),
      findsOneWidget,
    );
    expect(find.textContaining('private font detail'), findsNothing);
    expect(shared, isEmpty);
    await openShare(tester);
    await choose(tester, 'Share PDF');
    expect(calls, 2);
    expect(shared, hasLength(1));
  });

  for (final action in ['Share text', 'Share PDF']) {
    testWidgets('$action platform exception has friendly sharing error', (
      tester,
    ) async {
      await start(tester, platformFails: true);
      await openShare(tester);
      await choose(tester, action);
      expect(
        find.text('Couldn\u2019t share the cut plan. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private native detail'), findsNothing);
      expect(
        find.text('Couldn\u2019t create the PDF. Try again.'),
        findsNothing,
      );
      expect(find.byType(ResultScreen), findsOneWidget);
    });
  }

  testWidgets(
    'generation is busy once, and leaving Result avoids late platform calls',
    (tester) async {
      final pending = Completer<Uint8List>();
      var calls = 0;
      final container = await start(
        tester,
        pdf: (_) {
          calls++;
          return pending.future;
        },
      );
      await openShare(tester);
      await tester.tap(find.text('Share PDF'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Creating PDF\u2026'), findsOneWidget);
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, 'Creating PDF\u2026'),
            )
            .onPressed,
        isNull,
      );
      expect(calls, 1);
      container.read(routerProvider).go('/projects/${fixture.id}');
      await tester.pumpAndSettle();
      pending.complete(Uint8List(4));
      await tester.pumpAndSettle();
      expect(shared, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'closing menu allows reopening and keeps Recalculate/Edit functional',
    (tester) async {
      await start(tester);
      await openShare(tester);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Recalculate'));
      await tester.pumpAndSettle();
      expect(find.text('Waste: 20.0%'), findsOneWidget);
      await openShare(tester);
      await choose(tester, 'Share text');
      await tester.tap(find.text('Edit cut list'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectScreen), findsOneWidget);
    },
  );

  testWidgets('share uses refreshed saved input without writing a result', (
    tester,
  ) async {
    await start(tester);
    final part = (await fixture.parts.getPartLines(fixture.id)).single;
    await fixture.parts.updatePart(
      part.id,
      PartInput(length: Length.fromTicks(3000000), quantity: 2),
    );
    await tester.pumpAndSettle();
    final before = (await fixture.projects.getProject(fixture.id))!;
    await openShare(tester);
    await choose(tester, 'Share text');
    expect(shared.single.text, contains('Waste: 40.0%'));
    final after = (await fixture.projects.getProject(fixture.id))!;
    expect(after.updatedAt, before.updatedAt);
    expect(after.revision, before.revision);
    expect(after.lastRunId, before.lastRunId);
    expect(fixture.db.schemaVersion, 2);
  });

  testWidgets('deleted result has no Share action', (tester) async {
    await start(tester);
    await fixture.projects.deleteProject(fixture.id);
    await tester.pumpAndSettle();
    expect(find.text('Cut list not found'), findsOneWidget);
    expect(find.text('Share'), findsNothing);
  });

  testWidgets('small dark large-text share menu stays usable', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await start(tester, buy: true);
    await openShare(tester);
    await choose(tester, 'Copy buy list');
    expect(copied, ['6000 mm \u00d7 4']);
    expect(tester.takeException(), isNull);
  });
}
