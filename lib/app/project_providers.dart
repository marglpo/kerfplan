import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database_provider.dart';
import '../data/repositories/drift_project_repository.dart';
import '../domain/models/cut_project.dart';
import '../domain/repositories/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => DriftProjectRepository(ref.watch(appDatabaseProvider)),
);

final projectsProvider = StreamProvider.autoDispose<List<CutProject>>(
  (ref) => ref.watch(projectRepositoryProvider).watchProjects(),
  retry: (count, error) => null,
);

final projectProvider = StreamProvider.autoDispose.family<CutProject?, String>(
  (ref, id) => ref.watch(projectRepositoryProvider).watchProject(id),
  retry: (count, error) => null,
);
