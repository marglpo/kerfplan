import '../models/cut_project.dart';
import '../models/project_defaults.dart';
import '../models/cut_settings_input.dart';
import '../models/project_metadata.dart';
import '../models/inventory_mode.dart';
import '../units/length.dart';

abstract interface class ProjectRepository {
  Stream<List<CutProject>> watchProjects();
  Stream<CutProject?> watchProject(String id);
  Future<CutProject?> getProject(String id);
  Future<CutProject> createProject(
    ProjectMetadata metadata, {
    ProjectCreationDefaults? defaults,
  });
  Future<void> updateProjectMetadata(String id, ProjectMetadata metadata);
  Future<CutProject> duplicateProject(String id, {required String copyLabel});
  Future<void> deleteProject(String id);
  Future<void> setInventoryMode(String id, InventoryMode mode);
  Future<void> setBuyStockLength(String id, Length length);
  Future<void> updateCutSettings(String id, CutSettingsInput settings);
}

final class ProjectNotFoundException implements Exception {
  const ProjectNotFoundException(this.id);
  final String id;
}
