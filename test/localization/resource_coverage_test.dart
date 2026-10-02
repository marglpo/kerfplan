import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kerfplan/l10n/app_localizations.dart';

void main() {
  final files = {
    'es': 'app_es.arb',
    'de': 'app_de.arb',
    'fr': 'app_fr.arb',
    'pt': 'app_pt.arb',
    'pt_BR': 'app_pt_BR.arb',
    'it': 'app_it.arb',
    'pl': 'app_pl.arb',
    'ru': 'app_ru.arb',
    'tr': 'app_tr.arb',
    'uk': 'app_uk.arb',
  };
  final english = jsonDecode(
    File('lib/l10n/app_en.arb').readAsStringSync(),
  ) as Map<String, dynamic>;
  final messages = english.keys.where((key) => !key.startsWith('@')).toSet();
  final arguments = RegExp(r'\{([a-zA-Z][a-zA-Z0-9_]*)(?=[,}])');
  final complexArguments = RegExp(
    r'\{([a-zA-Z][a-zA-Z0-9_]*),\s*(plural|select|selectordinal),',
  );

  for (final entry in files.entries) {
    test(
      '${entry.key} ARB has every English message and matching ICU arguments',
      () {
        final resource = jsonDecode(
          File('lib/l10n/${entry.value}').readAsStringSync(),
        ) as Map<String, dynamic>;
        expect(resource['@@locale'], entry.key);
        expect(
          resource.keys.where((key) => !key.startsWith('@')).toSet(),
          messages,
        );
        for (final key in messages) {
          final original = english[key] as String;
          final translated = resource[key] as String;
          expect(translated.trim(), isNotEmpty, reason: '${entry.key}: $key');
          expect(
            arguments.allMatches(translated).map((match) => match[1]).toSet(),
            arguments.allMatches(original).map((match) => match[1]).toSet(),
            reason: '${entry.key}: $key',
          );
          expect(
            complexArguments
                .allMatches(translated)
                .map((match) => '${match[1]}:${match[2]}')
                .toSet(),
            complexArguments
                .allMatches(original)
                .map((match) => '${match[1]}:${match[2]}')
                .toSet(),
            reason: '${entry.key}: $key',
          );
          if (english.containsKey('@$key')) {
            expect(
              resource['@$key'],
              english['@$key'],
              reason: '${entry.key}: $key metadata',
            );
          }
        }
      },
    );
  }

  test('generated localizations resolve every supported choice', () {
    final locales = [
      const Locale('en'),
      const Locale('es'),
      const Locale('de'),
      const Locale('fr'),
      const Locale('pt', 'BR'),
      const Locale('it'),
      const Locale('pl'),
      const Locale('ru'),
      const Locale('tr'),
      const Locale('uk'),
    ];
    expect(locales, hasLength(10));
    for (final locale in locales) {
      final strings = lookupAppLocalizations(locale);
      expect(strings.appName, 'KerfPlan');
      expect(strings.settingsTitle, isNotEmpty);
      expect(strings.unitMm, 'mm');
      const storePrice = '¥1,234 / €4,20';
      expect(strings.unlockLifetimePro(storePrice), contains(storePrice));
      expect(strings.removeAdsCta(storePrice), contains(storePrice));
      expect(strings.billingUnavailable, isNotEmpty);
    }
    expect(
      lookupAppLocalizations(const Locale('pl')).partsOnBar(1),
      contains('1'),
    );
    expect(
      lookupAppLocalizations(const Locale('pl')).partsOnBar(2),
      contains('2'),
    );
    expect(
      lookupAppLocalizations(const Locale('pl')).partsOnBar(5),
      contains('5'),
    );
  });
}
