import '../../domain/models/cut_project.dart';
import '../../domain/models/inventory_mode.dart';
import '../../domain/units/display_unit.dart';
import '../../domain/units/length.dart';
import '../db/app_database.dart';

CutProject mapProject(Project row) => CutProject(
  id: row.id,
  name: row.name,
  material: row.material,
  note: row.note,
  inventoryMode: InventoryMode.fromStorage(row.inventoryMode),
  displayUnit: DisplayUnit.fromStorage(row.displayUnit),
  kerf: Length.fromTicks(row.kerfTicks),
  endTrim: Length.fromTicks(row.endTrimTicks),
  minReusable: Length.fromTicks(row.minReusableTicks),
  buyStockLength: row.buyStockLengthTicks == null
      ? null
      : Length.fromTicks(row.buyStockLengthTicks!),
  revision: row.revision,
  lastRunId: row.lastRunId,
  createdAt: row.createdAt.toUtc(),
  updatedAt: row.updatedAt.toUtc(),
);
