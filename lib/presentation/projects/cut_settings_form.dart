import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/stock_providers.dart';
import '../../domain/models/cut_project.dart';
import '../../domain/models/cut_settings_input.dart';
import '../../domain/models/inventory_mode.dart';
import '../../domain/models/stock_trim_warning.dart';
import '../../domain/units/decimal_length.dart';
import '../../domain/units/display_unit.dart';
import '../../domain/units/length.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import '../shared/inputs/unit_selector.dart';
import '../shared/widgets/save_form.dart';

class CutSettingsForm extends ConsumerStatefulWidget {
  const CutSettingsForm({
    super.key,
    required this.project,
    required this.onSubmit,
  });
  final CutProject project;
  final Future<void> Function(CutSettingsInput) onSubmit;

  @override
  ConsumerState<CutSettingsForm> createState() => _CutSettingsFormState();
}

class _CutSettingsFormState extends ConsumerState<CutSettingsForm> {
  late DisplayUnit _unit;
  late final LengthEditingController _kerf;
  late final LengthEditingController _trim;
  late final LengthEditingController _reusable;

  @override
  void initState() {
    super.initState();
    _unit = widget.project.displayUnit;
    LengthEditingController controller(Length length) =>
        LengthEditingController(
          unit: _unit,
          initialLength: length,
          allowZero: true,
        );
    _kerf = controller(widget.project.kerf);
    _trim = controller(widget.project.endTrim)..addListener(_trimChanged);
    _reusable = controller(widget.project.minReusable);
  }

  void _trimChanged() => setState(() {});

  @override
  void dispose() {
    _kerf.dispose();
    _trim.removeListener(_trimChanged);
    _trim.dispose();
    _reusable.dispose();
    super.dispose();
  }

  void _changeUnit(BuildContext formContext, DisplayUnit unit) {
    if (unit == _unit || !Form.of(formContext).validate()) return;
    FocusScope.of(context).unfocus();
    // All editors were validated before rebasing any of them. Each controller
    // retains its exact current Length, including untouched imperial values.
    setState(() {
      _kerf.changeUnit(unit);
      _trim.changeUnit(unit);
      _reusable.changeUnit(unit);
      _unit = unit;
    });
  }

  Widget _trimWarning(AppLocalizations l10n) {
    Length trim;
    try {
      trim = _trim.length;
    } on LengthInputException {
      return const SizedBox.shrink();
    }
    Widget warning(Iterable<Length> lengths) {
      final kind = stockTrimWarning(lengths, trim);
      if (kind == StockTrimWarning.none) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Semantics(
          liveRegion: true,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.warning_amber_outlined),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  kind == StockTrimWarning.allUnusable
                      ? l10n.noUsableStockAfterTrim
                      : l10n.someStockUnusableAfterTrim,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.project.inventoryMode == InventoryMode.buy) {
      return warning([?widget.project.buyStockLength]);
    }
    return ref
        .watch(stockLinesProvider(widget.project.id))
        .when(
          data: (stock) => warning(stock.map((item) => item.length)),
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => Column(
            children: [
              Text(l10n.stockLoadError),
              TextButton(
                onPressed: () =>
                    ref.invalidate(stockLinesProvider(widget.project.id)),
                child: Text(l10n.retry),
              ),
            ],
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SaveForm(
      submitLabel: l10n.save,
      errorMessage: l10n.cutSettingsSaveError,
      onSubmit: () => widget.onSubmit(
        CutSettingsInput(
          displayUnit: _unit,
          kerf: _kerf.length,
          endTrim: _trim.length,
          minReusable: _reusable.length,
        ),
      ),
      fields: (enabled) => [
        Text(l10n.units, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Builder(
          builder: (formContext) => UnitSelector(
            selected: _unit,
            onSelected: enabled
                ? (unit) => _changeUnit(formContext, unit)
                : null,
          ),
        ),
        const SizedBox(height: 24),
        LengthInputField(
          key: ValueKey('kerf-$_unit'),
          controller: _kerf,
          label: l10n.kerf,
          enabled: enabled,
        ),
        const SizedBox(height: 8),
        Text(l10n.kerfHelper),
        Text(l10n.kerfFinalPartHelper),
        const SizedBox(height: 24),
        LengthInputField(
          key: ValueKey('trim-$_unit'),
          controller: _trim,
          label: l10n.endTrimEachEnd,
          enabled: enabled,
        ),
        const SizedBox(height: 8),
        Text(l10n.endTrimHelper),
        _trimWarning(l10n),
        const SizedBox(height: 24),
        LengthInputField(
          key: ValueKey('reusable-$_unit'),
          controller: _reusable,
          label: l10n.reusableLeftover,
          enabled: enabled,
        ),
        const SizedBox(height: 8),
        Text(l10n.reusableLeftoverHelper),
      ],
    );
  }
}
