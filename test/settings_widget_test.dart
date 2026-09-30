import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/app/settings_providers.dart';
import 'package:kerfplan/app/theme/app_theme.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/domain/models/app_preferences.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/repositories/app_settings_repository.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/settings/settings_screen.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';

import 'support/optimization_fixture.dart';

class SettingsGate implements AppSettingsRepository {
  SettingsGate(this.delegate);
  final AppSettingsRepository delegate;
  final gate = Completer<void>();
  int calls = 0;
  @override
  Future<AppPreferences> getSettings() => delegate.getSettings();
  @override
  Stream<AppPreferences> watchSettings() => delegate.watchSettings();
  @override
  Future<void> updateSettings(AppPreferences values) async {
    calls++;
    await gate.future;
    await delegate.updateSettings(values);
  }
}

void main() {
  late OptimizationFixture f;
  late DriftAppSettingsRepository repository;
  setUp(() async {
    f = OptimizationFixture();
    await f.initialize();
    repository = DriftAppSettingsRepository(f.db);
  });
  tearDown(() => f.close());
  Future<ProviderContainer> start(
    WidgetTester tester, {
    String route = '/settings',
    bool failLoad = false,
    SettingsGate? gate,
    bool pending = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(f.db),
        if (gate != null) appSettingsRepositoryProvider.overrideWithValue(gate),
        if (failLoad)
          appSettingsProvider.overrideWith((ref) {
            if (failLoad) {
              failLoad = false;
              return Stream.error(StateError('private detail'));
            }
            return repository.watchSettings();
          }),
        if (pending)
          appSettingsProvider.overrideWith((ref) => const Stream.empty()),
      ],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(route);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    if (!pending) await tester.pumpAndSettle();
    return container;
  }

  Finder editor(String label) =>
      find.byWidgetPredicate((w) => w is LengthInputField && w.label == label);
  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> chip(WidgetTester tester, String label) =>
      tap(tester, find.widgetWithText(ChoiceChip, label));
  Future<void> save(WidgetTester tester) =>
      tap(tester, find.widgetWithText(FilledButton, 'Save'));
  Future<void> metric(WidgetTester tester, String label, String value) async {
    final field = find.descendant(
      of: editor(label),
      matching: find.byKey(const ValueKey('length-input')),
    );
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.enterText(field, value);
  }

  LengthEditingController control(WidgetTester tester, String label) =>
      tester.widget<LengthInputField>(editor(label)).controller;
  ThemeMode? mode(WidgetTester tester) =>
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode;

  testWidgets(
    'fresh Settings show clear defaults and appearance; root uses System',
    (tester) async {
      await start(tester);
      for (final text in [
        'Defaults',
        'Default units',
        'Default kerf',
        'Default reusable leftover',
        'Appearance',
        'Theme',
        'System',
        'Light',
        'Dark',
      ]) {
        expect(find.text(text), findsOneWidget);
      }
      expect(
        find.text(
          'These values are used when you create a new cut list. Existing cut lists are not changed.',
        ),
        findsOneWidget,
      );
      expect(control(tester, 'Default kerf').length.ticks, 30000);
      expect(
        control(tester, 'Default reusable leftover').length.ticks,
        1000000,
      );
      expect(mode(tester), ThemeMode.system);
      expect((await f.db.select(f.db.appSettings).get()).length, 1);
    },
  );
  testWidgets('startup pending/error preferences safely use System', (
    tester,
  ) async {
    await start(tester, route: '/', pending: true);
    expect(mode(tester), ThemeMode.system);
    expect(find.text('KerfPlan'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final entry in [
    (AppThemeMode.system, ThemeMode.system, 'System'),
    (AppThemeMode.light, ThemeMode.light, 'Light'),
    (AppThemeMode.dark, ThemeMode.dark, 'Dark'),
  ]) {
    testWidgets(
      '${entry.$1} maps and applies after Save, persisting without leaving Settings',
      (tester) async {
        expect(AppTheme.mode(entry.$1), entry.$2);
        await start(tester);
        await chip(tester, entry.$3);
        expect(mode(tester), ThemeMode.system);
        await save(tester);
        expect(mode(tester), entry.$2);
        expect((await repository.getSettings()).themeMode, entry.$1);
        expect(find.byType(SettingsScreen), findsOneWidget);
        expect(find.text('Settings saved'), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(find.widgetWithText(FilledButton, 'Save'))
              .onPressed,
          isNotNull,
        );
      },
    );
  }
  testWidgets('theme can change repeatedly on one Settings visit', (
    tester,
  ) async {
    await start(tester);
    for (final entry in [
      ('Dark', ThemeMode.dark),
      ('Light', ThemeMode.light),
      ('System', ThemeMode.system),
    ]) {
      await chip(tester, entry.$1);
      await save(tester);
      expect(mode(tester), entry.$2);
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    }
  });
  testWidgets(
    'save exact imperial defaults then create a new project; old project stays intact',
    (tester) async {
      final old = await f.db.select(f.db.projects).getSingle();
      final container = await start(tester);
      await chip(tester, 'ft + in');
      final kerf = editor('Default kerf');
      final inches = find.descendant(
        of: kerf,
        matching: find.byKey(const ValueKey('length-inches')),
      );
      await tester.ensureVisible(inches);
      await tester.enterText(inches, '0');
      final dropdown = find.descendant(
        of: kerf,
        matching: find.byType(DropdownButtonFormField<int>),
      );
      await tap(tester, dropdown);
      await tap(tester, find.text('1/8').last);
      final reusable = editor('Default reusable leftover');
      final reusableInches = find.descendant(
        of: reusable,
        matching: find.byKey(const ValueKey('length-inches')),
      );
      await tester.ensureVisible(reusableInches);
      await tester.enterText(reusableInches, '4');
      // Clear the initial rounded fraction for the exact whole-inch threshold.
      control(tester, 'Default reusable leftover').sixteenths = 0;
      await chip(tester, 'Dark');
      await save(tester);
      final saved = await repository.getSettings();
      expect(saved.defaultDisplayUnit, DisplayUnit.ftIn);
      expect(saved.defaultKerf.ticks, 31750);
      expect(saved.defaultReusable.ticks, 1016000);
      expect(mode(tester), ThemeMode.dark);
      container.read(routerProvider).go('/projects/new');
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('project-name')),
        'New imperial',
      );
      await tap(tester, find.widgetWithText(FilledButton, 'Create Cut List'));
      expect(find.byType(ProjectScreen), findsOneWidget);
      final id = tester
          .widget<ProjectScreen>(find.byType(ProjectScreen))
          .projectId;
      final project = (await f.projects.getProject(id))!;
      expect(project.displayUnit, DisplayUnit.ftIn);
      expect(project.kerf.ticks, 31750);
      expect(project.minReusable.ticks, 1016000);
      expect(project.endTrim.ticks, 0);
      expect(project.revision, 0);
      expect(
        await (f.db.select(
          f.db.projects,
        )..where((r) => r.id.equals(old.id))).getSingle(),
        old,
      );
    },
  );
  testWidgets(
    'unit switches and untouched imperial Save preserve arbitrary ticks',
    (tester) async {
      final original = AppPreferences(
        defaultDisplayUnit: DisplayUnit.mm,
        defaultKerf: Length.fromTicks(30001),
        defaultReusable: Length.fromTicks(1000001),
        themeMode: AppThemeMode.system,
      );
      await repository.updateSettings(original);
      await start(tester);
      for (final unit in ['in', 'ft + in', 'mm', 'in']) {
        await chip(tester, unit);
        expect(control(tester, 'Default kerf').length.ticks, 30001);
        expect(
          control(tester, 'Default reusable leftover').length.ticks,
          1000001,
        );
      }
      await save(tester);
      final saved = await repository.getSettings();
      expect(saved.defaultDisplayUnit, DisplayUnit.inch);
      expect(saved.defaultKerf, original.defaultKerf);
      expect(saved.defaultReusable, original.defaultReusable);
    },
  );
  for (final label in ['Default kerf', 'Default reusable leftover']) {
    testWidgets('negative $label cannot save or change units', (tester) async {
      await start(tester);
      await metric(tester, label, '-1');
      await save(tester);
      expect(await repository.getSettings(), AppPreferences.defaults);
      await chip(tester, 'in');
      expect(control(tester, label).unit, DisplayUnit.mm);
      expect(control(tester, label).text, '-1');
    });
  }
  for (final unit in ['mm', 'in', 'ft + in']) {
    testWidgets('both zero defaults can save in $unit', (tester) async {
      await start(tester);
      await metric(tester, 'Default kerf', '0');
      await metric(tester, 'Default reusable leftover', '0');
      await chip(tester, unit);
      await save(tester);
      final settings = await repository.getSettings();
      expect(settings.defaultKerf.ticks, 0);
      expect(settings.defaultReusable.ticks, 0);
    });
  }
  testWidgets(
    'failed save retains numeric/unit/theme edits and does not apply pending theme',
    (tester) async {
      await start(tester);
      await f.db.customStatement(
        "CREATE TRIGGER fail_settings BEFORE UPDATE ON app_settings BEGIN SELECT RAISE(ABORT,'private detail'); END",
      );
      await metric(tester, 'Default kerf', '4');
      await metric(tester, 'Default reusable leftover', '200');
      await chip(tester, 'cm');
      await chip(tester, 'Dark');
      await save(tester);
      expect(
        find.text('Couldn\u2019t save settings. Try again.'),
        findsOneWidget,
      );
      expect(find.textContaining('private detail'), findsNothing);
      expect(mode(tester), ThemeMode.system);
      expect(await repository.getSettings(), AppPreferences.defaults);
      expect(control(tester, 'Default kerf').length.ticks, 40000);
      expect(
        control(tester, 'Default reusable leftover').length.ticks,
        2000000,
      );
      expect(control(tester, 'Default kerf').unit, DisplayUnit.cm);
      expect(
        tester
            .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Dark'))
            .selected,
        isTrue,
      );
      await f.db.customStatement('DROP TRIGGER fail_settings');
      await save(tester);
      expect(mode(tester), ThemeMode.dark);
      expect((await repository.getSettings()).defaultKerf.ticks, 40000);
    },
  );
  testWidgets(
    'load error has localized Retry and root safely falls back to System',
    (tester) async {
      await start(tester, failLoad: true);
      expect(find.text('Couldn\u2019t load settings.'), findsOneWidget);
      expect(find.textContaining('private detail'), findsNothing);
      expect(mode(tester), ThemeMode.system);
      await tap(tester, find.widgetWithText(FilledButton, 'Retry'));
      expect(find.text('Default kerf'), findsOneWidget);
    },
  );
  testWidgets('duplicate Save taps cause one atomic write', (tester) async {
    final gate = SettingsGate(repository);
    await start(tester, gate: gate);
    await metric(tester, 'Default kerf', '4');
    final button = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump();
    await tester.tap(button);
    await tester.pump();
    expect(gate.calls, 1);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);
    gate.gate.complete();
    await tester.pumpAndSettle();
    expect((await repository.getSettings()).defaultKerf.ticks, 40000);
  });
  testWidgets(
    'small dark large-text Settings choices and Save remain usable and at least 48dp',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      await start(tester);
      await chip(tester, 'ft + in');
      await chip(tester, 'Dark');
      await save(tester);
      for (final chip in find.byType(ChoiceChip).evaluate()) {
        expect(
          tester.getSize(find.byWidget(chip.widget)).height,
          greaterThanOrEqualTo(48),
        );
      }
      expect(
        tester.getSize(find.widgetWithText(FilledButton, 'Save')).height,
        greaterThanOrEqualTo(48),
      );
      expect(tester.takeException(), isNull);
    },
  );
}
