import 'support/app_ready.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/l10n/app_localizations.dart';
import 'package:kerfplan/presentation/results/result_summary.dart';

import 'support/optimization_fixture.dart';

void main() {
  testWidgets(
    'Result disclaimer is a readable footer while summary and actions remain',
    (tester) async {
      final f = OptimizationFixture();
      await f.initialize();
      await f.stock(1000);
      await f.part(400, quantity: 2);
      addTearDown(f.close);
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(f.db)],
      );
      addTearDown(container.dispose);
      container.read(routerProvider).go('/projects/${f.id}/result');
      await completeOnboarding(f.db);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const KerfPlanApp(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ResultSummary), findsOneWidget);
      final labels = AppLocalizations.of(
        tester.element(find.byType(ResultSummary)),
      );
      final disclaimer = find.text(labels.verifyBeforeCutting);
      await tester.scrollUntilVisible(
        disclaimer,
        250,
        scrollable: find.byType(Scrollable).first,
      );
      expect(disclaimer, findsOneWidget);
      for (final action in ['Recalculate', 'Edit cut list']) {
        final button = find.ancestor(
          of: find.text(action),
          matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
        );
        expect(button, findsOneWidget);
        expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
      }
      expect(find.text('Share'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
