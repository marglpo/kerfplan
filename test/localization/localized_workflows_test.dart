import '../support/app_ready.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/domain/models/app_language.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/l10n/app_localizations.dart';
import 'package:kerfplan/services/export/cut_report_builder.dart';
import 'package:kerfplan/services/export/cut_report_pdf.dart';
import 'package:kerfplan/services/export/cut_report_text.dart';

import '../domain/optimizer/optimizer_test_support.dart';
import '../support/optimization_fixture.dart';

void main() {
  setUpAll(() async => initializeDateFormatting());
  late OptimizationFixture fixture;
  setUp(() async {
    fixture = OptimizationFixture();
    await fixture.initialize();
  });
  tearDown(() => fixture.close());

  Future<void> setLanguage(AppLanguage language) async {
    final repository = DriftAppSettingsRepository(fixture.db);
    final current = await repository.getSettings();
    await repository.updateSettings(current.copyWith(language: language));
  }

  Future<ProviderContainer> show(WidgetTester tester, String route) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(fixture.db)],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(route);
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

  testWidgets(
    'system Spanish, manual English, and system return without restart',
    (tester) async {
      tester.platformDispatcher.localesTestValue = [const Locale('es', 'MX')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      final container = await show(tester, '/settings');
      expect(find.text('Ajustes'), findsOneWidget);
      expect(find.text('Predeterminado del sistema'), findsOneWidget);
      await tester.tap(find.text('Idioma'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Українська'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ListView).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Українська'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('English'),
        -200,
        scrollable: find
            .descendant(
              of: find.byType(ListView).last,
              matching: find.byType(Scrollable),
            )
            .first,
      );
      await tester.tap(find.text('English').last);
      await tester.pumpAndSettle();
      expect(find.text('Settings'), findsOneWidget);
      expect(
        (await DriftAppSettingsRepository(fixture.db).getSettings()).language,
        AppLanguage.english,
      );
      expect(
        container.read(routerProvider).routeInformationProvider.value.uri.path,
        '/settings',
      );
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('System default').last);
      await tester.pumpAndSettle();
      expect(find.text('Ajustes'), findsOneWidget);
      tester.platformDispatcher.localesTestValue = [const Locale('de', 'AT')];
      await tester.pumpAndSettle();
      expect(find.text('Einstellungen'), findsOneWidget);
    },
  );

  testWidgets('manual language changes only locale preference', (tester) async {
    final settings = DriftAppSettingsRepository(fixture.db);
    final before = await settings.getSettings();
    final project = await fixture.projects.getProject(fixture.id);
    await show(tester, '/settings');
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Español').last);
    await tester.pumpAndSettle();
    expect(find.text('Ajustes'), findsOneWidget);
    final after = await settings.getSettings();
    expect(after.language, AppLanguage.spanish);
    expect(after.themeMode, before.themeMode);
    expect(after.defaultDisplayUnit, before.defaultDisplayUnit);
    expect(after.defaultKerf, before.defaultKerf);
    expect(after.defaultReusable, before.defaultReusable);
    expect(
      (await fixture.projects.getProject(fixture.id))!.revision,
      project!.revision,
    );
    expect((await fixture.projects.getProject(fixture.id))!.kerf, project.kerf);
    expect(
      (await fixture.db.select(fixture.db.entitlementCache).get()),
      isEmpty,
    );
    expect(
      AppThemeMode.fromStorage(
        (await fixture.db.select(fixture.db.appSettings).getSingle()).themeMode,
      ),
      before.themeMode,
    );
  });

  for (final (language, route, expected) in [
    (AppLanguage.spanish, '/', 'Nueva lista de cortes'),
    (AppLanguage.german, '/projects/id', 'Schnitteinstellungen'),
    (AppLanguage.polish, '/settings', 'Ustawienia'),
    (AppLanguage.french, '/pro', 'Un seul achat. À vous pour toujours.'),
    (AppLanguage.turkish, '/projects/id/parts/new', 'Parça ekle'),
    (
      AppLanguage.ukrainian,
      '/projects/id/cut-settings',
      'Налаштування різання',
    ),
  ]) {
    testWidgets('$language $route renders without overflow', (tester) async {
      await setLanguage(language);
      await show(tester, route.replaceAll('/id', '/${fixture.id}'));
      expect(find.text(expected), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Russian Result keeps calculated values readable on a small phone',
    (tester) async {
      await fixture.stock(1000);
      await fixture.part(400, quantity: 2, name: 'Brace Ж');
      await setLanguage(AppLanguage.russian);
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await show(tester, '/projects/${fixture.id}/result');
      expect(find.text('План распила'), findsOneWidget);
      expect(find.textContaining('Использована 1 заготовка'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'Spanish, German and Russian reports translate labels but keep data',
    () async {
      final input = fixed(
        [stock(1000)],
        [part(400, quantity: 2, name: 'Brace Ж')],
      );
      final project = (await fixture.projects.getProject(fixture.id))!;
      final result = const FfdCutOptimizer().optimize(input);
      final reports = <String>[];
      for (final (locale, heading) in [
        (const Locale('es'), 'Resumen'),
        (const Locale('de'), 'Übersicht'),
        (const Locale('ru'), 'Сводка'),
      ]) {
        final report = CutReportBuilder.build(
          project: project,
          result: result,
          generatedAt: DateTime.utc(2026, 9, 30),
          labels: lookupAppLocalizations(locale),
        );
        final text = cutReportText(report);
        expect(text, contains(heading));
        expect(text, contains('Brace Ж'));
        expect(
          report.disclaimer,
          lookupAppLocalizations(locale).verifyBeforeCutting,
        );
        reports.add(text);
      }
      expect(reports.toSet(), hasLength(3));
    },
  );

  test('all supported localized PDFs generate fully offline', () async {
    final input = fixed([stock(1000)], [part(400, name: 'Brace Ж')]);
    final project = (await fixture.projects.getProject(fixture.id))!;
    final result = const FfdCutOptimizer().optimize(input);
    for (final locale in [
      const Locale('en'),
      const Locale('es'),
      const Locale('de'),
      const Locale('fr'),
      const Locale('pt', 'BR'),
      const Locale('it'),
      const Locale('pl'),
      const Locale('ru'),
      const Locale('tr'),
      const Locale('uk'),
    ]) {
      final report = CutReportBuilder.build(
        project: project,
        result: result,
        generatedAt: DateTime.utc(2026, 9, 30),
        labels: lookupAppLocalizations(locale),
      );
      final pdf = await HttpOverrides.runZoned(
        () => CutReportPdf().build(report),
        createHttpClient: (_) => throw StateError('Network font access'),
      );
      expect(pdf.length, greaterThan(1000), reason: locale.toString());
      expect(cutReportText(report), contains('Brace Ж'));
    }
  });
}
