import 'package:kerfplan/domain/models/cut_project.dart';
import 'package:kerfplan/domain/optimizer/cut_optimizer.dart';
import 'package:kerfplan/domain/optimizer/optimization_input.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/l10n/app_localizations_en.dart';
import 'package:kerfplan/services/export/cut_report_builder.dart';
import 'package:kerfplan/services/export/cut_report_data.dart';

final reportDate = DateTime(2026, 9, 26, 10, 30);

CutReportData reportFor(
  OptimizationInput input, {
  DisplayUnit unit = DisplayUnit.mm,
  String name = 'Garage Frame',
  String? material,
  String? note,
}) => CutReportBuilder.build(
  project: CutProject(
    id: 'private-project-id',
    name: name,
    material: material,
    note: note,
    inventoryMode: input.mode,
    displayUnit: unit,
    kerf: input.kerf,
    endTrim: input.endTrim,
    minReusable: input.minReusable,
    buyStockLength: input.buyStockLength,
    revision: 3,
    lastRunId: null,
    createdAt: reportDate,
    updatedAt: reportDate,
  ),
  result: const FfdCutOptimizer().optimize(input),
  generatedAt: reportDate,
  labels: AppLocalizationsEn(),
);
