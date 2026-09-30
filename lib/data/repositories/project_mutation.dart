import 'package:drift/drift.dart';

import '../../domain/repositories/project_repository.dart';
import '../db/app_database.dart';

DateTime databaseTimestamp(DateTime now) => DateTime.fromMillisecondsSinceEpoch(
  (now.toUtc().millisecondsSinceEpoch ~/ 1000) * 1000,
  isUtc: true,
);

DateTime nextDatabaseTimestamp(DateTime now, DateTime previous) {
  final normalized = databaseTimestamp(now);
  return normalized.isAfter(previous)
      ? normalized
      : previous.toUtc().add(const Duration(seconds: 1));
}

Future<Project> requireProject(AppDatabase db, String id) async =>
    await (db.select(
      db.projects,
    )..where((row) => row.id.equals(id))).getSingleOrNull() ??
    (throw ProjectNotFoundException(id));

/// Call inside the same transaction as the input mutation.
Future<void> touchProject(
  AppDatabase db,
  Project project,
  DateTime now, {
  bool affectsOptimization = true,
}) async {
  if (affectsOptimization && project.revision == 0x7FFFFFFFFFFFFFFF) {
    throw StateError('Project revision overflow');
  }
  await (db.update(
    db.projects,
  )..where((row) => row.id.equals(project.id))).write(
    ProjectsCompanion(
      revision: affectsOptimization
          ? Value(project.revision + 1)
          : const Value.absent(),
      updatedAt: Value(nextDatabaseTimestamp(now, project.updatedAt)),
    ),
  );
}
