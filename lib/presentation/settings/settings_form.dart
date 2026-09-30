import 'package:flutter/material.dart';

import '../../domain/models/app_preferences.dart';
import '../../domain/models/app_theme_mode.dart';
import '../../domain/units/display_unit.dart';
import '../../l10n/app_localizations.dart';
import '../shared/inputs/length_input.dart';
import '../shared/inputs/unit_selector.dart';
import '../shared/widgets/save_form.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({
    super.key,
    required this.initial,
    required this.onSubmit,
    this.footer,
  });
  final AppPreferences initial;
  final Future<void> Function(AppPreferences) onSubmit;
  final Widget? footer;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late DisplayUnit _unit;
  late AppThemeMode _theme;
  late final LengthEditingController _kerf;
  late final LengthEditingController _reusable;

  @override
  void initState() {
    super.initState();
    _unit = widget.initial.defaultDisplayUnit;
    _theme = widget.initial.themeMode;
    _kerf = LengthEditingController(
      unit: _unit,
      initialLength: widget.initial.defaultKerf,
      allowZero: true,
    );
    _reusable = LengthEditingController(
      unit: _unit,
      initialLength: widget.initial.defaultReusable,
      allowZero: true,
    );
  }

  @override
  void dispose() {
    _kerf.dispose();
    _reusable.dispose();
    super.dispose();
  }

  void _changeUnit(BuildContext formContext, DisplayUnit unit) {
    if (_unit == unit || !Form.of(formContext).validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _kerf.changeUnit(unit);
      _reusable.changeUnit(unit);
      _unit = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SaveForm(
      footer: widget.footer,
      submitLabel: l10n.save,
      errorMessage: l10n.settingsSaveError,
      stayOpenAfterSubmit: true,
      onSubmit: () async {
        await widget.onSubmit(
          AppPreferences(
            defaultDisplayUnit: _unit,
            defaultKerf: _kerf.length,
            defaultReusable: _reusable.length,
            themeMode: _theme,
          ),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
        }
      },
      fields: (enabled) => [
        Text(l10n.defaultsSectionTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.newProjectsDefaultsHelper),
        const SizedBox(height: 24),
        Text(l10n.defaultUnits, style: theme.textTheme.titleMedium),
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
          key: ValueKey('default-kerf-$_unit'),
          controller: _kerf,
          label: l10n.defaultKerf,
          enabled: enabled,
        ),
        const SizedBox(height: 8),
        Text(l10n.kerfHelper),
        Text(l10n.kerfFinalPartHelper),
        const SizedBox(height: 24),
        LengthInputField(
          key: ValueKey('default-reusable-$_unit'),
          controller: _reusable,
          label: l10n.defaultReusableLeftover,
          enabled: enabled,
        ),
        const SizedBox(height: 8),
        Text(l10n.defaultReusableHelper),
        const SizedBox(height: 32),
        Text(l10n.appearanceSectionTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Text(l10n.theme, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final mode in AppThemeMode.values)
              ChoiceChip(
                materialTapTargetSize: MaterialTapTargetSize.padded,
                visualDensity: VisualDensity.standard,
                selected: mode == _theme,
                label: Text(switch (mode) {
                  AppThemeMode.system => l10n.themeSystem,
                  AppThemeMode.light => l10n.themeLight,
                  AppThemeMode.dark => l10n.themeDark,
                }),
                onSelected: enabled
                    ? (_) => setState(() => _theme = mode)
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}
