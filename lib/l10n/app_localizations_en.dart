// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get newCutList => 'New Cut List';

  @override
  String get noProjectsTitle => 'No cut lists yet';

  @override
  String get noProjectsMessage => 'Plan your first job in under a minute.';

  @override
  String get appVersionLabel => 'App version';

  @override
  String get defaultUnits => 'Default units';

  @override
  String get defaultKerf => 'Default kerf';

  @override
  String get theme => 'Theme';

  @override
  String get newProjectTitle => 'New cut list';

  @override
  String get projectNameLabel => 'Project name';

  @override
  String get projectNameHint => 'Garage frame';

  @override
  String get materialLabel => 'Material';

  @override
  String get materialHint => '40x20 steel';

  @override
  String get noteLabel => 'Note';

  @override
  String get noteHint => 'South wall';

  @override
  String get createCutList => 'Create Cut List';

  @override
  String get save => 'Save';

  @override
  String get editDetails => 'Edit details';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get copyLabel => 'Copy';

  @override
  String get delete => 'Delete';

  @override
  String get deleteProjectTitle => 'Delete cut list?';

  @override
  String deleteProjectMessage(String projectName) {
    return 'This permanently deletes \"$projectName\" from this device.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get projectDeleted => 'Cut list deleted';

  @override
  String projectActions(String projectName) {
    return 'Actions for $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Updated $date';
  }

  @override
  String get stockSectionTitle => 'Stock';

  @override
  String get noStockYet => 'No stock lengths added yet.';

  @override
  String get partsSectionTitle => 'Parts';

  @override
  String get noPartsYet => 'No parts added yet.';

  @override
  String get cutSettingsSectionTitle => 'Cut settings';

  @override
  String get calculate => 'Calculate';

  @override
  String get calculateDisabledHint => 'Add parts to calculate a cut plan.';

  @override
  String get projectNotFound => 'Cut list not found';

  @override
  String get backToProjects => 'Back to projects';

  @override
  String get projectNameRequired => 'Enter a project name.';

  @override
  String get projectNameTooLong =>
      'Project name must be 80 characters or fewer.';

  @override
  String get materialTooLong => 'Material must be 120 characters or fewer.';

  @override
  String get noteTooLong => 'Note must be 500 characters or fewer.';

  @override
  String get projectSaveError => 'Couldn’t save the cut list. Try again.';

  @override
  String get projectDeleteError => 'Couldn’t delete the cut list. Try again.';

  @override
  String get projectDuplicateError =>
      'Couldn’t duplicate the cut list. Try again.';

  @override
  String get projectsLoadError => 'Couldn’t load your cut lists.';

  @override
  String get projectLoadError => 'Couldn’t load this cut list.';

  @override
  String get retry => 'Retry';

  @override
  String get fixedInventory => 'Fixed inventory';

  @override
  String get buyStock => 'Buy stock';

  @override
  String get addStockLength => 'Add stock length';

  @override
  String get editStockLength => 'Edit stock length';

  @override
  String get stockLength => 'Length';

  @override
  String get quantity => 'Quantity';

  @override
  String get labelOptional => 'Label (optional)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2.4';

  @override
  String get stockLabelHint => 'Warehouse';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Enter a length.';

  @override
  String get stockLengthInvalid => 'Enter a number greater than zero.';

  @override
  String get stockLengthPrecision =>
      'This value cannot be stored exactly. Use a length that is a multiple of 0.0001 mm.';

  @override
  String get stockLengthTooLarge => 'This length is too large.';

  @override
  String get quantityRequired => 'Enter a quantity.';

  @override
  String get quantityInvalid => 'Enter a whole number from 1 to 9999.';

  @override
  String get quantityTooLarge => 'Quantity must be 9999 or fewer.';

  @override
  String get stockLabelTooLong => 'Label must be 80 characters or fewer.';

  @override
  String get saveStock => 'Save stock length';

  @override
  String get stockSaveError => 'Couldn’t save this stock length. Try again.';

  @override
  String get stockDeleteError =>
      'Couldn’t delete this stock length. Try again.';

  @override
  String get stockDuplicateError =>
      'Couldn’t duplicate this stock length. Try again.';

  @override
  String get stockLoadError => 'Couldn’t load stock.';

  @override
  String get stockNotFound => 'Stock length not found';

  @override
  String get deleteStockTitle => 'Delete stock length?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity will be removed from this cut list.';
  }

  @override
  String get stockDeleted => 'Stock length deleted';

  @override
  String get duplicateStock => 'Duplicate stock length';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stock lengths',
      one: '1 stock length',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count total pieces',
      one: '1 total piece',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Set stock length';

  @override
  String get buyStockHelper => 'We’ll calculate how many pieces you need.';

  @override
  String get buyStockLengthMissing => 'Set the stock length you plan to buy.';

  @override
  String get stockModeSaveError => 'Couldn’t change stock mode. Try again.';

  @override
  String get backToProject => 'Back to cut list';

  @override
  String get decreaseQuantity => 'Decrease quantity';

  @override
  String get increaseQuantity => 'Increase quantity';

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
    return 'Actions for $length';
  }

  @override
  String get decimalInchesHelper => 'Enter decimal inches.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Stored exactly: $value mm. The inch display is approximate. The saved length stays exact unless you edit it.';
  }

  @override
  String get addPart => 'Add part';

  @override
  String get editPart => 'Edit part';

  @override
  String get partNameOptional => 'Part name (optional)';

  @override
  String get partNameHint => 'Upright';

  @override
  String get partNameTooLong => 'Part name must be 100 characters or fewer.';

  @override
  String get partSaveError => 'Couldn’t save this part. Try again.';

  @override
  String get partDeleteError => 'Couldn’t delete this part. Try again.';

  @override
  String get partDuplicateError => 'Couldn’t duplicate this part. Try again.';

  @override
  String get partLoadError => 'Couldn’t load parts.';

  @override
  String get partNotFound => 'Part not found';

  @override
  String get deletePartTitle => 'Delete part?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity will be removed from this cut list.';
  }

  @override
  String get partDeleted => 'Part deleted';

  @override
  String get duplicatePart => 'Duplicate part';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count part lines',
      one: '1 part line',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Feet';

  @override
  String get inches => 'Inches';

  @override
  String get wholeInches => 'Whole inches';

  @override
  String get fraction => 'Fraction';

  @override
  String get inchesRange =>
      'Use 0 to 11 inches. Enter additional feet in the Feet field.';

  @override
  String get imperialLengthInvalid =>
      'Enter whole numbers of zero or more and a fraction, totaling more than zero.';

  @override
  String partTooLongWarning(String length) {
    return 'This part is longer than your largest usable stock length ($length).';
  }

  @override
  String get addStockToContinue => 'Add stock to continue.';

  @override
  String get cutPlanUnavailable => 'Cut plan isn’t available yet.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Cut plan';

  @override
  String get calculating => 'Calculating…';

  @override
  String get recalculate => 'Recalculate';

  @override
  String get editCutList => 'Edit cut list';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stock pieces used',
      one: '1 stock piece used',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stock pieces to buy',
      one: '1 stock piece to buy',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Buy $length × $count';
  }

  @override
  String get requestedParts => 'Requested parts';

  @override
  String get placedParts => 'Placed parts';

  @override
  String get unplacedParts => 'Unplaced parts';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested parts',
      one: '1 part',
    );
    return 'Placed $placed of $_temp0';
  }

  @override
  String get totalFinishedLength => 'Total finished length';

  @override
  String get totalStockUsed => 'Total stock used';

  @override
  String get totalWaste => 'Total waste';

  @override
  String wastePercentage(String value) {
    return 'Waste: $value%';
  }

  @override
  String get reusableLeftovers => 'Reusable leftovers';

  @override
  String get scrap => 'Scrap';

  @override
  String get kerfLoss => 'Kerf loss';

  @override
  String get trimLoss => 'Trim loss';

  @override
  String get reusable => 'Reusable';

  @override
  String get leftover => 'Leftover';

  @override
  String reusableExplanation(String threshold) {
    return 'Reusable: tail leftovers at least $threshold. Scrap includes kerf, trim, and shorter leftovers.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Bar $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parts',
      one: '1 part',
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
    return 'End trim: $length each end';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Stock bar $number, $length, $parts, leftover $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Unplaced parts ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Not enough stock remains to place this part.';

  @override
  String get resultLoadError => 'Couldn’t calculate this cut list.';

  @override
  String get resultValidationError =>
      'Check stock, parts, and cut settings before calculating.';

  @override
  String get stockTooShortAfterTrim => 'Stock is too short after end trim.';

  @override
  String get validBuyStockRequired =>
      'Set a valid stock length before calculating.';

  @override
  String get tooLongResultReason =>
      'This part is longer than the largest usable stock length.';

  @override
  String get editCutSettings => 'Edit cut settings';

  @override
  String get units => 'Units';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Millimeters';

  @override
  String get centimeters => 'Centimeters';

  @override
  String get meters => 'Meters';

  @override
  String get feetAndInches => 'Feet and inches';

  @override
  String get kerf => 'Kerf';

  @override
  String get kerfHelper => 'Material removed between consecutive parts.';

  @override
  String get kerfFinalPartHelper =>
      'No kerf is added after the final part on a stock piece.';

  @override
  String get endTrimEachEnd => 'End trim (each end)';

  @override
  String get endTrimHelper =>
      'Trim this length from each end of every stock piece.';

  @override
  String get reusableLeftover => 'Reusable leftover';

  @override
  String get reusableLeftoverHelper =>
      'Leftovers at or above this length are counted as reusable.';

  @override
  String get cutSettingsSaveError => 'Couldn’t save cut settings. Try again.';

  @override
  String get noUsableStockAfterTrim =>
      'No usable stock length remains after end trim.';

  @override
  String get someStockUnusableAfterTrim =>
      'Some stock pieces are too short after end trim.';

  @override
  String get nonnegativeLengthInvalid =>
      'Enter a number greater than or equal to zero.';

  @override
  String get nonnegativeImperialInvalid =>
      'Enter whole numbers of zero or more and a fraction.';

  @override
  String get share => 'Share';

  @override
  String get shareCutPlan => 'Share cut plan';

  @override
  String get shareText => 'Share text';

  @override
  String get sharePdf => 'Share PDF';

  @override
  String get copyBuyList => 'Copy buy list';

  @override
  String get buyListCopied => 'Buy list copied';

  @override
  String get creatingPdf => 'Creating PDF…';

  @override
  String get pdfCreateError => 'Couldn’t create the PDF. Try again.';

  @override
  String get shareError => 'Couldn’t share the cut plan. Try again.';

  @override
  String get buyListCopyError => 'Couldn’t copy the buy list. Try again.';

  @override
  String get reportSummary => 'Summary';

  @override
  String get reportPurchase => 'Purchase';

  @override
  String get generatedLabel => 'Generated';

  @override
  String generatedBy(String appName) {
    return 'Generated by $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Cut plans are planning aids. Verify each measurement on the stock before cutting and follow tool safety procedures.';

  @override
  String get reportFileFallback => 'Cut Plan';

  @override
  String get addLeftoversToStock => 'Add leftovers to stock';

  @override
  String get addLeftoversTitle => 'Add leftovers to stock?';

  @override
  String get addLeftoversMessage =>
      'These reusable leftovers will be added to this project\'s Fixed Inventory for future cut plans.';

  @override
  String get addLeftoversFutureHint => 'Add them after the cuts are complete.';

  @override
  String get addToStock => 'Add to stock';

  @override
  String get leftoversAddedToStock =>
      'Reusable leftovers added to stock for future cut plans.';

  @override
  String get leftoversAddError => 'Couldn’t add leftovers to stock. Try again.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reusable pieces',
      one: '1 reusable piece',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Save & add another';

  @override
  String get defaultsSectionTitle => 'Defaults';

  @override
  String get appearanceSectionTitle => 'Appearance';

  @override
  String get defaultReusableLeftover => 'Default reusable leftover';

  @override
  String get newProjectsDefaultsHelper =>
      'These values are used when you create a new cut list. Existing cut lists are not changed.';

  @override
  String get defaultReusableHelper =>
      'Leftovers at or above this length are counted as reusable in new projects.';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsSaveError => 'Couldn’t save settings. Try again.';

  @override
  String get settingsLoadError => 'Couldn’t load settings.';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'System default';

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
  String get upgradeOnce => 'Upgrade once. Keep it for good.';

  @override
  String get noSubscription => 'No subscription.';

  @override
  String get lifetimePro => 'Lifetime Pro';

  @override
  String get removeAds => 'Remove Ads';

  @override
  String unlockLifetimePro(String price) {
    return 'Unlock Lifetime Pro — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Remove Ads — $price';
  }

  @override
  String get proActive => 'Lifetime Pro active';

  @override
  String get adFreeActive => 'Ad-free';

  @override
  String get includedWithPro => 'Included with Lifetime Pro';

  @override
  String get removeAdsDescription =>
      'Keep the free features and remove advertising.';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String get restoringPurchases => 'Restoring purchases…';

  @override
  String get purchasesRestored => 'Purchases restored';

  @override
  String get lifetimeProRestored => 'Lifetime Pro restored';

  @override
  String get adFreeRestored => 'Ad-free restored';

  @override
  String get nothingToRestore => 'Nothing to restore';

  @override
  String get purchasePending => 'Purchase pending';

  @override
  String get purchasePendingMessage =>
      'Your purchase is waiting for Google Play to complete payment.';

  @override
  String get purchaseError => 'Couldn’t complete the purchase. Try again.';

  @override
  String get restoreError => 'Couldn’t restore purchases. Try again.';

  @override
  String get billingUnavailable => 'Purchases are unavailable right now.';

  @override
  String get productUnavailable => 'Temporarily unavailable.';

  @override
  String get processingPurchase => 'Verifying purchase…';

  @override
  String get purchaseVerified => 'Purchase verified';

  @override
  String get kerfPlanFree => 'KerfPlan Free';

  @override
  String get viewPro => 'View Pro';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get benefitUnlimitedProjects => 'Unlimited cut lists';

  @override
  String get benefitMultipleStocks => 'Multiple stock lengths';

  @override
  String get benefitPdf => 'Workshop PDF export';

  @override
  String get benefitReuseLeftovers => 'Reuse leftovers';

  @override
  String get benefitNoAds => 'No ads';

  @override
  String get onboardingIntro => 'Plan linear cuts with less waste.';

  @override
  String get howDoYouMeasure => 'How do you measure?';

  @override
  String get metric => 'Metric';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricDescription => 'Millimeters, centimeters and meters';

  @override
  String get imperialDescription => 'Inches and feet';

  @override
  String get recommendedForRegion => 'Recommended for your region';

  @override
  String get continueAction => 'Continue';

  @override
  String get measurementCanChangeLater =>
      'You can change this later in Settings.';

  @override
  String get measurements => 'Measurements';

  @override
  String get measurementSystem => 'Measurement system';

  @override
  String get commonLengths => 'Common lengths';
}
