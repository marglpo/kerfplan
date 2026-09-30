import '../units/display_unit.dart';
import '../units/length.dart';
import 'inventory_mode.dart';
import 'app_preferences.dart';

/// Explicit snapshot supplied when creating a project. Theme is not project data.
final class ProjectCreationDefaults {
  const ProjectCreationDefaults({
    required this.displayUnit,
    required this.kerf,
    required this.minReusable,
  });
  final DisplayUnit displayUnit;
  final Length kerf;
  final Length minReusable;
}

abstract final class ProjectDefaults {
  static const inventoryMode = InventoryMode.fixed;
  static final displayUnit = AppPreferences.defaults.defaultDisplayUnit;
  static final kerf = AppPreferences.defaults.defaultKerf;
  static final endTrim = Length.fromTicks(0);
  static final minReusable = AppPreferences.defaults.defaultReusable;
  static final creation = ProjectCreationDefaults(
    displayUnit: displayUnit,
    kerf: kerf,
    minReusable: minReusable,
  );
  static const Length? buyStockLength = null;
  static const revision = 0;
  static const String? lastRunId = null;
}
