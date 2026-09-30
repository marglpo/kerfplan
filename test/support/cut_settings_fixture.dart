import 'package:kerfplan/domain/models/cut_settings_input.dart';
import 'package:kerfplan/domain/units/display_unit.dart';
import 'package:kerfplan/domain/units/length.dart';

CutSettingsInput settings({
  DisplayUnit unit = DisplayUnit.mm,
  int kerf = 30000,
  int trim = 0,
  int reusable = 1000000,
}) => CutSettingsInput(
  displayUnit: unit,
  kerf: Length.fromTicks(kerf),
  endTrim: Length.fromTicks(trim),
  minReusable: Length.fromTicks(reusable),
);
