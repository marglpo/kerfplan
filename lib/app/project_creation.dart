import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/cut_project.dart';
import '../domain/models/project_defaults.dart';
import '../domain/models/project_metadata.dart';
import '../domain/repositories/app_settings_repository.dart';
import '../domain/repositories/project_repository.dart';
import 'project_providers.dart';
import 'settings_providers.dart';

final projectCreationProvider = Provider<ProjectCreation>(
  (ref) => ProjectCreation(
    ref.watch(appSettingsRepositoryProvider),
    ref.watch(projectRepositoryProvider),
  ),
);

final class ProjectCreation {
  const ProjectCreation(this.settings, this.projects);
  final AppSettingsRepository settings;
  final ProjectRepository projects;

  Future<CutProject> create(ProjectMetadata metadata) async {
    final snapshot = await settings.getSettings();
    return projects.createProject(
      metadata,
      defaults: ProjectCreationDefaults(
        displayUnit: snapshot.defaultDisplayUnit,
        kerf: snapshot.defaultKerf,
        minReusable: snapshot.defaultReusable,
      ),
    );
  }
}
