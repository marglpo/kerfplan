// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get newCutList => 'Nuova lista di taglio';

  @override
  String get noProjectsTitle => 'Nessuna lista di taglio';

  @override
  String get noProjectsMessage =>
      'Pianifica il primo lavoro in meno di un minuto.';

  @override
  String get appVersionLabel => 'Versione dell\'app';

  @override
  String get defaultUnits => 'Unità predefinite';

  @override
  String get defaultKerf => 'Spessore di taglio predefinito';

  @override
  String get theme => 'Tema';

  @override
  String get newProjectTitle => 'Nuova lista di taglio';

  @override
  String get projectNameLabel => 'Nome del progetto';

  @override
  String get projectNameHint => 'Telaio del garage';

  @override
  String get materialLabel => 'Materiale';

  @override
  String get materialHint => 'Acciaio 40x20';

  @override
  String get noteLabel => 'Nota';

  @override
  String get noteHint => 'Parete sud';

  @override
  String get createCutList => 'Crea lista di taglio';

  @override
  String get save => 'Salva';

  @override
  String get editDetails => 'Modifica dettagli';

  @override
  String get duplicate => 'Duplica';

  @override
  String get copyLabel => 'Copia';

  @override
  String get delete => 'Elimina';

  @override
  String get deleteProjectTitle => 'Eliminare la lista di taglio?';

  @override
  String deleteProjectMessage(String projectName) {
    return '“$projectName” verrà eliminata definitivamente da questo dispositivo.';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get projectDeleted => 'Lista di taglio eliminata';

  @override
  String projectActions(String projectName) {
    return 'Azioni per $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Aggiornata: $date';
  }

  @override
  String get stockSectionTitle => 'Materiale disponibile';

  @override
  String get noStockYet => 'Nessuna lunghezza di materiale aggiunta.';

  @override
  String get partsSectionTitle => 'Pezzi';

  @override
  String get noPartsYet => 'Nessun pezzo aggiunto.';

  @override
  String get cutSettingsSectionTitle => 'Impostazioni di taglio';

  @override
  String get calculate => 'Calcola';

  @override
  String get calculateDisabledHint =>
      'Aggiungi pezzi per calcolare un piano di taglio.';

  @override
  String get projectNotFound => 'Lista di taglio non trovata';

  @override
  String get backToProjects => 'Torna alle liste';

  @override
  String get projectNameRequired => 'Inserisci un nome per il progetto.';

  @override
  String get projectNameTooLong =>
      'Il nome del progetto deve contenere al massimo 80 caratteri.';

  @override
  String get materialTooLong =>
      'Il materiale deve contenere al massimo 120 caratteri.';

  @override
  String get noteTooLong => 'La nota deve contenere al massimo 500 caratteri.';

  @override
  String get projectSaveError =>
      'Impossibile salvare la lista di taglio. Riprova.';

  @override
  String get projectDeleteError =>
      'Impossibile eliminare la lista di taglio. Riprova.';

  @override
  String get projectDuplicateError =>
      'Impossibile duplicare la lista di taglio. Riprova.';

  @override
  String get projectsLoadError => 'Impossibile caricare le liste di taglio.';

  @override
  String get projectLoadError => 'Impossibile caricare questa lista di taglio.';

  @override
  String get retry => 'Riprova';

  @override
  String get fixedInventory => 'Giacenza disponibile';

  @override
  String get buyStock => 'Acquista materiale';

  @override
  String get addStockLength => 'Aggiungi lunghezza di materiale';

  @override
  String get editStockLength => 'Modifica lunghezza di materiale';

  @override
  String get stockLength => 'Lunghezza';

  @override
  String get quantity => 'Quantità';

  @override
  String get labelOptional => 'Etichetta (facoltativa)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Magazzino';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Inserisci una lunghezza.';

  @override
  String get stockLengthInvalid => 'Inserisci un numero maggiore di zero.';

  @override
  String get stockLengthPrecision =>
      'Questo valore non può essere salvato esattamente. Usa un multiplo di 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Questa lunghezza è troppo grande.';

  @override
  String get quantityRequired => 'Inserisci una quantità.';

  @override
  String get quantityInvalid => 'Inserisci un numero intero da 1 a 9999.';

  @override
  String get quantityTooLarge => 'La quantità deve essere al massimo 9999.';

  @override
  String get stockLabelTooLong =>
      'L\'etichetta deve contenere al massimo 80 caratteri.';

  @override
  String get saveStock => 'Salva lunghezza di materiale';

  @override
  String get stockSaveError => 'Impossibile salvare questa lunghezza. Riprova.';

  @override
  String get stockDeleteError =>
      'Impossibile eliminare questa lunghezza. Riprova.';

  @override
  String get stockDuplicateError =>
      'Impossibile duplicare questa lunghezza. Riprova.';

  @override
  String get stockLoadError => 'Impossibile caricare il materiale disponibile.';

  @override
  String get stockNotFound => 'Lunghezza di materiale non trovata';

  @override
  String get deleteStockTitle => 'Eliminare la lunghezza di materiale?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity verrà rimosso da questa lista di taglio.';
  }

  @override
  String get stockDeleted => 'Lunghezza di materiale eliminata';

  @override
  String get duplicateStock => 'Duplica lunghezza di materiale';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lunghezze di materiale',
      one: '1 lunghezza di materiale',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pezzi in totale',
      one: '1 pezzo in totale',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Imposta lunghezza del materiale';

  @override
  String get buyStockHelper => 'Calcoleremo quanti pezzi acquistare.';

  @override
  String get buyStockLengthMissing =>
      'Imposta la lunghezza del materiale che intendi acquistare.';

  @override
  String get stockModeSaveError =>
      'Impossibile cambiare la modalità materiale. Riprova.';

  @override
  String get backToProject => 'Torna alla lista di taglio';

  @override
  String get decreaseQuantity => 'Riduci quantità';

  @override
  String get increaseQuantity => 'Aumenta quantità';

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
    return 'Azioni per $length';
  }

  @override
  String get decimalInchesHelper => 'Inserisci pollici in formato decimale.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Salvato esattamente: $value mm. La misura in pollici è approssimata. La lunghezza salvata resta esatta finché non la modifichi.';
  }

  @override
  String get addPart => 'Aggiungi pezzo';

  @override
  String get editPart => 'Modifica pezzo';

  @override
  String get partNameOptional => 'Nome del pezzo (facoltativo)';

  @override
  String get partNameHint => 'Montante';

  @override
  String get partNameTooLong =>
      'Il nome del pezzo deve contenere al massimo 100 caratteri.';

  @override
  String get partSaveError => 'Impossibile salvare questo pezzo. Riprova.';

  @override
  String get partDeleteError => 'Impossibile eliminare questo pezzo. Riprova.';

  @override
  String get partDuplicateError =>
      'Impossibile duplicare questo pezzo. Riprova.';

  @override
  String get partLoadError => 'Impossibile caricare i pezzi.';

  @override
  String get partNotFound => 'Pezzo non trovato';

  @override
  String get deletePartTitle => 'Eliminare il pezzo?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity verrà rimosso da questa lista di taglio.';
  }

  @override
  String get partDeleted => 'Pezzo eliminato';

  @override
  String get duplicatePart => 'Duplica pezzo';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count righe di pezzi',
      one: '1 riga di pezzi',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Piedi';

  @override
  String get inches => 'Pollici';

  @override
  String get wholeInches => 'Pollici interi';

  @override
  String get fraction => 'Frazione';

  @override
  String get inchesRange =>
      'Usa da 0 a 11 pollici. Inserisci i piedi aggiuntivi nel campo Piedi.';

  @override
  String get imperialLengthInvalid =>
      'Inserisci numeri interi non negativi e una frazione la cui somma sia maggiore di zero.';

  @override
  String partTooLongWarning(String length) {
    return 'Questo pezzo supera la maggiore lunghezza utile del materiale ($length).';
  }

  @override
  String get addStockToContinue => 'Aggiungi materiale per continuare.';

  @override
  String get cutPlanUnavailable =>
      'Il piano di taglio non è ancora disponibile.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Piano di taglio';

  @override
  String get calculating => 'Calcolo in corso…';

  @override
  String get recalculate => 'Ricalcola';

  @override
  String get editCutList => 'Modifica lista di taglio';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pezzi di materiale utilizzati',
      one: '1 pezzo di materiale utilizzato',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pezzi di materiale da acquistare',
      one: '1 pezzo di materiale da acquistare',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Acquista $length × $count';
  }

  @override
  String get requestedParts => 'Pezzi richiesti';

  @override
  String get placedParts => 'Pezzi assegnati';

  @override
  String get unplacedParts => 'Pezzi non assegnati';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested pezzi',
      one: '1 pezzo',
    );
    return 'Assegnati $placed pezzi su $_temp0';
  }

  @override
  String get totalFinishedLength => 'Lunghezza totale dei pezzi finiti';

  @override
  String get totalStockUsed => 'Lunghezza totale del materiale usato';

  @override
  String get totalWaste => 'Scarto totale';

  @override
  String wastePercentage(String value) {
    return 'Scarto: $value%';
  }

  @override
  String get reusableLeftovers => 'Rimanenze riutilizzabili';

  @override
  String get scrap => 'Residui da scartare';

  @override
  String get kerfLoss => 'Perdita dovuta al taglio';

  @override
  String get trimLoss => 'Perdita dovuta alla rifilatura';

  @override
  String get reusable => 'Riutilizzabile';

  @override
  String get leftover => 'Rimanenza';

  @override
  String reusableExplanation(String threshold) {
    return 'Riutilizzabili: rimanenze di almeno $threshold. I residui da scartare comprendono taglio, rifilatura e rimanenze più corte.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Barra $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pezzi',
      one: '1 pezzo',
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
    return 'Rifilatura: $length per estremità';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Barra di materiale $number, $length, $parts, rimanenza $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Pezzi non assegnati ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Non resta abbastanza materiale per assegnare questo pezzo.';

  @override
  String get resultLoadError => 'Impossibile calcolare questa lista di taglio.';

  @override
  String get resultValidationError =>
      'Controlla materiale, pezzi e impostazioni di taglio prima del calcolo.';

  @override
  String get stockTooShortAfterTrim =>
      'Il materiale è troppo corto dopo la rifilatura delle estremità.';

  @override
  String get validBuyStockRequired =>
      'Imposta una lunghezza valida del materiale prima del calcolo.';

  @override
  String get tooLongResultReason =>
      'Questo pezzo supera la maggiore lunghezza utile del materiale.';

  @override
  String get editCutSettings => 'Modifica impostazioni di taglio';

  @override
  String get units => 'Unità';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Millimetri';

  @override
  String get centimeters => 'Centimetri';

  @override
  String get meters => 'Metri';

  @override
  String get feetAndInches => 'Piedi e pollici';

  @override
  String get kerf => 'Spessore di taglio';

  @override
  String get kerfHelper => 'Materiale asportato tra pezzi consecutivi.';

  @override
  String get kerfFinalPartHelper =>
      'Non si aggiunge un taglio dopo l\'ultimo pezzo di una barra.';

  @override
  String get endTrimEachEnd => 'Rifilatura estremità (per estremità)';

  @override
  String get endTrimHelper =>
      'Rimuovi questa lunghezza da ciascuna estremità di ogni barra.';

  @override
  String get reusableLeftover => 'Rimanenza riutilizzabile';

  @override
  String get reusableLeftoverHelper =>
      'Le rimanenze di questa lunghezza o più sono considerate riutilizzabili.';

  @override
  String get cutSettingsSaveError =>
      'Impossibile salvare le impostazioni di taglio. Riprova.';

  @override
  String get noUsableStockAfterTrim =>
      'Dopo la rifilatura non rimane materiale utilizzabile.';

  @override
  String get someStockUnusableAfterTrim =>
      'Alcune barre sono troppo corte dopo la rifilatura.';

  @override
  String get nonnegativeLengthInvalid =>
      'Inserisci un numero maggiore o uguale a zero.';

  @override
  String get nonnegativeImperialInvalid =>
      'Inserisci numeri interi non negativi e una frazione.';

  @override
  String get share => 'Condividi';

  @override
  String get shareCutPlan => 'Condividi piano di taglio';

  @override
  String get shareText => 'Condividi testo';

  @override
  String get sharePdf => 'Condividi PDF';

  @override
  String get copyBuyList => 'Copia lista acquisti';

  @override
  String get buyListCopied => 'Lista acquisti copiata';

  @override
  String get creatingPdf => 'Creazione PDF…';

  @override
  String get pdfCreateError => 'Impossibile creare il PDF. Riprova.';

  @override
  String get shareError =>
      'Impossibile condividere il piano di taglio. Riprova.';

  @override
  String get buyListCopyError =>
      'Impossibile copiare la lista acquisti. Riprova.';

  @override
  String get reportSummary => 'Riepilogo';

  @override
  String get reportPurchase => 'Acquisto';

  @override
  String get generatedLabel => 'Generato';

  @override
  String generatedBy(String appName) {
    return 'Generato da $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'I piani di taglio aiutano a pianificare il lavoro. Verifica ogni misura sul materiale prima di tagliare e segui le norme di sicurezza degli attrezzi.';

  @override
  String get reportFileFallback => 'Piano di taglio';

  @override
  String get addLeftoversToStock => 'Aggiungi rimanenze al materiale';

  @override
  String get addLeftoversTitle => 'Aggiungere le rimanenze al materiale?';

  @override
  String get addLeftoversMessage =>
      'Queste rimanenze riutilizzabili saranno aggiunte alla giacenza di questo progetto per i futuri piani di taglio.';

  @override
  String get addLeftoversFutureHint =>
      'Aggiungile dopo aver completato i tagli.';

  @override
  String get addToStock => 'Aggiungi al materiale';

  @override
  String get leftoversAddedToStock =>
      'Rimanenze riutilizzabili aggiunte per i futuri piani di taglio.';

  @override
  String get leftoversAddError =>
      'Impossibile aggiungere le rimanenze. Riprova.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pezzi riutilizzabili',
      one: '1 pezzo riutilizzabile',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Salva e aggiungine un altro';

  @override
  String get defaultsSectionTitle => 'Valori predefiniti';

  @override
  String get appearanceSectionTitle => 'Aspetto';

  @override
  String get defaultReusableLeftover => 'Rimanenza riutilizzabile predefinita';

  @override
  String get newProjectsDefaultsHelper =>
      'Questi valori si usano per nuove liste di taglio. Le liste esistenti non cambiano.';

  @override
  String get defaultReusableHelper =>
      'Nei nuovi progetti, le rimanenze di questa lunghezza o più sono riutilizzabili.';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get settingsSaveError =>
      'Impossibile salvare le impostazioni. Riprova.';

  @override
  String get settingsLoadError => 'Impossibile caricare le impostazioni.';

  @override
  String get settingsSaved => 'Impostazioni salvate';

  @override
  String get language => 'Lingua';

  @override
  String get languageSystem => 'Lingua del sistema';

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
  String get upgradeOnce => 'Acquista una volta. Usalo per sempre.';

  @override
  String get noSubscription => 'Nessun abbonamento.';

  @override
  String get lifetimePro => 'Pro a vita';

  @override
  String get removeAds => 'Rimuovi pubblicità';

  @override
  String unlockLifetimePro(String price) {
    return 'Sblocca Pro a vita — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Rimuovi pubblicità — $price';
  }

  @override
  String get proActive => 'Pro a vita attivo';

  @override
  String get adFreeActive => 'Senza pubblicità';

  @override
  String get includedWithPro => 'Incluso in Pro a vita';

  @override
  String get removeAdsDescription =>
      'Mantieni le funzioni gratuite senza pubblicità.';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get restoringPurchases => 'Ripristino degli acquisti…';

  @override
  String get purchasesRestored => 'Acquisti ripristinati';

  @override
  String get lifetimeProRestored => 'Pro a vita ripristinato';

  @override
  String get adFreeRestored => 'Versione senza pubblicità ripristinata';

  @override
  String get nothingToRestore => 'Nessun acquisto da ripristinare';

  @override
  String get purchasePending => 'Acquisto in sospeso';

  @override
  String get purchasePendingMessage =>
      'Il tuo acquisto attende che Google Play completi il pagamento.';

  @override
  String get purchaseError => 'Impossibile completare l\'acquisto. Riprova.';

  @override
  String get restoreError => 'Impossibile ripristinare gli acquisti. Riprova.';

  @override
  String get billingUnavailable => 'Gli acquisti non sono disponibili ora.';

  @override
  String get productUnavailable => 'Temporaneamente non disponibile.';

  @override
  String get processingPurchase => 'Verifica dell\'acquisto…';

  @override
  String get purchaseVerified => 'Acquisto verificato';

  @override
  String get kerfPlanFree => 'KerfPlan Gratuito';

  @override
  String get viewPro => 'Visualizza Pro';

  @override
  String get upgrade => 'Passa a Pro';

  @override
  String get benefitUnlimitedProjects => 'Liste di taglio illimitate';

  @override
  String get benefitMultipleStocks => 'Più lunghezze di materiale';

  @override
  String get benefitPdf => 'Esportazione PDF per l\'officina';

  @override
  String get benefitReuseLeftovers => 'Riutilizza le rimanenze';

  @override
  String get benefitNoAds => 'Nessuna pubblicità';

  @override
  String get onboardingIntro => 'Pianifica i tagli lineari con meno scarti.';

  @override
  String get howDoYouMeasure => 'Come misuri?';

  @override
  String get metric => 'Metrico';

  @override
  String get imperial => 'Imperiale';

  @override
  String get metricDescription => 'Millimetri, centimetri e metri';

  @override
  String get imperialDescription => 'Pollici e piedi';

  @override
  String get recommendedForRegion => 'Consigliato per la tua regione';

  @override
  String get continueAction => 'Continua';

  @override
  String get measurementCanChangeLater =>
      'Puoi cambiarlo in seguito nelle Impostazioni.';

  @override
  String get measurements => 'Misure';

  @override
  String get measurementSystem => 'Sistema di misura';

  @override
  String get commonLengths => 'Lunghezze comuni';
}
