import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/project_creation.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/domain/models/app_language.dart';
import 'package:kerfplan/domain/models/measurement_system.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/models/project_defaults.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/presentation/home/home_screen.dart';
import 'package:kerfplan/presentation/onboarding/measurement_setup_screen.dart';
import 'package:kerfplan/presentation/shared/inputs/length_input.dart';
import 'package:kerfplan/presentation/stock/stock_preset_chips.dart';

void main() {
  late AppDatabase db;
  late DriftAppSettingsRepository settings;
  late DriftProjectRepository projects;
  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    settings = DriftAppSettingsRepository(db);
    projects = DriftProjectRepository(db);
  });
  tearDown(() => db.close());

  Future<ProviderContainer> show(
    WidgetTester tester, {
    String route = '/',
  }) async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    container.read(routerProvider).go(route);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const KerfPlanApp(),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('fresh en-US recommends Imperial but Metric override persists', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = [const Locale('en', 'US')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await show(tester);
    expect(find.byType(MeasurementSetupScreen), findsOneWidget);
    expect(
      tester
          .widget<ListTile>(find.byKey(const ValueKey('setup-imperial')))
          .selected,
      isTrue,
    );
    expect(find.textContaining('Recommended for your region'), findsOneWidget);
    expect(find.text('Log in'), findsNothing);
    expect(find.text('View Pro'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('setup-metric')));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    final saved = await settings.getSettings();
    expect(saved.onboardingCompleted, isTrue);
    expect(saved.measurementSystem, MeasurementSystem.metric);
    expect(saved.defaultDisplayUnit, DisplayUnit.mm);
    expect(saved.language, AppLanguage.system);
  });

  testWidgets('Imperial setup saves ftIn and survives a provider restart', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = [const Locale('en', 'GB')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    final first = await show(tester);
    expect(
      tester
          .widget<ListTile>(find.byKey(const ValueKey('setup-metric')))
          .selected,
      isTrue,
    );
    await tester.tap(find.byKey(const ValueKey('setup-imperial')));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect((await settings.getSettings()).defaultDisplayUnit, DisplayUnit.ftIn);
    first.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await show(tester);
    expect(find.byType(MeasurementSetupScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('measurement Settings change new-project defaults only', (
    tester,
  ) async {
    final old = await projects.createProject(
      ProjectMetadata(name: 'Old metric'),
    );
    await settings.updateSettings(
      (await settings.getSettings()).copyWith(onboardingCompleted: true),
    );
    final container = await show(tester, route: '/settings');
    expect(find.text('Measurement system'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Imperial'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ChoiceChip, 'ft + in'), findsOneWidget);
    expect(find.widgetWithText(ChoiceChip, 'mm'), findsNothing);
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    final current = await settings.getSettings();
    expect(current.measurementSystem, MeasurementSystem.imperial);
    expect(current.defaultDisplayUnit, DisplayUnit.ftIn);
    expect((await projects.getProject(old.id))!.displayUnit, DisplayUnit.mm);
    final next = await container
        .read(projectCreationProvider)
        .create(ProjectMetadata(name: 'New imperial'));
    expect(next.displayUnit, DisplayUnit.ftIn);
    expect(next.kerf.ticks, old.kerf.ticks);
    expect(next.minReusable.ticks, old.minReusable.ticks);
    expect((await projects.getProject(old.id))!.revision, 0);
    await tester.ensureVisible(find.widgetWithText(ChoiceChip, 'Metric'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Metric'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.widgetWithText(FilledButton, 'Save'));
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();
    expect((await settings.getSettings()).defaultDisplayUnit, DisplayUnit.mm);
    expect((await projects.getProject(next.id))!.displayUnit, DisplayUnit.ftIn);
  });

  testWidgets(
    'exact metric and imperial presets populate Stock and Buy entry',
    (tester) async {
      final metric = await projects.createProject(
        ProjectMetadata(name: 'Metric'),
      );
      await settings.updateSettings(
        (await settings.getSettings()).copyWith(onboardingCompleted: true),
      );
      final container = await show(
        tester,
        route: '/projects/${metric.id}/stock/new',
      );
      expect(find.byType(StockPresetChips), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('stock-preset-60000000')));
      await tester.pump();
      expect(
        tester
            .widget<LengthInputField>(find.byType(LengthInputField))
            .controller
            .length
            .ticks,
        60000000,
      );
      container.read(routerProvider).go('/projects/${metric.id}/stock/buy');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('stock-preset-24000000')));
      await tester.pump();
      expect(
        tester
            .widget<LengthInputField>(find.byType(LengthInputField))
            .controller
            .length
            .ticks,
        24000000,
      );

      final defaults = await settings.getSettings();
      final imperial = await projects.createProject(
        ProjectMetadata(name: 'Imperial'),
        defaults: ProjectCreationDefaults(
          displayUnit: DisplayUnit.ftIn,
          kerf: defaults.defaultKerf,
          minReusable: defaults.defaultReusable,
        ),
      );
      container.read(routerProvider).go('/projects/${imperial.id}/stock/new');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('stock-preset-24384000')));
      await tester.pump();
      expect(
        tester
            .widget<LengthInputField>(find.byType(LengthInputField))
            .controller
            .length
            .ticks,
        24384000,
      );
      expect(find.text("8' 0\""), findsWidgets);
    },
  );

  for (final locale in [const Locale('de', 'DE'), const Locale('ru', 'RU')]) {
    testWidgets('$locale onboarding stays readable on a small screen', (
      tester,
    ) async {
      tester.platformDispatcher.localesTestValue = [locale];
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await show(tester);
      expect(find.byType(MeasurementSetupScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Turkish measurement Settings renders without overflow', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = [const Locale('tr', 'TR')];
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await settings.updateSettings(
      (await settings.getSettings()).copyWith(onboardingCompleted: true),
    );
    await show(tester, route: '/settings');
    expect(find.text('Ölçü sistemi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
