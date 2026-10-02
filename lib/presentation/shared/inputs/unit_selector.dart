import 'package:flutter/material.dart';

import '../../../domain/units/display_unit.dart';
import '../../../l10n/app_localizations.dart';
import '../formatting/length_format.dart';

class UnitSelector extends StatelessWidget {
  const UnitSelector({
    super.key,
    required this.selected,
    required this.onSelected,
    this.units = DisplayUnit.values,
  });
  final DisplayUnit selected;
  final ValueChanged<DisplayUnit>? onSelected;
  final List<DisplayUnit> units;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final unit in units)
          Semantics(
            label: switch (unit) {
              DisplayUnit.mm => l10n.millimeters,
              DisplayUnit.cm => l10n.centimeters,
              DisplayUnit.m => l10n.meters,
              DisplayUnit.inch => l10n.inches,
              DisplayUnit.ftIn => l10n.feetAndInches,
            },
            child: ChoiceChip(
              materialTapTargetSize: MaterialTapTargetSize.padded,
              visualDensity: VisualDensity.standard,
              label: Text(unitLabel(l10n, unit)),
              selected: selected == unit,
              onSelected: onSelected == null ? null : (_) => onSelected!(unit),
            ),
          ),
      ],
    );
  }
}
