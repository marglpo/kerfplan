// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get newCutList => 'Nouvelle liste de coupe';

  @override
  String get noProjectsTitle => 'Aucune liste de coupe';

  @override
  String get noProjectsMessage =>
      'Préparez votre premier chantier en moins d\'une minute.';

  @override
  String get appVersionLabel => 'Version de l\'application';

  @override
  String get defaultUnits => 'Unités par défaut';

  @override
  String get defaultKerf => 'Trait de scie par défaut';

  @override
  String get theme => 'Thème';

  @override
  String get newProjectTitle => 'Nouvelle liste de coupe';

  @override
  String get projectNameLabel => 'Nom du projet';

  @override
  String get projectNameHint => 'Cadre du garage';

  @override
  String get materialLabel => 'Matériau';

  @override
  String get materialHint => 'Acier 40x20';

  @override
  String get noteLabel => 'Note';

  @override
  String get noteHint => 'Mur sud';

  @override
  String get createCutList => 'Créer la liste de coupe';

  @override
  String get save => 'Enregistrer';

  @override
  String get editDetails => 'Modifier les détails';

  @override
  String get duplicate => 'Dupliquer';

  @override
  String get copyLabel => 'Copie';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteProjectTitle => 'Supprimer la liste de coupe ?';

  @override
  String deleteProjectMessage(String projectName) {
    return '« $projectName » sera définitivement supprimé de cet appareil.';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get projectDeleted => 'Liste de coupe supprimée';

  @override
  String projectActions(String projectName) {
    return 'Actions pour $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Mis à jour : $date';
  }

  @override
  String get stockSectionTitle => 'Barres disponibles';

  @override
  String get noStockYet => 'Aucune longueur de barre ajoutée.';

  @override
  String get partsSectionTitle => 'Pièces';

  @override
  String get noPartsYet => 'Aucune pièce ajoutée.';

  @override
  String get cutSettingsSectionTitle => 'Paramètres de coupe';

  @override
  String get calculate => 'Calculer';

  @override
  String get calculateDisabledHint =>
      'Ajoutez des pièces pour calculer un plan de coupe.';

  @override
  String get projectNotFound => 'Liste de coupe introuvable';

  @override
  String get backToProjects => 'Retour aux listes';

  @override
  String get projectNameRequired => 'Saisissez un nom de projet.';

  @override
  String get projectNameTooLong =>
      'Le nom du projet doit contenir au maximum 80 caractères.';

  @override
  String get materialTooLong =>
      'Le matériau doit contenir au maximum 120 caractères.';

  @override
  String get noteTooLong => 'La note doit contenir au maximum 500 caractères.';

  @override
  String get projectSaveError =>
      'Impossible d\'enregistrer la liste de coupe. Réessayez.';

  @override
  String get projectDeleteError =>
      'Impossible de supprimer la liste de coupe. Réessayez.';

  @override
  String get projectDuplicateError =>
      'Impossible de dupliquer la liste de coupe. Réessayez.';

  @override
  String get projectsLoadError => 'Impossible de charger vos listes de coupe.';

  @override
  String get projectLoadError => 'Impossible de charger cette liste de coupe.';

  @override
  String get retry => 'Réessayer';

  @override
  String get fixedInventory => 'Stock disponible';

  @override
  String get buyStock => 'Acheter des barres';

  @override
  String get addStockLength => 'Ajouter une longueur de barre';

  @override
  String get editStockLength => 'Modifier une longueur de barre';

  @override
  String get stockLength => 'Longueur';

  @override
  String get quantity => 'Quantité';

  @override
  String get labelOptional => 'Étiquette (facultative)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Entrepôt';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Saisissez une longueur.';

  @override
  String get stockLengthInvalid => 'Saisissez un nombre supérieur à zéro.';

  @override
  String get stockLengthPrecision =>
      'Cette valeur ne peut pas être enregistrée exactement. Utilisez un multiple de 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Cette longueur est trop grande.';

  @override
  String get quantityRequired => 'Saisissez une quantité.';

  @override
  String get quantityInvalid => 'Saisissez un nombre entier de 1 à 9999.';

  @override
  String get quantityTooLarge => 'La quantité ne doit pas dépasser 9999.';

  @override
  String get stockLabelTooLong =>
      'L\'étiquette doit contenir au maximum 80 caractères.';

  @override
  String get saveStock => 'Enregistrer la longueur de barre';

  @override
  String get stockSaveError =>
      'Impossible d\'enregistrer cette longueur de barre. Réessayez.';

  @override
  String get stockDeleteError =>
      'Impossible de supprimer cette longueur de barre. Réessayez.';

  @override
  String get stockDuplicateError =>
      'Impossible de dupliquer cette longueur de barre. Réessayez.';

  @override
  String get stockLoadError => 'Impossible de charger les barres disponibles.';

  @override
  String get stockNotFound => 'Longueur de barre introuvable';

  @override
  String get deleteStockTitle => 'Supprimer la longueur de barre ?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity sera retiré de cette liste de coupe.';
  }

  @override
  String get stockDeleted => 'Longueur de barre supprimée';

  @override
  String get duplicateStock => 'Dupliquer la longueur de barre';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count longueurs de barre',
      one: '1 longueur de barre',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pièces au total',
      one: '1 pièce au total',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Définir la longueur de barre';

  @override
  String get buyStockHelper => 'Nous calculerons combien de barres acheter.';

  @override
  String get buyStockLengthMissing =>
      'Indiquez la longueur des barres à acheter.';

  @override
  String get stockModeSaveError =>
      'Impossible de changer le mode de stock. Réessayez.';

  @override
  String get backToProject => 'Retour à la liste de coupe';

  @override
  String get decreaseQuantity => 'Diminuer la quantité';

  @override
  String get increaseQuantity => 'Augmenter la quantité';

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
    return 'Actions pour $length';
  }

  @override
  String get decimalInchesHelper => 'Saisissez une valeur décimale en pouces.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Valeur exacte enregistrée : $value mm. L\'affichage en pouces est approximatif. La longueur enregistrée reste exacte tant que vous ne la modifiez pas.';
  }

  @override
  String get addPart => 'Ajouter une pièce';

  @override
  String get editPart => 'Modifier la pièce';

  @override
  String get partNameOptional => 'Nom de la pièce (facultatif)';

  @override
  String get partNameHint => 'Montant';

  @override
  String get partNameTooLong =>
      'Le nom de la pièce doit contenir au maximum 100 caractères.';

  @override
  String get partSaveError =>
      'Impossible d\'enregistrer cette pièce. Réessayez.';

  @override
  String get partDeleteError =>
      'Impossible de supprimer cette pièce. Réessayez.';

  @override
  String get partDuplicateError =>
      'Impossible de dupliquer cette pièce. Réessayez.';

  @override
  String get partLoadError => 'Impossible de charger les pièces.';

  @override
  String get partNotFound => 'Pièce introuvable';

  @override
  String get deletePartTitle => 'Supprimer la pièce ?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity sera retiré de cette liste de coupe.';
  }

  @override
  String get partDeleted => 'Pièce supprimée';

  @override
  String get duplicatePart => 'Dupliquer la pièce';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lignes de pièces',
      one: '1 ligne de pièces',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Pieds';

  @override
  String get inches => 'Pouces';

  @override
  String get wholeInches => 'Pouces entiers';

  @override
  String get fraction => 'Fraction';

  @override
  String get inchesRange =>
      'Utilisez de 0 à 11 pouces. Saisissez les pieds supplémentaires dans le champ Pieds.';

  @override
  String get imperialLengthInvalid =>
      'Saisissez des entiers positifs ou nuls et une fraction dont la somme dépasse zéro.';

  @override
  String partTooLongWarning(String length) {
    return 'Cette pièce dépasse la plus grande longueur de barre utilisable ($length).';
  }

  @override
  String get addStockToContinue => 'Ajoutez des barres pour continuer.';

  @override
  String get cutPlanUnavailable =>
      'Le plan de coupe n\'est pas encore disponible.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Plan de coupe';

  @override
  String get calculating => 'Calcul en cours…';

  @override
  String get recalculate => 'Recalculer';

  @override
  String get editCutList => 'Modifier la liste de coupe';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barres utilisées',
      one: '1 barre utilisée',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count barres à acheter',
      one: '1 barre à acheter',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Acheter $length × $count';
  }

  @override
  String get requestedParts => 'Pièces demandées';

  @override
  String get placedParts => 'Pièces placées';

  @override
  String get unplacedParts => 'Pièces non placées';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested pièces',
      one: '1 pièce',
    );
    return '$placed pièces placées sur $_temp0';
  }

  @override
  String get totalFinishedLength => 'Longueur totale des pièces finies';

  @override
  String get totalStockUsed => 'Longueur totale de barres utilisées';

  @override
  String get totalWaste => 'Chutes totales';

  @override
  String wastePercentage(String value) {
    return 'Chutes : $value%';
  }

  @override
  String get reusableLeftovers => 'Chutes réutilisables';

  @override
  String get scrap => 'Déchets';

  @override
  String get kerfLoss => 'Perte due au trait de scie';

  @override
  String get trimLoss => 'Perte due à l\'éboutage';

  @override
  String get reusable => 'Réutilisable';

  @override
  String get leftover => 'Chute';

  @override
  String reusableExplanation(String threshold) {
    return 'Réutilisables : chutes d\'au moins $threshold. Les déchets comprennent le trait de scie, l\'éboutage et les chutes plus courtes.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Barre $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pièces',
      one: '1 pièce',
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
    return 'Éboutage : $length à chaque extrémité';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Barre $number, $length, $parts, chute $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Pièces non placées ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Il ne reste pas assez de barres pour placer cette pièce.';

  @override
  String get resultLoadError => 'Impossible de calculer cette liste de coupe.';

  @override
  String get resultValidationError =>
      'Vérifiez les barres, les pièces et les paramètres de coupe avant le calcul.';

  @override
  String get stockTooShortAfterTrim =>
      'La barre est trop courte après éboutage.';

  @override
  String get validBuyStockRequired =>
      'Définissez une longueur de barre valide avant le calcul.';

  @override
  String get tooLongResultReason =>
      'Cette pièce dépasse la plus grande longueur de barre utilisable.';

  @override
  String get editCutSettings => 'Modifier les paramètres de coupe';

  @override
  String get units => 'Unités';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Millimètres';

  @override
  String get centimeters => 'Centimètres';

  @override
  String get meters => 'Mètres';

  @override
  String get feetAndInches => 'Pieds et pouces';

  @override
  String get kerf => 'Trait de scie';

  @override
  String get kerfHelper => 'Matière retirée entre deux pièces successives.';

  @override
  String get kerfFinalPartHelper =>
      'Aucun trait de scie n\'est ajouté après la dernière pièce d\'une barre.';

  @override
  String get endTrimEachEnd => 'Éboutage (par extrémité)';

  @override
  String get endTrimHelper =>
      'Retirez cette longueur à chaque extrémité de chaque barre.';

  @override
  String get reusableLeftover => 'Chute réutilisable';

  @override
  String get reusableLeftoverHelper =>
      'Les chutes de cette longueur ou plus sont comptées comme réutilisables.';

  @override
  String get cutSettingsSaveError =>
      'Impossible d\'enregistrer les paramètres de coupe. Réessayez.';

  @override
  String get noUsableStockAfterTrim =>
      'Aucune longueur utilisable ne reste après éboutage.';

  @override
  String get someStockUnusableAfterTrim =>
      'Certaines barres sont trop courtes après éboutage.';

  @override
  String get nonnegativeLengthInvalid =>
      'Saisissez un nombre supérieur ou égal à zéro.';

  @override
  String get nonnegativeImperialInvalid =>
      'Saisissez des entiers positifs ou nuls et une fraction.';

  @override
  String get share => 'Partager';

  @override
  String get shareCutPlan => 'Partager le plan de coupe';

  @override
  String get shareText => 'Partager le texte';

  @override
  String get sharePdf => 'Partager le PDF';

  @override
  String get copyBuyList => 'Copier la liste d\'achat';

  @override
  String get buyListCopied => 'Liste d\'achat copiée';

  @override
  String get creatingPdf => 'Création du PDF…';

  @override
  String get pdfCreateError => 'Impossible de créer le PDF. Réessayez.';

  @override
  String get shareError =>
      'Impossible de partager le plan de coupe. Réessayez.';

  @override
  String get buyListCopyError =>
      'Impossible de copier la liste d\'achat. Réessayez.';

  @override
  String get reportSummary => 'Résumé';

  @override
  String get reportPurchase => 'Achat';

  @override
  String get generatedLabel => 'Généré';

  @override
  String generatedBy(String appName) {
    return 'Généré par $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Les plans de coupe sont des aides à la préparation. Vérifiez chaque mesure sur la barre avant de couper et respectez les consignes de sécurité des outils.';

  @override
  String get reportFileFallback => 'Plan de coupe';

  @override
  String get addLeftoversToStock => 'Ajouter les chutes au stock';

  @override
  String get addLeftoversTitle => 'Ajouter les chutes au stock ?';

  @override
  String get addLeftoversMessage =>
      'Ces chutes réutilisables seront ajoutées au stock de ce projet pour les futurs plans de coupe.';

  @override
  String get addLeftoversFutureHint =>
      'Ajoutez-les une fois les coupes terminées.';

  @override
  String get addToStock => 'Ajouter au stock';

  @override
  String get leftoversAddedToStock =>
      'Chutes réutilisables ajoutées au stock pour les futurs plans de coupe.';

  @override
  String get leftoversAddError =>
      'Impossible d\'ajouter les chutes au stock. Réessayez.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chutes réutilisables',
      one: '1 chute réutilisable',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Enregistrer et en ajouter une autre';

  @override
  String get defaultsSectionTitle => 'Valeurs par défaut';

  @override
  String get appearanceSectionTitle => 'Apparence';

  @override
  String get defaultReusableLeftover => 'Chute réutilisable par défaut';

  @override
  String get newProjectsDefaultsHelper =>
      'Ces valeurs sont utilisées pour les nouvelles listes de coupe. Les listes existantes ne changent pas.';

  @override
  String get defaultReusableHelper =>
      'Dans les nouveaux projets, les chutes de cette longueur ou plus sont réutilisables.';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get settingsSaveError =>
      'Impossible d\'enregistrer les paramètres. Réessayez.';

  @override
  String get settingsLoadError => 'Impossible de charger les paramètres.';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get language => 'Langue';

  @override
  String get languageSystem => 'Langue du système';

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
  String get upgradeOnce => 'Un seul achat. À vous pour toujours.';

  @override
  String get noSubscription => 'Sans abonnement.';

  @override
  String get lifetimePro => 'Pro à vie';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String unlockLifetimePro(String price) {
    return 'Débloquer Pro à vie — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Supprimer les publicités — $price';
  }

  @override
  String get proActive => 'Pro à vie activé';

  @override
  String get adFreeActive => 'Sans publicité';

  @override
  String get includedWithPro => 'Inclus dans Pro à vie';

  @override
  String get removeAdsDescription =>
      'Conservez les fonctions gratuites sans publicité.';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get restoringPurchases => 'Restauration des achats…';

  @override
  String get purchasesRestored => 'Achats restaurés';

  @override
  String get lifetimeProRestored => 'Pro à vie restauré';

  @override
  String get adFreeRestored => 'Version sans publicité restaurée';

  @override
  String get nothingToRestore => 'Aucun achat à restaurer';

  @override
  String get purchasePending => 'Achat en attente';

  @override
  String get purchasePendingMessage =>
      'Votre achat attend la validation du paiement par Google Play.';

  @override
  String get purchaseError => 'Impossible de terminer l\'achat. Réessayez.';

  @override
  String get restoreError => 'Impossible de restaurer les achats. Réessayez.';

  @override
  String get billingUnavailable =>
      'Les achats sont actuellement indisponibles.';

  @override
  String get productUnavailable => 'Temporairement indisponible.';

  @override
  String get processingPurchase => 'Vérification de l\'achat…';

  @override
  String get purchaseVerified => 'Achat vérifié';

  @override
  String get kerfPlanFree => 'KerfPlan Gratuit';

  @override
  String get viewPro => 'Voir Pro';

  @override
  String get upgrade => 'Passer à Pro';

  @override
  String get benefitUnlimitedProjects => 'Listes de coupe illimitées';

  @override
  String get benefitMultipleStocks => 'Plusieurs longueurs de barre';

  @override
  String get benefitPdf => 'Export PDF pour l\'atelier';

  @override
  String get benefitReuseLeftovers => 'Réutiliser les chutes';

  @override
  String get benefitNoAds => 'Sans publicité';

  @override
  String get onboardingIntro =>
      'Planifiez vos découpes linéaires avec moins de chutes.';

  @override
  String get howDoYouMeasure => 'Quel système de mesure utilisez-vous ?';

  @override
  String get metric => 'Métrique';

  @override
  String get imperial => 'Impérial';

  @override
  String get metricDescription => 'Millimètres, centimètres et mètres';

  @override
  String get imperialDescription => 'Pouces et pieds';

  @override
  String get recommendedForRegion => 'Recommandé pour votre région';

  @override
  String get continueAction => 'Continuer';

  @override
  String get measurementCanChangeLater =>
      'Vous pourrez modifier ce choix dans les paramètres.';

  @override
  String get measurements => 'Mesures';

  @override
  String get measurementSystem => 'Système de mesure';

  @override
  String get commonLengths => 'Longueurs courantes';
}
