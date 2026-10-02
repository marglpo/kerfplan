import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/app/project_creation.dart';
import 'package:kerfplan/data/db/app_database.dart';
import 'package:kerfplan/data/repositories/drift_app_settings_repository.dart';
import 'package:kerfplan/data/repositories/drift_entitlement_repository.dart';
import 'package:kerfplan/data/repositories/drift_project_repository.dart';
import 'package:kerfplan/domain/billing/billing_product.dart';
import 'package:kerfplan/domain/models/app_language.dart';
import 'package:kerfplan/domain/models/app_theme_mode.dart';
import 'package:kerfplan/domain/models/measurement_system.dart';
import 'package:kerfplan/domain/models/project_metadata.dart';
import 'package:kerfplan/domain/units/display_unit.dart';

void main() {
  test(
    'system changes affect new projects without touching old data or ownership',
    () async {
      final db = AppDatabase.withExecutor(NativeDatabase.memory());
      try {
        final settings = DriftAppSettingsRepository(db);
        final projects = DriftProjectRepository(db);
        final entitlements = DriftEntitlementRepository(db);
        final creation = ProjectCreation(settings, projects);
        final old = await creation.create(ProjectMetadata(name: 'Old'));
        final time = DateTime.utc(2026, 9, 30);
        await entitlements.setProductOwned(
          BillingProduct.lifetimePro,
          true,
          time,
        );
        final current = await settings.getSettings();
        await settings.updateSettings(
          current.copyWith(
            language: AppLanguage.russian,
            themeMode: AppThemeMode.dark,
            onboardingCompleted: true,
            measurementSystem: MeasurementSystem.imperial,
            defaultDisplayUnit: DisplayUnit.ftIn,
          ),
        );
        final imperial = await creation.create(
          ProjectMetadata(name: 'New imperial'),
        );
        expect(imperial.displayUnit, DisplayUnit.ftIn);
        final next = await settings.getSettings();
        await settings.updateSettings(
          next.copyWith(
            measurementSystem: MeasurementSystem.metric,
            defaultDisplayUnit: DisplayUnit.mm,
          ),
        );
        final metric = await creation.create(
          ProjectMetadata(name: 'New metric'),
        );
        expect(metric.displayUnit, DisplayUnit.mm);
        expect(
          (await projects.getProject(old.id))!.displayUnit,
          DisplayUnit.mm,
        );
        expect(
          (await projects.getProject(imperial.id))!.displayUnit,
          DisplayUnit.ftIn,
        );
        expect((await projects.getProject(old.id))!.revision, 0);
        expect((await projects.getProject(imperial.id))!.revision, 0);
        expect((await settings.getSettings()).language, AppLanguage.russian);
        expect((await settings.getSettings()).themeMode, AppThemeMode.dark);
        expect((await entitlements.getEntitlements()).isPro, isTrue);
      } finally {
        await db.close();
      }
    },
  );
}
