import 'package:flutter/material.dart';

import '../../domain/models/app_preferences.dart';
import '../../domain/models/app_language.dart';
import '../../domain/models/app_theme_mode.dart';
import '../../domain/models/measurement_system.dart';
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
    required this.onLanguageSelected,
    this.footer,
  });
  final AppPreferences initial;
  final Future<void> Function(AppPreferences) onSubmit;
  final Future<void> Function(AppLanguage) onLanguageSelected;
  final Widget? footer;

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  late DisplayUnit _unit;
  late MeasurementSystem _system;
  late AppThemeMode _theme;
  late AppLanguage _language;
  bool _savingLanguage = false;
  late final LengthEditingController _kerf;
  late final LengthEditingController _reusable;

  @override
  void initState() {
    super.initState();
    _unit = widget.initial.defaultDisplayUnit;
    _system = widget.initial.measurementSystem;
    _theme = widget.initial.themeMode;
    _language = widget.initial.language;
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

  void _changeSystem(BuildContext formContext, MeasurementSystem system) {
    if (_system == system || !Form.of(formContext).validate()) return;
    FocusScope.of(context).unfocus();
    setState(() {
      if (!system.contains(_unit)) {
        final unit = system.defaultUnit;
        _kerf.changeUnit(unit);
        _reusable.changeUnit(unit);
        _unit = unit;
      }
      _system = system;
    });
  }

  String _languageName(AppLocalizations l, AppLanguage language) =>
      switch (language) {
        AppLanguage.system => l.languageSystem,
        AppLanguage.english => l.languageEnglish,
        AppLanguage.spanish => l.languageSpanish,
        AppLanguage.german => l.languageGerman,
        AppLanguage.french => l.languageFrench,
        AppLanguage.portugueseBrazil => l.languagePortugueseBrazil,
        AppLanguage.italian => l.languageItalian,
        AppLanguage.polish => l.languagePolish,
        AppLanguage.russian => l.languageRussian,
        AppLanguage.turkish => l.languageTurkish,
        AppLanguage.ukrainian => l.languageUkrainian,
      };

  Future<void> _selectLanguage() async {
    if (_savingLanguage) return;
    final selected = await showModalBottomSheet<AppLanguage>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                AppLocalizations.of(sheetContext).language,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
            ),
            for (final language in AppLanguage.values)
              ListTile(
                minVerticalPadding: 12,
                title: Text(
                  _languageName(AppLocalizations.of(sheetContext), language),
                ),
                leading: Icon(
                  language == _language
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                ),
                onTap: () => Navigator.pop(sheetContext, language),
              ),
          ],
        ),
      ),
    );
    if (selected == null || selected == _language || !mounted) {
      return;
    }
    setState(() => _savingLanguage = true);
    try {
      await widget.onLanguageSelected(selected);
      if (mounted) setState(() => _language = selected);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).settingsSaveError),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _savingLanguage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SaveForm(
      submitEnabled: !_savingLanguage,
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
            language: _language,
            measurementSystem: _system,
            onboardingCompleted: widget.initial.onboardingCompleted,
          ),
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
        }
      },
      fields: (enabled) => [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.language),
          subtitle: Text(_languageName(l10n, _language)),
          trailing: const Icon(Icons.chevron_right),
          onTap: enabled && !_savingLanguage ? _selectLanguage : null,
        ),
        const SizedBox(height: 24),
        Text(l10n.measurements, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.measurementSystem, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Builder(
          builder: (formContext) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final system in MeasurementSystem.values)
                ChoiceChip(
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  selected: system == _system,
                  label: Text(
                    system == MeasurementSystem.metric
                        ? l10n.metric
                        : l10n.imperial,
                  ),
                  onSelected: enabled
                      ? (_) => _changeSystem(formContext, system)
                      : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(l10n.defaultsSectionTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.newProjectsDefaultsHelper),
        const SizedBox(height: 24),
        Text(l10n.defaultUnits, style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        Builder(
          builder: (formContext) => UnitSelector(
            selected: _unit,
            units: DisplayUnit.values.where(_system.contains).toList(),
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
