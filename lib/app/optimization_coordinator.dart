import '../data/db/app_database.dart';
import '../domain/models/cut_project.dart';
import '../domain/models/inventory_mode.dart';
import '../domain/models/part_item.dart';
import '../domain/models/stock_item.dart';
import '../domain/optimizer/cut_optimizer.dart';
import '../domain/optimizer/optimization_input.dart';
import '../domain/optimizer/optimization_result.dart';
import '../domain/repositories/part_repository.dart';
import '../domain/repositories/project_repository.dart';
import '../domain/repositories/stock_repository.dart';

enum CalculationRequirement { stock, buyLength, parts }

CalculationRequirement? calculationRequirement(
  CutProject project,
  List<StockItem> stock,
  List<PartItem> parts,
) {
  if (project.inventoryMode == InventoryMode.fixed && stock.isEmpty) {
    return CalculationRequirement.stock;
  }
  if (project.inventoryMode == InventoryMode.buy &&
      (project.buyStockLength == null || project.buyStockLength!.ticks <= 0)) {
    return CalculationRequirement.buyLength;
  }
  return parts.isEmpty ? CalculationRequirement.parts : null;
}

final class MissingCalculationInput implements Exception {
  const MissingCalculationInput(this.requirement);
  final CalculationRequirement requirement;
}

final class CalculatedProject {
  const CalculatedProject(this.project, this.result);
  final CutProject project;
  final OptimizationResult result;
}

/// Reads a consistent persisted snapshot, then calls the unchanged domain core.
/// No result writes and no dependency from the optimizer back into this layer.
final class OptimizationCoordinator {
  const OptimizationCoordinator(
    this.database,
    this.projects,
    this.stock,
    this.parts,
  );
  final AppDatabase database;
  final ProjectRepository projects;
  final StockRepository stock;
  final PartRepository parts;

  Future<CalculatedProject> calculate(String projectId) async {
    final snapshot = await database.transaction(() async {
      final project = await projects.getProject(projectId);
      if (project == null) throw ProjectNotFoundException(projectId);
      final stockRows = await stock.getStockLines(projectId);
      final partRows = await parts.getPartLines(projectId);
      final missing = calculationRequirement(project, stockRows, partRows);
      if (missing != null) throw MissingCalculationInput(missing);
      return (
        project,
        OptimizationInput(
          mode: project.inventoryMode,
          fixedStock: [
            for (final row in stockRows)
              OptimizationStock(
                sourceStockId: row.id,
                length: row.length,
                quantity: row.quantity,
                stableOrder: row.sortOrder,
              ),
          ],
          buyStockLength: project.buyStockLength,
          parts: [
            for (final row in partRows)
              OptimizationPartGroup(
                sourcePartId: row.id,
                name: row.name,
                length: row.length,
                quantity: row.quantity,
                stableOrder: row.sortOrder,
              ),
          ],
          kerf: project.kerf,
          endTrim: project.endTrim,
          minReusable: project.minReusable,
        ),
      );
    });
    return CalculatedProject(
      snapshot.$1,
      const FfdCutOptimizer().optimize(snapshot.$2),
    );
  }
}
