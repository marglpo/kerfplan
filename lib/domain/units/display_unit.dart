enum DisplayUnit {
  mm('mm'),
  cm('cm'),
  m('m'),
  inch('inch'),
  ftIn('ftIn');

  const DisplayUnit(this.storageValue);
  final String storageValue;

  static DisplayUnit fromStorage(String value) => switch (value) {
    'mm' => mm,
    'cm' => cm,
    'm' => m,
    'inch' => inch,
    'ftIn' => ftIn,
    _ => throw FormatException('Unknown display unit', value),
  };
}
