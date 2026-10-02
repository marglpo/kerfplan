import 'dart:ui';

/// A stable preference tag; null means follow the operating system.
enum AppLanguage {
  system(null),
  english('en'),
  spanish('es'),
  german('de'),
  french('fr'),
  portugueseBrazil('pt-BR'),
  italian('it'),
  polish('pl'),
  russian('ru'),
  turkish('tr'),
  ukrainian('uk');

  const AppLanguage(this.storageTag);
  final String? storageTag;

  Locale? get locale => switch (this) {
    AppLanguage.system => null,
    AppLanguage.portugueseBrazil => const Locale('pt', 'BR'),
    _ => Locale(storageTag!),
  };

  static AppLanguage fromStorage(String? value) => switch (value) {
    null => system,
    'en' => english,
    'es' => spanish,
    'de' => german,
    'fr' => french,
    'pt-BR' => portugueseBrazil,
    'it' => italian,
    'pl' => polish,
    'ru' => russian,
    'tr' => turkish,
    'uk' => ukrainian,
    _ => throw FormatException('Unknown app language', value),
  };

  /// All Portuguese system variants use the bundled Brazilian translation.
  static Locale resolveSystem(Locale? deviceLocale) =>
      switch (deviceLocale?.languageCode) {
        'es' => const Locale('es'),
        'de' => const Locale('de'),
        'fr' => const Locale('fr'),
        'pt' => const Locale('pt', 'BR'),
        'it' => const Locale('it'),
        'pl' => const Locale('pl'),
        'ru' => const Locale('ru'),
        'tr' => const Locale('tr'),
        'uk' => const Locale('uk'),
        _ => const Locale('en'),
      };
}
