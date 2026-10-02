import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/domain/models/app_language.dart';

void main() {
  test('stable storage tags and explicit locale overrides', () {
    expect(AppLanguage.system.storageTag, isNull);
    expect(AppLanguage.system.locale, isNull);
    for (final language in AppLanguage.values) {
      expect(AppLanguage.fromStorage(language.storageTag), language);
      if (language != AppLanguage.system) {
        expect(language.locale!.toLanguageTag(), language.storageTag);
      }
    }
    expect(() => AppLanguage.fromStorage('ja'), throwsFormatException);
  });
  test(
    'system resolution follows supported languages and English fallback',
    () {
      for (final (device, expected) in [
        (const Locale('es', 'MX'), const Locale('es')),
        (const Locale('de', 'AT'), const Locale('de')),
        (const Locale('fr', 'CA'), const Locale('fr')),
        (const Locale('pt', 'BR'), const Locale('pt', 'BR')),
        (const Locale('pt', 'PT'), const Locale('pt', 'BR')),
        (const Locale('ru', 'RU'), const Locale('ru')),
        (const Locale('ja', 'JP'), const Locale('en')),
        (null, const Locale('en')),
      ]) {
        expect(AppLanguage.resolveSystem(device), expected);
      }
      expect(AppLanguage.english.locale, const Locale('en'));
      expect(
        AppLanguage.resolveSystem(const Locale('es', 'MX')),
        const Locale('es'),
      );
    },
  );
}
