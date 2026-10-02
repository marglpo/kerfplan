import 'package:flutter/material.dart';

import '../../domain/units/stock_length_presets.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';

class StockPresetChips extends StatelessWidget {
  const StockPresetChips({
    super.key,
    required this.controller,
    required this.enabled,
  });

  final LengthEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.commonLengths, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final preset in StockLengthPresets.forUnit(controller.unit))
              SizedBox(
                height: 48,
                child: ActionChip(
                  key: ValueKey('stock-preset-${preset.ticks}'),
                  label: Text(displayLength(l, preset, controller.unit)),
                  onPressed: enabled
                      ? () => controller.setExactLength(preset)
                      : null,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
