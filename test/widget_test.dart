import 'support/app_ready.dart';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/app.dart';
import 'package:kerfplan/app/project_providers.dart';
import 'package:kerfplan/app/router.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/db/database_provider.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/presentation/home/home_screen.dart';
import 'package:kerfplan/presentation/projects/new_project_screen.dart';
import 'package:kerfplan/presentation/projects/project_screen.dart';
import 'package:kerfplan/presentation/settings/settings_screen.dart';

void main() {
  late AppDatabase db;
  late DriftProjectRepository repository;

  setUp(() {
    db = AppDatabase.withExecutor(NativeDatabase.memory());
    repository = DriftProjectRepository(db);
  });
  tearDown(() => db.close());

  Future<ProviderContainer> startApp(
    WidgetTester tester, {
    String? route,
    bool failHomeOnce = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        if (failHomeOnce)
          projectsProvider.overrideWith((ref) {
            if (failHomeOnce) {
              failHomeOnce = false;
              return Stream.error(StateError('technical database detail'));
            }
            return ref.watch(projectRepositoryProvider).watchProjects();
          }),
      ],
    );
    addTearDown(container.dispose);
    if (route != null) container.read(routerProvider).go(route);
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

  Future<void> enterName(WidgetTester tester, String name) =>
      tester.enterText(find.byKey(const ValueKey('project-name')), name);

  Future<void> openMenu(WidgetTester tester, String name) async {
    await tester.tap(find.byTooltip('Actions for $name'));
    await tester.pumpAndSettle();
  }

  testWidgets('app starts with the localized empty state', (tester) async {
    await startApp(tester);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('KerfPlan'), findsOneWidget);
    expect(find.text('No cut lists yet'), findsOneWidget);
    expect(find.text('Plan your first job in under a minute.'), findsOneWidget);
    expect(find.text('New Cut List'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Settings button navigates and Back returns home', (
    tester,
  ) async {
    await startApp(tester);
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Default units'), findsOneWidget);
    expect(find.text('Default kerf'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('No cut lists yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('system dark theme and large text render on a small screen', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await startApp(tester);
    final theme = Theme.of(tester.element(find.byType(HomeScreen)));
    expect(theme.brightness, Brightness.dark);
    expect(theme.useMaterial3, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Home renders persisted metadata without claiming calculation history',
    (tester) async {
      final project = await repository.createProject(
        ProjectMetadata(name: 'Garage frame', material: 'Steel'),
      );
      await startApp(tester);
      expect(find.text('Garage frame'), findsOneWidget);
      expect(find.text('Steel'), findsOneWidget);
      expect(find.text('Not calculated yet'), findsNothing);
      expect(find.textContaining('Updated '), findsOneWidget);
      await tester.tap(find.text('Garage frame'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<ProjectScreen>(find.byType(ProjectScreen)).projectId,
        project.id,
      );
      await tester.scrollUntilVisible(
        find.text('Kerf: 3 mm'),
        200,
        scrollable: find
            .descendant(
              of: find.byType(ProjectScreen),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      expect(find.text('Kerf: 3 mm'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Calculate'),
            )
            .onPressed,
        isNull,
      );
    },
  );

  testWidgets(
    'New Cut List opens form and successful creation reaches project',
    (tester) async {
      await startApp(tester);
      await tester.tap(find.text('New Cut List'));
      await tester.pumpAndSettle();
      expect(find.byType(NewProjectScreen), findsOneWidget);
      await enterName(tester, ' Garage frame ');
      await tester.enterText(
        find.byKey(const ValueKey('project-material')),
        ' 40x20 steel ',
      );
      await tester.enterText(
        find.byKey(const ValueKey('project-note')),
        ' South wall ',
      );
      await tester.tap(find.text('Create Cut List'));
      // A repeated tap before rebuilding must not submit a second project.
      await tester.tap(find.text('Create Cut List'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect(find.text('Garage frame'), findsOneWidget);
      expect(find.text('40x20 steel'), findsOneWidget);
      expect(find.text('South wall'), findsOneWidget);
      expect(await db.select(db.projects).get(), hasLength(1));
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('Garage frame'), findsOneWidget);
    },
  );

  testWidgets('form rejects blank and overlong names without writing', (
    tester,
  ) async {
    await startApp(tester, route: '/projects/new');
    await enterName(tester, '   ');
    await tester.tap(find.text('Create Cut List'));
    await tester.pumpAndSettle();
    expect(find.text('Enter a project name.'), findsOneWidget);
    await enterName(tester, 'A' * 81);
    await tester.tap(find.text('Create Cut List'));
    await tester.pumpAndSettle();
    expect(
      find.text('Project name must be 80 characters or fewer.'),
      findsOneWidget,
    );
    expect(await db.select(db.projects).get(), isEmpty);
  });

  testWidgets(
    'editing metadata updates Project and Home through persisted streams',
    (tester) async {
      final project = await repository.createProject(
        ProjectMetadata(name: 'Before'),
      );
      await startApp(tester, route: '/projects/${project.id}');
      await tester.tap(find.byTooltip('Edit details'));
      await tester.pumpAndSettle();
      await enterName(tester, 'After');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectScreen), findsOneWidget);
      expect(find.text('After'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('After'), findsOneWidget);
      expect(find.text('Before'), findsNothing);
    },
  );

  testWidgets('Home Edit details returns to Project after saving', (
    tester,
  ) async {
    await repository.createProject(ProjectMetadata(name: 'Frame'));
    await startApp(tester);
    await openMenu(tester, 'Frame');
    await tester.tap(find.text('Edit details'));
    await tester.pumpAndSettle();
    await enterName(tester, 'Renamed frame');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(find.text('Renamed frame'), findsOneWidget);
  });

  testWidgets('unknown project ID renders not-found and returns to projects', (
    tester,
  ) async {
    await startApp(tester, route: '/projects/missing');
    expect(find.text('Cut list not found'), findsOneWidget);
    await tester.tap(find.text('Back to projects'));
    await tester.pumpAndSettle();
    expect(find.text('No cut lists yet'), findsOneWidget);
  });

  testWidgets('project deleted while open becomes not-found', (tester) async {
    final project = await repository.createProject(
      ProjectMetadata(name: 'Frame'),
    );
    await startApp(tester, route: '/projects/${project.id}');
    await repository.deleteProject(project.id);
    await tester.pumpAndSettle();
    expect(find.text('Cut list not found'), findsOneWidget);
  });

  testWidgets('Home duplicate persists a copy and opens it', (tester) async {
    await repository.createProject(ProjectMetadata(name: 'Frame'));
    await startApp(tester);
    await openMenu(tester, 'Frame');
    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();
    expect(find.byType(ProjectScreen), findsOneWidget);
    expect(find.text('Frame Copy'), findsOneWidget);
    expect(await db.select(db.projects).get(), hasLength(2));
  });

  testWidgets('deletion requires confirmation and updates Home with feedback', (
    tester,
  ) async {
    final project = await repository.createProject(
      ProjectMetadata(name: 'Frame'),
    );
    await startApp(tester);
    await openMenu(tester, 'Frame');
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete cut list?'), findsOneWidget);
    expect(
      find.text('This permanently deletes "Frame" from this device.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await repository.getProject(project.id), isNotNull);
    await openMenu(tester, 'Frame');
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(find.text('No cut lists yet'), findsOneWidget);
    expect(find.text('Cut list deleted'), findsOneWidget);
    expect(await repository.getProject(project.id), isNull);
  });

  testWidgets(
    'save failure preserves input, hides exceptions and allows retry',
    (tester) async {
      await db.customStatement(
        "CREATE TRIGGER fail_save BEFORE INSERT ON projects BEGIN SELECT RAISE(ABORT, 'private SQL detail'); END",
      );
      await startApp(tester, route: '/projects/new');
      await enterName(tester, 'Retained name');
      await tester.tap(find.text('Create Cut List'));
      await tester.pumpAndSettle();
      expect(
        find.text('Couldn’t save the cut list. Try again.'),
        findsOneWidget,
      );
      expect(find.text('Retained name'), findsOneWidget);
      expect(find.textContaining('private SQL detail'), findsNothing);
      await db.customStatement('DROP TRIGGER fail_save');
      await tester.tap(find.text('Create Cut List'));
      await tester.pumpAndSettle();
      expect(find.byType(ProjectScreen), findsOneWidget);
    },
  );

  testWidgets('Home load failure uses localized Retry and recovers', (
    tester,
  ) async {
    await startApp(tester, failHomeOnce: true);
    expect(find.text('Couldn’t load your cut lists.'), findsOneWidget);
    expect(find.textContaining('technical database detail'), findsNothing);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('No cut lists yet'), findsOneWidget);
  });

  testWidgets('project load failure uses localized Retry and recovers', (
    tester,
  ) async {
    final project = await repository.createProject(
      ProjectMetadata(name: 'Frame'),
    );
    await db.customStatement(
      "UPDATE projects SET display_unit = 'invalid' WHERE id = ?",
      [project.id],
    );
    await startApp(tester, route: '/projects/${project.id}');
    expect(find.text('Couldn’t load this cut list.'), findsOneWidget);
    expect(find.textContaining('FormatException'), findsNothing);
    await db.customStatement(
      "UPDATE projects SET display_unit = 'mm' WHERE id = ?",
      [project.id],
    );
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Frame'), findsOneWidget);
  });

  testWidgets('deletion failure keeps the project and shows a safe error', (
    tester,
  ) async {
    await repository.createProject(ProjectMetadata(name: 'Frame'));
    await db.customStatement(
      "CREATE TRIGGER fail_delete BEFORE DELETE ON projects BEGIN SELECT RAISE(ABORT, 'private SQL detail'); END",
    );
    await startApp(tester);
    await openMenu(tester, 'Frame');
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(
      find.text('Couldn’t delete the cut list. Try again.'),
      findsOneWidget,
    );
    expect(find.text('Frame'), findsOneWidget);
    expect(await db.select(db.projects).get(), hasLength(1));
  });
}
