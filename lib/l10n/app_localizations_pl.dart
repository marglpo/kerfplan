// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Ustawienia';

  @override
  String get newCutList => 'Nowa lista cięć';

  @override
  String get noProjectsTitle => 'Brak list cięć';

  @override
  String get noProjectsMessage =>
      'Zaplanuj pierwsze zlecenie w mniej niż minutę.';

  @override
  String get appVersionLabel => 'Wersja aplikacji';

  @override
  String get defaultUnits => 'Domyślne jednostki';

  @override
  String get defaultKerf => 'Domyślny rzaz';

  @override
  String get theme => 'Motyw';

  @override
  String get newProjectTitle => 'Nowa lista cięć';

  @override
  String get projectNameLabel => 'Nazwa projektu';

  @override
  String get projectNameHint => 'Rama garażu';

  @override
  String get materialLabel => 'Materiał';

  @override
  String get materialHint => 'Stal 40x20';

  @override
  String get noteLabel => 'Notatka';

  @override
  String get noteHint => 'Ściana południowa';

  @override
  String get createCutList => 'Utwórz listę cięć';

  @override
  String get save => 'Zapisz';

  @override
  String get editDetails => 'Edytuj szczegóły';

  @override
  String get duplicate => 'Duplikuj';

  @override
  String get copyLabel => 'Kopia';

  @override
  String get delete => 'Usuń';

  @override
  String get deleteProjectTitle => 'Usunąć listę cięć?';

  @override
  String deleteProjectMessage(String projectName) {
    return '„$projectName” zostanie trwale usunięta z tego urządzenia.';
  }

  @override
  String get cancel => 'Anuluj';

  @override
  String get projectDeleted => 'Lista cięć usunięta';

  @override
  String projectActions(String projectName) {
    return 'Działania dla $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Zaktualizowano: $date';
  }

  @override
  String get stockSectionTitle => 'Materiał dostępny';

  @override
  String get noStockYet => 'Nie dodano jeszcze długości materiału.';

  @override
  String get partsSectionTitle => 'Elementy';

  @override
  String get noPartsYet => 'Nie dodano jeszcze elementów.';

  @override
  String get cutSettingsSectionTitle => 'Ustawienia cięcia';

  @override
  String get calculate => 'Oblicz';

  @override
  String get calculateDisabledHint =>
      'Dodaj elementy, aby obliczyć plan cięcia.';

  @override
  String get projectNotFound => 'Nie znaleziono listy cięć';

  @override
  String get backToProjects => 'Wróć do list';

  @override
  String get projectNameRequired => 'Wpisz nazwę projektu.';

  @override
  String get projectNameTooLong =>
      'Nazwa projektu może mieć maksymalnie 80 znaków.';

  @override
  String get materialTooLong => 'Materiał może mieć maksymalnie 120 znaków.';

  @override
  String get noteTooLong => 'Notatka może mieć maksymalnie 500 znaków.';

  @override
  String get projectSaveError =>
      'Nie udało się zapisać listy cięć. Spróbuj ponownie.';

  @override
  String get projectDeleteError =>
      'Nie udało się usunąć listy cięć. Spróbuj ponownie.';

  @override
  String get projectDuplicateError =>
      'Nie udało się zduplikować listy cięć. Spróbuj ponownie.';

  @override
  String get projectsLoadError => 'Nie udało się wczytać list cięć.';

  @override
  String get projectLoadError => 'Nie udało się wczytać tej listy cięć.';

  @override
  String get retry => 'Spróbuj ponownie';

  @override
  String get fixedInventory => 'Stały zapas';

  @override
  String get buyStock => 'Kup materiał';

  @override
  String get addStockLength => 'Dodaj długość materiału';

  @override
  String get editStockLength => 'Edytuj długość materiału';

  @override
  String get stockLength => 'Długość';

  @override
  String get quantity => 'Ilość';

  @override
  String get labelOptional => 'Etykieta (opcjonalnie)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Magazyn';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Wpisz długość.';

  @override
  String get stockLengthInvalid => 'Wpisz liczbę większą od zera.';

  @override
  String get stockLengthPrecision =>
      'Tej wartości nie da się zapisać dokładnie. Użyj wielokrotności 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Ta długość jest zbyt duża.';

  @override
  String get quantityRequired => 'Wpisz ilość.';

  @override
  String get quantityInvalid => 'Wpisz liczbę całkowitą od 1 do 9999.';

  @override
  String get quantityTooLarge => 'Ilość nie może przekraczać 9999.';

  @override
  String get stockLabelTooLong => 'Etykieta może mieć maksymalnie 80 znaków.';

  @override
  String get saveStock => 'Zapisz długość materiału';

  @override
  String get stockSaveError =>
      'Nie udało się zapisać tej długości materiału. Spróbuj ponownie.';

  @override
  String get stockDeleteError =>
      'Nie udało się usunąć tej długości materiału. Spróbuj ponownie.';

  @override
  String get stockDuplicateError =>
      'Nie udało się zduplikować tej długości materiału. Spróbuj ponownie.';

  @override
  String get stockLoadError => 'Nie udało się wczytać materiału.';

  @override
  String get stockNotFound => 'Nie znaleziono długości materiału';

  @override
  String get deleteStockTitle => 'Usunąć długość materiału?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity zostanie usunięte z tej listy cięć.';
  }

  @override
  String get stockDeleted => 'Długość materiału usunięta';

  @override
  String get duplicateStock => 'Duplikuj długość materiału';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count długości materiału',
      many: '$count długości materiału',
      few: '$count długości materiału',
      one: '$count długość materiału',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Łącznie $count sztuki',
      many: 'Łącznie $count sztuk',
      few: 'Łącznie $count sztuki',
      one: 'Łącznie $count sztuka',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Ustaw długość materiału';

  @override
  String get buyStockHelper => 'Obliczymy, ile sztuk trzeba kupić.';

  @override
  String get buyStockLengthMissing =>
      'Ustaw długość materiału, który zamierzasz kupić.';

  @override
  String get stockModeSaveError =>
      'Nie udało się zmienić trybu materiału. Spróbuj ponownie.';

  @override
  String get backToProject => 'Wróć do listy cięć';

  @override
  String get decreaseQuantity => 'Zmniejsz ilość';

  @override
  String get increaseQuantity => 'Zwiększ ilość';

  @override
  String get unitMm => 'mm';

  @override
  String get unitCm => 'cm';

  @override
  String get unitM => 'm';

  @override
  String get unitInch => 'in';

  @override
  String lengthWithUnit(String value, String unit) {
    return '$value $unit';
  }

  @override
  String approximateLength(String value) {
    return '≈ $value';
  }

  @override
  String stockQuantity(int quantity) {
    return '× $quantity';
  }

  @override
  String stockActions(String length) {
    return 'Działania dla $length';
  }

  @override
  String get decimalInchesHelper => 'Wpisz cale jako liczbę dziesiętną.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Zapisano dokładnie: $value mm. Wartość w calach jest przybliżona. Zapisana długość pozostaje dokładna, dopóki jej nie edytujesz.';
  }

  @override
  String get addPart => 'Dodaj element';

  @override
  String get editPart => 'Edytuj element';

  @override
  String get partNameOptional => 'Nazwa elementu (opcjonalnie)';

  @override
  String get partNameHint => 'Słupek';

  @override
  String get partNameTooLong =>
      'Nazwa elementu może mieć maksymalnie 100 znaków.';

  @override
  String get partSaveError =>
      'Nie udało się zapisać elementu. Spróbuj ponownie.';

  @override
  String get partDeleteError =>
      'Nie udało się usunąć elementu. Spróbuj ponownie.';

  @override
  String get partDuplicateError =>
      'Nie udało się zduplikować elementu. Spróbuj ponownie.';

  @override
  String get partLoadError => 'Nie udało się wczytać elementów.';

  @override
  String get partNotFound => 'Nie znaleziono elementu';

  @override
  String get deletePartTitle => 'Usunąć element?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity zostanie usunięte z tej listy cięć.';
  }

  @override
  String get partDeleted => 'Element usunięty';

  @override
  String get duplicatePart => 'Duplikuj element';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pozycji elementów',
      many: '$count pozycji elementów',
      few: '$count pozycje elementów',
      one: '$count pozycja elementów',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Stopy';

  @override
  String get inches => 'Cale';

  @override
  String get wholeInches => 'Pełne cale';

  @override
  String get fraction => 'Ułamek';

  @override
  String get inchesRange =>
      'Użyj od 0 do 11 cali. Dodatkowe stopy wpisz w polu Stopy.';

  @override
  String get imperialLengthInvalid =>
      'Wpisz nieujemne liczby całkowite i ułamek, których suma jest większa od zera.';

  @override
  String partTooLongWarning(String length) {
    return 'Ten element jest dłuższy niż największa użyteczna długość materiału ($length).';
  }

  @override
  String get addStockToContinue => 'Dodaj materiał, aby kontynuować.';

  @override
  String get cutPlanUnavailable => 'Plan cięcia nie jest jeszcze dostępny.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Plan cięcia';

  @override
  String get calculating => 'Obliczanie…';

  @override
  String get recalculate => 'Oblicz ponownie';

  @override
  String get editCutList => 'Edytuj listę cięć';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Użyto $count sztuki materiału',
      many: 'Użyto $count sztuk materiału',
      few: 'Użyto $count sztuk materiału',
      one: 'Użyto $count sztuki materiału',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Do kupienia $count sztuki materiału',
      many: 'Do kupienia $count sztuk materiału',
      few: 'Do kupienia $count sztuki materiału',
      one: 'Do kupienia $count sztuka materiału',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Kup $length × $count';
  }

  @override
  String get requestedParts => 'Wymagane elementy';

  @override
  String get placedParts => 'Przydzielone elementy';

  @override
  String get unplacedParts => 'Nieprzydzielone elementy';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested elementu',
      many: '$requested elementów',
      few: '$requested elementów',
      one: '$requested elementu',
    );
    return 'Przydzielono $placed z $_temp0';
  }

  @override
  String get totalFinishedLength => 'Łączna długość gotowych elementów';

  @override
  String get totalStockUsed => 'Łączna długość użytego materiału';

  @override
  String get totalWaste => 'Łączny odpad';

  @override
  String wastePercentage(String value) {
    return 'Odpad: $value%';
  }

  @override
  String get reusableLeftovers => 'Pozostałości do ponownego użycia';

  @override
  String get scrap => 'Odpad';

  @override
  String get kerfLoss => 'Strata na rzaz';

  @override
  String get trimLoss => 'Strata na obcięcie końców';

  @override
  String get reusable => 'Do ponownego użycia';

  @override
  String get leftover => 'Pozostałość';

  @override
  String reusableExplanation(String threshold) {
    return 'Do ponownego użycia: końcówki co najmniej $threshold. Odpad obejmuje rzaz, obcięte końce i krótsze pozostałości.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Pręt $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementu',
      many: '$count elementów',
      few: '$count elementy',
      one: '$count element',
    );
    return '$_temp0';
  }

  @override
  String classifiedLeftover(String length, String classification) {
    return '$length · $classification';
  }

  @override
  String cutOrderPart(int number, String description) {
    return '$number. $description';
  }

  @override
  String endTrimPerEnd(String length) {
    return 'Obcięcie końców: $length na każdy koniec';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Pręt materiału $number, $length, $parts, pozostałość $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Nieprzydzielone elementy ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Nie ma dość materiału na ten element.';

  @override
  String get resultLoadError => 'Nie udało się obliczyć tej listy cięć.';

  @override
  String get resultValidationError =>
      'Przed obliczeniem sprawdź materiał, elementy i ustawienia cięcia.';

  @override
  String get stockTooShortAfterTrim =>
      'Materiał jest zbyt krótki po obcięciu końców.';

  @override
  String get validBuyStockRequired =>
      'Przed obliczeniem ustaw poprawną długość materiału.';

  @override
  String get tooLongResultReason =>
      'Ten element jest dłuższy niż największa użyteczna długość materiału.';

  @override
  String get editCutSettings => 'Edytuj ustawienia cięcia';

  @override
  String get units => 'Jednostki';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Milimetry';

  @override
  String get centimeters => 'Centymetry';

  @override
  String get meters => 'Metry';

  @override
  String get feetAndInches => 'Stopy i cale';

  @override
  String get kerf => 'Rzaz';

  @override
  String get kerfHelper => 'Materiał usuwany między kolejnymi elementami.';

  @override
  String get kerfFinalPartHelper =>
      'Po ostatnim elemencie na pręcie nie dolicza się rzazu.';

  @override
  String get endTrimEachEnd => 'Obcięcie końców (na każdy koniec)';

  @override
  String get endTrimHelper =>
      'Odetnij tę długość z każdego końca każdego pręta.';

  @override
  String get reusableLeftover => 'Pozostałość do ponownego użycia';

  @override
  String get reusableLeftoverHelper =>
      'Pozostałości o tej długości lub dłuższe można wykorzystać ponownie.';

  @override
  String get cutSettingsSaveError =>
      'Nie udało się zapisać ustawień cięcia. Spróbuj ponownie.';

  @override
  String get noUsableStockAfterTrim =>
      'Po obcięciu końców nie zostaje użyteczna długość materiału.';

  @override
  String get someStockUnusableAfterTrim =>
      'Niektóre pręty są zbyt krótkie po obcięciu końców.';

  @override
  String get nonnegativeLengthInvalid => 'Wpisz liczbę większą lub równą zeru.';

  @override
  String get nonnegativeImperialInvalid =>
      'Wpisz nieujemne liczby całkowite i ułamek.';

  @override
  String get share => 'Udostępnij';

  @override
  String get shareCutPlan => 'Udostępnij plan cięcia';

  @override
  String get shareText => 'Udostępnij tekst';

  @override
  String get sharePdf => 'Udostępnij PDF';

  @override
  String get copyBuyList => 'Kopiuj listę zakupów';

  @override
  String get buyListCopied => 'Lista zakupów skopiowana';

  @override
  String get creatingPdf => 'Tworzenie PDF…';

  @override
  String get pdfCreateError =>
      'Nie udało się utworzyć pliku PDF. Spróbuj ponownie.';

  @override
  String get shareError =>
      'Nie udało się udostępnić planu cięcia. Spróbuj ponownie.';

  @override
  String get buyListCopyError =>
      'Nie udało się skopiować listy zakupów. Spróbuj ponownie.';

  @override
  String get reportSummary => 'Podsumowanie';

  @override
  String get reportPurchase => 'Zakup';

  @override
  String get generatedLabel => 'Wygenerowano';

  @override
  String generatedBy(String appName) {
    return 'Wygenerowano w $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Plany cięcia służą do planowania. Przed cięciem sprawdź każdy wymiar na materiale i przestrzegaj zasad bezpiecznej pracy z narzędziami.';

  @override
  String get reportFileFallback => 'Plan cięcia';

  @override
  String get addLeftoversToStock => 'Dodaj pozostałości do zapasu';

  @override
  String get addLeftoversTitle => 'Dodać pozostałości do zapasu?';

  @override
  String get addLeftoversMessage =>
      'Te pozostałości nadające się do ponownego użycia zostaną dodane do stałego zapasu projektu na przyszłe plany cięcia.';

  @override
  String get addLeftoversFutureHint => 'Dodaj je po wykonaniu cięć.';

  @override
  String get addToStock => 'Dodaj do zapasu';

  @override
  String get leftoversAddedToStock =>
      'Pozostałości dodano do zapasu na przyszłe plany cięcia.';

  @override
  String get leftoversAddError =>
      'Nie udało się dodać pozostałości. Spróbuj ponownie.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sztuki do ponownego użycia',
      many: '$count sztuk do ponownego użycia',
      few: '$count sztuki do ponownego użycia',
      one: '$count sztuka do ponownego użycia',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Zapisz i dodaj kolejny';

  @override
  String get defaultsSectionTitle => 'Wartości domyślne';

  @override
  String get appearanceSectionTitle => 'Wygląd';

  @override
  String get defaultReusableLeftover =>
      'Domyślna pozostałość do ponownego użycia';

  @override
  String get newProjectsDefaultsHelper =>
      'Te wartości dotyczą nowych list cięć. Istniejące listy nie zostaną zmienione.';

  @override
  String get defaultReusableHelper =>
      'W nowych projektach pozostałości o tej długości lub dłuższe nadają się do ponownego użycia.';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get settingsSaveError =>
      'Nie udało się zapisać ustawień. Spróbuj ponownie.';

  @override
  String get settingsLoadError => 'Nie udało się wczytać ustawień.';

  @override
  String get settingsSaved => 'Ustawienia zapisane';

  @override
  String get language => 'Język';

  @override
  String get languageSystem => 'Język systemowy';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageFrench => 'Français';

  @override
  String get languagePortugueseBrazil => 'Português (Brasil)';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageUkrainian => 'Українська';

  @override
  String get proTitle => 'KerfPlan Pro';

  @override
  String get upgradeOnce => 'Kup raz. Korzystaj bezterminowo.';

  @override
  String get noSubscription => 'Bez abonamentu.';

  @override
  String get lifetimePro => 'Pro na zawsze';

  @override
  String get removeAds => 'Usuń reklamy';

  @override
  String unlockLifetimePro(String price) {
    return 'Odblokuj Pro na zawsze — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Usuń reklamy — $price';
  }

  @override
  String get proActive => 'Pro na zawsze aktywne';

  @override
  String get adFreeActive => 'Bez reklam';

  @override
  String get includedWithPro => 'Wliczone w Pro na zawsze';

  @override
  String get removeAdsDescription => 'Zachowaj darmowe funkcje i usuń reklamy.';

  @override
  String get restorePurchases => 'Przywróć zakupy';

  @override
  String get restoringPurchases => 'Przywracanie zakupów…';

  @override
  String get purchasesRestored => 'Zakupy przywrócone';

  @override
  String get lifetimeProRestored => 'Pro na zawsze przywrócone';

  @override
  String get adFreeRestored => 'Wersja bez reklam przywrócona';

  @override
  String get nothingToRestore => 'Brak zakupów do przywrócenia';

  @override
  String get purchasePending => 'Zakup oczekuje';

  @override
  String get purchasePendingMessage =>
      'Google Play jeszcze przetwarza płatność za ten zakup.';

  @override
  String get purchaseError =>
      'Nie udało się sfinalizować zakupu. Spróbuj ponownie.';

  @override
  String get restoreError =>
      'Nie udało się przywrócić zakupów. Spróbuj ponownie.';

  @override
  String get billingUnavailable => 'Zakupy są teraz niedostępne.';

  @override
  String get productUnavailable => 'Chwilowo niedostępne.';

  @override
  String get processingPurchase => 'Weryfikowanie zakupu…';

  @override
  String get purchaseVerified => 'Zakup zweryfikowany';

  @override
  String get kerfPlanFree => 'KerfPlan Bezpłatny';

  @override
  String get viewPro => 'Zobacz Pro';

  @override
  String get upgrade => 'Ulepsz';

  @override
  String get benefitUnlimitedProjects => 'Nieograniczone listy cięć';

  @override
  String get benefitMultipleStocks => 'Wiele długości materiału';

  @override
  String get benefitPdf => 'Eksport PDF do warsztatu';

  @override
  String get benefitReuseLeftovers => 'Ponowne użycie pozostałości';

  @override
  String get benefitNoAds => 'Bez reklam';

  @override
  String get onboardingIntro =>
      'Planuj cięcia liniowe z mniejszą ilością odpadów.';

  @override
  String get howDoYouMeasure => 'Jak mierzysz?';

  @override
  String get metric => 'Metryczny';

  @override
  String get imperial => 'Imperialny';

  @override
  String get metricDescription => 'Milimetry, centymetry i metry';

  @override
  String get imperialDescription => 'Cale i stopy';

  @override
  String get recommendedForRegion => 'Zalecane dla Twojego regionu';

  @override
  String get continueAction => 'Kontynuuj';

  @override
  String get measurementCanChangeLater =>
      'Możesz to później zmienić w Ustawieniach.';

  @override
  String get measurements => 'Pomiary';

  @override
  String get measurementSystem => 'System miar';

  @override
  String get commonLengths => 'Typowe długości';
}
