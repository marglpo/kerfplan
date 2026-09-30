enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemeMode(this.storageValue);
  final String storageValue;

  static AppThemeMode fromStorage(String value) => switch (value) {
    'system' => system,
    'light' => light,
    'dark' => dark,
    _ => throw FormatException('Unknown app theme mode', value),
  };
}
