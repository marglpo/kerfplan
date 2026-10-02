// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get newCutList => 'Neue Schnittliste';

  @override
  String get noProjectsTitle => 'Noch keine Schnittlisten';

  @override
  String get noProjectsMessage =>
      'Plane deinen ersten Auftrag in weniger als einer Minute.';

  @override
  String get appVersionLabel => 'App-Version';

  @override
  String get defaultUnits => 'Standardeinheiten';

  @override
  String get defaultKerf => 'Standard-Schnittfuge';

  @override
  String get theme => 'Design';

  @override
  String get newProjectTitle => 'Neue Schnittliste';

  @override
  String get projectNameLabel => 'Projektname';

  @override
  String get projectNameHint => 'Garagenrahmen';

  @override
  String get materialLabel => 'Material';

  @override
  String get materialHint => 'Stahl 40x20';

  @override
  String get noteLabel => 'Notiz';

  @override
  String get noteHint => 'Südwand';

  @override
  String get createCutList => 'Schnittliste erstellen';

  @override
  String get save => 'Speichern';

  @override
  String get editDetails => 'Details bearbeiten';

  @override
  String get duplicate => 'Duplizieren';

  @override
  String get copyLabel => 'Kopie';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteProjectTitle => 'Schnittliste löschen?';

  @override
  String deleteProjectMessage(String projectName) {
    return '„$projectName“ wird dauerhaft von diesem Gerät gelöscht.';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get projectDeleted => 'Schnittliste gelöscht';

  @override
  String projectActions(String projectName) {
    return 'Aktionen für $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Aktualisiert: $date';
  }

  @override
  String get stockSectionTitle => 'Rohmaterial';

  @override
  String get noStockYet => 'Noch keine Rohmateriallängen hinzugefügt.';

  @override
  String get partsSectionTitle => 'Teile';

  @override
  String get noPartsYet => 'Noch keine Teile hinzugefügt.';

  @override
  String get cutSettingsSectionTitle => 'Schnitteinstellungen';

  @override
  String get calculate => 'Berechnen';

  @override
  String get calculateDisabledHint =>
      'Füge Teile hinzu, um einen Schnittplan zu berechnen.';

  @override
  String get projectNotFound => 'Schnittliste nicht gefunden';

  @override
  String get backToProjects => 'Zurück zu den Schnittlisten';

  @override
  String get projectNameRequired => 'Gib einen Projektnamen ein.';

  @override
  String get projectNameTooLong =>
      'Der Projektname darf höchstens 80 Zeichen lang sein.';

  @override
  String get materialTooLong =>
      'Das Material darf höchstens 120 Zeichen lang sein.';

  @override
  String get noteTooLong => 'Die Notiz darf höchstens 500 Zeichen lang sein.';

  @override
  String get projectSaveError =>
      'Schnittliste konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get projectDeleteError =>
      'Schnittliste konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get projectDuplicateError =>
      'Schnittliste konnte nicht dupliziert werden. Bitte erneut versuchen.';

  @override
  String get projectsLoadError =>
      'Deine Schnittlisten konnten nicht geladen werden.';

  @override
  String get projectLoadError =>
      'Diese Schnittliste konnte nicht geladen werden.';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get fixedInventory => 'Fester Bestand';

  @override
  String get buyStock => 'Rohmaterial kaufen';

  @override
  String get addStockLength => 'Rohmateriallänge hinzufügen';

  @override
  String get editStockLength => 'Rohmateriallänge bearbeiten';

  @override
  String get stockLength => 'Länge';

  @override
  String get quantity => 'Anzahl';

  @override
  String get labelOptional => 'Bezeichnung (optional)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Lager';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Gib eine Länge ein.';

  @override
  String get stockLengthInvalid => 'Gib eine Zahl größer als null ein.';

  @override
  String get stockLengthPrecision =>
      'Dieser Wert lässt sich nicht exakt speichern. Verwende ein Vielfaches von 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Diese Länge ist zu groß.';

  @override
  String get quantityRequired => 'Gib eine Anzahl ein.';

  @override
  String get quantityInvalid => 'Gib eine ganze Zahl von 1 bis 9999 ein.';

  @override
  String get quantityTooLarge => 'Die Anzahl darf höchstens 9999 betragen.';

  @override
  String get stockLabelTooLong =>
      'Die Bezeichnung darf höchstens 80 Zeichen lang sein.';

  @override
  String get saveStock => 'Rohmateriallänge speichern';

  @override
  String get stockSaveError =>
      'Rohmateriallänge konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get stockDeleteError =>
      'Rohmateriallänge konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get stockDuplicateError =>
      'Rohmateriallänge konnte nicht dupliziert werden. Bitte erneut versuchen.';

  @override
  String get stockLoadError => 'Rohmaterial konnte nicht geladen werden.';

  @override
  String get stockNotFound => 'Rohmateriallänge nicht gefunden';

  @override
  String get deleteStockTitle => 'Rohmateriallänge löschen?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity wird aus dieser Schnittliste entfernt.';
  }

  @override
  String get stockDeleted => 'Rohmateriallänge gelöscht';

  @override
  String get duplicateStock => 'Rohmateriallänge duplizieren';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rohmateriallängen',
      one: '1 Rohmateriallänge',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stück insgesamt',
      one: '1 Stück insgesamt',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Rohmateriallänge festlegen';

  @override
  String get buyStockHelper => 'Wir berechnen, wie viele Stück du benötigst.';

  @override
  String get buyStockLengthMissing =>
      'Lege die Länge des zu kaufenden Rohmaterials fest.';

  @override
  String get stockModeSaveError =>
      'Rohmaterialmodus konnte nicht geändert werden. Bitte erneut versuchen.';

  @override
  String get backToProject => 'Zurück zur Schnittliste';

  @override
  String get decreaseQuantity => 'Anzahl verringern';

  @override
  String get increaseQuantity => 'Anzahl erhöhen';

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
    return 'Aktionen für $length';
  }

  @override
  String get decimalInchesHelper => 'Gib Zoll als Dezimalzahl ein.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Exakt gespeichert: $value mm. Die Zollanzeige ist gerundet. Die gespeicherte Länge bleibt exakt, solange du sie nicht bearbeitest.';
  }

  @override
  String get addPart => 'Teil hinzufügen';

  @override
  String get editPart => 'Teil bearbeiten';

  @override
  String get partNameOptional => 'Teilename (optional)';

  @override
  String get partNameHint => 'Pfosten';

  @override
  String get partNameTooLong =>
      'Der Teilename darf höchstens 100 Zeichen lang sein.';

  @override
  String get partSaveError =>
      'Teil konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get partDeleteError =>
      'Teil konnte nicht gelöscht werden. Bitte erneut versuchen.';

  @override
  String get partDuplicateError =>
      'Teil konnte nicht dupliziert werden. Bitte erneut versuchen.';

  @override
  String get partLoadError => 'Teile konnten nicht geladen werden.';

  @override
  String get partNotFound => 'Teil nicht gefunden';

  @override
  String get deletePartTitle => 'Teil löschen?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity wird aus dieser Schnittliste entfernt.';
  }

  @override
  String get partDeleted => 'Teil gelöscht';

  @override
  String get duplicatePart => 'Teil duplizieren';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teilezeilen',
      one: '1 Teilezeile',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Fuß';

  @override
  String get inches => 'Zoll';

  @override
  String get wholeInches => 'Ganze Zoll';

  @override
  String get fraction => 'Bruchteil';

  @override
  String get inchesRange =>
      'Verwende 0 bis 11 Zoll. Zusätzliche Fuß gibst du im Feld Fuß ein.';

  @override
  String get imperialLengthInvalid =>
      'Gib nicht negative ganze Zahlen und einen Bruchteil ein, die zusammen größer als null sind.';

  @override
  String partTooLongWarning(String length) {
    return 'Dieses Teil ist länger als die größte nutzbare Rohmateriallänge ($length).';
  }

  @override
  String get addStockToContinue => 'Füge Rohmaterial hinzu, um fortzufahren.';

  @override
  String get cutPlanUnavailable => 'Der Schnittplan ist noch nicht verfügbar.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Schnittplan';

  @override
  String get calculating => 'Wird berechnet…';

  @override
  String get recalculate => 'Neu berechnen';

  @override
  String get editCutList => 'Schnittliste bearbeiten';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rohmaterialstücke verwendet',
      one: '1 Rohmaterialstück verwendet',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Rohmaterialstücke zu kaufen',
      one: '1 Rohmaterialstück zu kaufen',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Kaufen: $length × $count';
  }

  @override
  String get requestedParts => 'Benötigte Teile';

  @override
  String get placedParts => 'Zugeordnete Teile';

  @override
  String get unplacedParts => 'Nicht zugeordnete Teile';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested Teilen',
      one: '1 Teil',
    );
    return '$placed von $_temp0 zugeordnet';
  }

  @override
  String get totalFinishedLength => 'Gesamtlänge der fertigen Teile';

  @override
  String get totalStockUsed => 'Verwendete Rohmateriallänge';

  @override
  String get totalWaste => 'Gesamter Verschnitt';

  @override
  String wastePercentage(String value) {
    return 'Verschnitt: $value%';
  }

  @override
  String get reusableLeftovers => 'Wiederverwendbare Reststücke';

  @override
  String get scrap => 'Ausschuss';

  @override
  String get kerfLoss => 'Schnittfugenverlust';

  @override
  String get trimLoss => 'Beschnittverlust';

  @override
  String get reusable => 'Wiederverwendbar';

  @override
  String get leftover => 'Reststück';

  @override
  String reusableExplanation(String threshold) {
    return 'Wiederverwendbar: Endstücke ab $threshold. Zum Ausschuss zählen Schnittfuge, Beschnitt und kürzere Reststücke.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Stange $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Teile',
      one: '1 Teil',
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
    return 'Endbeschnitt: $length je Ende';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Rohmaterialstange $number, $length, $parts, Reststück $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Nicht zugeordnete Teile ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Es ist nicht genug Rohmaterial für dieses Teil übrig.';

  @override
  String get resultLoadError =>
      'Diese Schnittliste konnte nicht berechnet werden.';

  @override
  String get resultValidationError =>
      'Prüfe Rohmaterial, Teile und Schnitteinstellungen vor der Berechnung.';

  @override
  String get stockTooShortAfterTrim =>
      'Das Rohmaterial ist nach dem Endbeschnitt zu kurz.';

  @override
  String get validBuyStockRequired =>
      'Lege vor der Berechnung eine gültige Rohmateriallänge fest.';

  @override
  String get tooLongResultReason =>
      'Dieses Teil ist länger als die größte nutzbare Rohmateriallänge.';

  @override
  String get editCutSettings => 'Schnitteinstellungen bearbeiten';

  @override
  String get units => 'Einheiten';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Millimeter';

  @override
  String get centimeters => 'Zentimeter';

  @override
  String get meters => 'Meter';

  @override
  String get feetAndInches => 'Fuß und Zoll';

  @override
  String get kerf => 'Schnittfuge';

  @override
  String get kerfHelper =>
      'Materialverlust zwischen aufeinanderfolgenden Teilen.';

  @override
  String get kerfFinalPartHelper =>
      'Nach dem letzten Teil einer Stange wird keine Schnittfuge berechnet.';

  @override
  String get endTrimEachEnd => 'Endbeschnitt (je Ende)';

  @override
  String get endTrimHelper =>
      'Diese Länge wird an beiden Enden jeder Stange abgeschnitten.';

  @override
  String get reusableLeftover => 'Wiederverwendbares Reststück';

  @override
  String get reusableLeftoverHelper =>
      'Reststücke ab dieser Länge gelten als wiederverwendbar.';

  @override
  String get cutSettingsSaveError =>
      'Schnitteinstellungen konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get noUsableStockAfterTrim =>
      'Nach dem Endbeschnitt bleibt keine nutzbare Rohmateriallänge übrig.';

  @override
  String get someStockUnusableAfterTrim =>
      'Einige Stangen sind nach dem Endbeschnitt zu kurz.';

  @override
  String get nonnegativeLengthInvalid =>
      'Gib eine Zahl größer oder gleich null ein.';

  @override
  String get nonnegativeImperialInvalid =>
      'Gib nicht negative ganze Zahlen und einen Bruchteil ein.';

  @override
  String get share => 'Teilen';

  @override
  String get shareCutPlan => 'Schnittplan teilen';

  @override
  String get shareText => 'Text teilen';

  @override
  String get sharePdf => 'PDF teilen';

  @override
  String get copyBuyList => 'Einkaufsliste kopieren';

  @override
  String get buyListCopied => 'Einkaufsliste kopiert';

  @override
  String get creatingPdf => 'PDF wird erstellt…';

  @override
  String get pdfCreateError =>
      'PDF konnte nicht erstellt werden. Bitte erneut versuchen.';

  @override
  String get shareError =>
      'Schnittplan konnte nicht geteilt werden. Bitte erneut versuchen.';

  @override
  String get buyListCopyError =>
      'Einkaufsliste konnte nicht kopiert werden. Bitte erneut versuchen.';

  @override
  String get reportSummary => 'Übersicht';

  @override
  String get reportPurchase => 'Einkauf';

  @override
  String get generatedLabel => 'Erstellt';

  @override
  String generatedBy(String appName) {
    return 'Erstellt mit $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Schnittpläne dienen der Planung. Prüfe jede Abmessung am Rohmaterial vor dem Schneiden und beachte die Sicherheitsregeln für deine Werkzeuge.';

  @override
  String get reportFileFallback => 'Schnittplan';

  @override
  String get addLeftoversToStock => 'Reststücke zum Rohmaterial hinzufügen';

  @override
  String get addLeftoversTitle => 'Reststücke zum Rohmaterial hinzufügen?';

  @override
  String get addLeftoversMessage =>
      'Diese wiederverwendbaren Reststücke werden für künftige Schnittpläne zum festen Bestand dieses Projekts hinzugefügt.';

  @override
  String get addLeftoversFutureHint =>
      'Füge sie erst nach Abschluss der Schnitte hinzu.';

  @override
  String get addToStock => 'Zum Rohmaterial hinzufügen';

  @override
  String get leftoversAddedToStock =>
      'Wiederverwendbare Reststücke für künftige Schnittpläne hinzugefügt.';

  @override
  String get leftoversAddError =>
      'Reststücke konnten nicht hinzugefügt werden. Bitte erneut versuchen.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count wiederverwendbare Stücke',
      one: '1 wiederverwendbares Stück',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Speichern und weiteres hinzufügen';

  @override
  String get defaultsSectionTitle => 'Standardwerte';

  @override
  String get appearanceSectionTitle => 'Darstellung';

  @override
  String get defaultReusableLeftover => 'Standardlänge für Reststücke';

  @override
  String get newProjectsDefaultsHelper =>
      'Diese Werte gelten für neue Schnittlisten. Bestehende Schnittlisten bleiben unverändert.';

  @override
  String get defaultReusableHelper =>
      'In neuen Projekten gelten Reststücke ab dieser Länge als wiederverwendbar.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get settingsSaveError =>
      'Einstellungen konnten nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get settingsLoadError => 'Einstellungen konnten nicht geladen werden.';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

  @override
  String get language => 'Sprache';

  @override
  String get languageSystem => 'Systemstandard';

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
  String get upgradeOnce => 'Einmal kaufen. Dauerhaft nutzen.';

  @override
  String get noSubscription => 'Kein Abo.';

  @override
  String get lifetimePro => 'Pro auf Lebenszeit';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String unlockLifetimePro(String price) {
    return 'Pro auf Lebenszeit freischalten — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Werbung entfernen — $price';
  }

  @override
  String get proActive => 'Pro auf Lebenszeit aktiv';

  @override
  String get adFreeActive => 'Werbefrei';

  @override
  String get includedWithPro => 'In Pro auf Lebenszeit enthalten';

  @override
  String get removeAdsDescription =>
      'Kostenlose Funktionen behalten und Werbung entfernen.';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restoringPurchases => 'Käufe werden wiederhergestellt…';

  @override
  String get purchasesRestored => 'Käufe wiederhergestellt';

  @override
  String get lifetimeProRestored => 'Pro auf Lebenszeit wiederhergestellt';

  @override
  String get adFreeRestored => 'Werbefrei wiederhergestellt';

  @override
  String get nothingToRestore => 'Keine Käufe zum Wiederherstellen';

  @override
  String get purchasePending => 'Kauf ausstehend';

  @override
  String get purchasePendingMessage =>
      'Google Play verarbeitet die Zahlung für deinen Kauf noch.';

  @override
  String get purchaseError =>
      'Kauf konnte nicht abgeschlossen werden. Bitte erneut versuchen.';

  @override
  String get restoreError =>
      'Käufe konnten nicht wiederhergestellt werden. Bitte erneut versuchen.';

  @override
  String get billingUnavailable => 'Käufe sind derzeit nicht verfügbar.';

  @override
  String get productUnavailable => 'Vorübergehend nicht verfügbar.';

  @override
  String get processingPurchase => 'Kauf wird überprüft…';

  @override
  String get purchaseVerified => 'Kauf überprüft';

  @override
  String get kerfPlanFree => 'KerfPlan Kostenlos';

  @override
  String get viewPro => 'Pro ansehen';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get benefitUnlimitedProjects => 'Unbegrenzte Schnittlisten';

  @override
  String get benefitMultipleStocks => 'Mehrere Rohmateriallängen';

  @override
  String get benefitPdf => 'PDF-Export für die Werkstatt';

  @override
  String get benefitReuseLeftovers => 'Reststücke wiederverwenden';

  @override
  String get benefitNoAds => 'Keine Werbung';

  @override
  String get onboardingIntro =>
      'Plane lineare Zuschnitte mit weniger Verschnitt.';

  @override
  String get howDoYouMeasure => 'Wie misst du?';

  @override
  String get metric => 'Metrisch';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricDescription => 'Millimeter, Zentimeter und Meter';

  @override
  String get imperialDescription => 'Zoll und Fuß';

  @override
  String get recommendedForRegion => 'Für deine Region empfohlen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get measurementCanChangeLater =>
      'Du kannst dies später in den Einstellungen ändern.';

  @override
  String get measurements => 'Maße';

  @override
  String get measurementSystem => 'Maßsystem';

  @override
  String get commonLengths => 'Gängige Längen';
}
