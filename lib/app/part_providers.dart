import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database_provider.dart';
import '../data/repositories/drift_part_repository.dart';
import '../domain/models/part_item.dart';
import '../domain/repositories/part_repository.dart';

final partRepositoryProvider = Provider<PartRepository>(
  (ref) => DriftPartRepository(ref.watch(appDatabaseProvider)),
);

final partsProvider = StreamProvider.autoDispose.family<List<PartItem>, String>(
  (ref, projectId) => ref.watch(partRepositoryProvider).watchParts(projectId),
  retry: (count, error) => null,
);
