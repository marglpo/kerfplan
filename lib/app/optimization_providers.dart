import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database_provider.dart';
import '../domain/repositories/project_repository.dart';
import 'optimization_coordinator.dart';
import 'project_providers.dart';
import 'stock_providers.dart';
import 'part_providers.dart';

final optimizationCoordinatorProvider = Provider<OptimizationCoordinator>(
  (ref) => OptimizationCoordinator(
    ref.watch(appDatabaseProvider),
    ref.watch(projectRepositoryProvider),
    ref.watch(stockRepositoryProvider),
    ref.watch(partRepositoryProvider),
  ),
);

final optimizationResultProvider = FutureProvider.autoDispose
    .family<CalculatedProject, String>((ref, id) async {
      final coordinator = ref.watch(optimizationCoordinatorProvider);
      // All child mutations also touch this project's updatedAt in the same transaction.
      // Select a value signature so changes to other projects don't trigger calculation.
      final signature = await ref.watch(
        projectProvider(id).selectAsync(
          (project) => project == null
              ? null
              : (
                  project.updatedAt,
                  project.revision,
                  project.name,
                  project.displayUnit,
                  project.inventoryMode,
                  project.kerf,
                  project.endTrim,
                  project.minReusable,
                  project.buyStockLength,
                ),
        ),
      );
      if (signature == null) throw ProjectNotFoundException(id);
      return coordinator.calculate(id);
    }, retry: (count, error) => null);
