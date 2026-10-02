// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Налаштування';

  @override
  String get newCutList => 'Новий список розкрою';

  @override
  String get noProjectsTitle => 'Списків розкрою ще немає';

  @override
  String get noProjectsMessage => 'Сплануйте першу роботу менш ніж за хвилину.';

  @override
  String get appVersionLabel => 'Версія застосунку';

  @override
  String get defaultUnits => 'Одиниці за замовчуванням';

  @override
  String get defaultKerf => 'Ширина пропилу за замовчуванням';

  @override
  String get theme => 'Тема';

  @override
  String get newProjectTitle => 'Новий список розкрою';

  @override
  String get projectNameLabel => 'Назва проєкту';

  @override
  String get projectNameHint => 'Каркас гаража';

  @override
  String get materialLabel => 'Матеріал';

  @override
  String get materialHint => 'Сталь 40x20';

  @override
  String get noteLabel => 'Нотатка';

  @override
  String get noteHint => 'Південна стіна';

  @override
  String get createCutList => 'Створити список розкрою';

  @override
  String get save => 'Зберегти';

  @override
  String get editDetails => 'Змінити відомості';

  @override
  String get duplicate => 'Дублювати';

  @override
  String get copyLabel => 'Копія';

  @override
  String get delete => 'Видалити';

  @override
  String get deleteProjectTitle => 'Видалити список розкрою?';

  @override
  String deleteProjectMessage(String projectName) {
    return '«$projectName» буде назавжди видалено з цього пристрою.';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get projectDeleted => 'Список розкрою видалено';

  @override
  String projectActions(String projectName) {
    return 'Дії для $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Оновлено: $date';
  }

  @override
  String get stockSectionTitle => 'Заготовки';

  @override
  String get noStockYet => 'Заготовок ще не додано.';

  @override
  String get partsSectionTitle => 'Деталі';

  @override
  String get noPartsYet => 'Деталей ще не додано.';

  @override
  String get cutSettingsSectionTitle => 'Налаштування різання';

  @override
  String get calculate => 'Розрахувати';

  @override
  String get calculateDisabledHint =>
      'Додайте деталі, щоб розрахувати план розкрою.';

  @override
  String get projectNotFound => 'Список розкрою не знайдено';

  @override
  String get backToProjects => 'До списків розкрою';

  @override
  String get projectNameRequired => 'Введіть назву проєкту.';

  @override
  String get projectNameTooLong => 'Назва проєкту — не більш ніж 80 символів.';

  @override
  String get materialTooLong => 'Матеріал — не більш ніж 120 символів.';

  @override
  String get noteTooLong => 'Нотатка — не більш ніж 500 символів.';

  @override
  String get projectSaveError =>
      'Не вдалося зберегти список розкрою. Спробуйте ще раз.';

  @override
  String get projectDeleteError =>
      'Не вдалося видалити список розкрою. Спробуйте ще раз.';

  @override
  String get projectDuplicateError =>
      'Не вдалося дублювати список розкрою. Спробуйте ще раз.';

  @override
  String get projectsLoadError => 'Не вдалося завантажити списки розкрою.';

  @override
  String get projectLoadError => 'Не вдалося завантажити цей список розкрою.';

  @override
  String get retry => 'Повторити';

  @override
  String get fixedInventory => 'Власні заготовки';

  @override
  String get buyStock => 'Купити заготовки';

  @override
  String get addStockLength => 'Додати довжину заготовки';

  @override
  String get editStockLength => 'Змінити довжину заготовки';

  @override
  String get stockLength => 'Довжина';

  @override
  String get quantity => 'Кількість';

  @override
  String get labelOptional => 'Позначка (необов\'язково)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Склад';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Введіть довжину.';

  @override
  String get stockLengthInvalid => 'Введіть число більше нуля.';

  @override
  String get stockLengthPrecision =>
      'Це значення неможливо зберегти точно. Використайте довжину, кратну 0,0001 мм.';

  @override
  String get stockLengthTooLarge => 'Надто велика довжина.';

  @override
  String get quantityRequired => 'Введіть кількість.';

  @override
  String get quantityInvalid => 'Введіть ціле число від 1 до 9999.';

  @override
  String get quantityTooLarge => 'Кількість не може перевищувати 9999.';

  @override
  String get stockLabelTooLong => 'Позначка — не більш ніж 80 символів.';

  @override
  String get saveStock => 'Зберегти заготовку';

  @override
  String get stockSaveError =>
      'Не вдалося зберегти заготовку. Спробуйте ще раз.';

  @override
  String get stockDeleteError =>
      'Не вдалося видалити заготовку. Спробуйте ще раз.';

  @override
  String get stockDuplicateError =>
      'Не вдалося дублювати заготовку. Спробуйте ще раз.';

  @override
  String get stockLoadError => 'Не вдалося завантажити заготовки.';

  @override
  String get stockNotFound => 'Заготовку не знайдено';

  @override
  String get deleteStockTitle => 'Видалити заготовку?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity буде видалено з цього списку розкрою.';
  }

  @override
  String get stockDeleted => 'Заготовку видалено';

  @override
  String get duplicateStock => 'Дублювати заготовку';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count довжини заготовки',
      many: '$count довжин заготовок',
      few: '$count довжини заготовок',
      one: '$count довжина заготовки',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Усього $count штуки',
      many: 'Усього $count штук',
      few: 'Усього $count штуки',
      one: 'Усього $count штука',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Задати довжину заготовки';

  @override
  String get buyStockHelper => 'Розрахуємо, скільки заготовок потрібно купити.';

  @override
  String get buyStockLengthMissing =>
      'Укажіть довжину заготовки, яку плануєте купити.';

  @override
  String get stockModeSaveError =>
      'Не вдалося змінити режим заготовок. Спробуйте ще раз.';

  @override
  String get backToProject => 'До списку розкрою';

  @override
  String get decreaseQuantity => 'Зменшити кількість';

  @override
  String get increaseQuantity => 'Збільшити кількість';

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
    return 'Дії для $length';
  }

  @override
  String get decimalInchesHelper => 'Введіть дюйми десятковим числом.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Точне збережене значення: $value мм. Значення в дюймах приблизне. Довжина залишиться точною, доки ви її не зміните.';
  }

  @override
  String get addPart => 'Додати деталь';

  @override
  String get editPart => 'Змінити деталь';

  @override
  String get partNameOptional => 'Назва деталі (необов\'язково)';

  @override
  String get partNameHint => 'Стійка';

  @override
  String get partNameTooLong => 'Назва деталі — не більш ніж 100 символів.';

  @override
  String get partSaveError => 'Не вдалося зберегти деталь. Спробуйте ще раз.';

  @override
  String get partDeleteError => 'Не вдалося видалити деталь. Спробуйте ще раз.';

  @override
  String get partDuplicateError =>
      'Не вдалося дублювати деталь. Спробуйте ще раз.';

  @override
  String get partLoadError => 'Не вдалося завантажити деталі.';

  @override
  String get partNotFound => 'Деталь не знайдено';

  @override
  String get deletePartTitle => 'Видалити деталь?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity буде видалено з цього списку розкрою.';
  }

  @override
  String get partDeleted => 'Деталь видалено';

  @override
  String get duplicatePart => 'Дублювати деталь';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиції деталей',
      many: '$count позицій деталей',
      few: '$count позиції деталей',
      one: '$count позиція деталей',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Фути';

  @override
  String get inches => 'Дюйми';

  @override
  String get wholeInches => 'Цілі дюйми';

  @override
  String get fraction => 'Дріб';

  @override
  String get inchesRange =>
      'Укажіть від 0 до 11 дюймів. Додаткові фути введіть у полі «Фути».';

  @override
  String get imperialLengthInvalid =>
      'Введіть невід\'ємні цілі числа й дріб, щоб результат був більшим за нуль.';

  @override
  String partTooLongWarning(String length) {
    return 'Ця деталь довша за найдовшу придатну заготовку ($length).';
  }

  @override
  String get addStockToContinue => 'Додайте заготовки, щоб продовжити.';

  @override
  String get cutPlanUnavailable => 'План розкрою поки недоступний.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'План розкрою';

  @override
  String get calculating => 'Розрахунок…';

  @override
  String get recalculate => 'Перерахувати';

  @override
  String get editCutList => 'Змінити список розкрою';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Використано $count заготовки',
      many: 'Використано $count заготовок',
      few: 'Використано $count заготовки',
      one: 'Використано $count заготовку',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Купити $count заготовки',
      many: 'Купити $count заготовок',
      few: 'Купити $count заготовки',
      one: 'Купити $count заготовку',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Купити $length × $count';
  }

  @override
  String get requestedParts => 'Потрібно деталей';

  @override
  String get placedParts => 'Розміщено деталей';

  @override
  String get unplacedParts => 'Не розміщено деталей';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested деталі',
      many: '$requested деталей',
      few: '$requested деталей',
      one: '$requested деталі',
    );
    return 'Розміщено $placed із $_temp0';
  }

  @override
  String get totalFinishedLength => 'Загальна довжина готових деталей';

  @override
  String get totalStockUsed => 'Загальна довжина використаних заготовок';

  @override
  String get totalWaste => 'Загальні відходи';

  @override
  String wastePercentage(String value) {
    return 'Відходи: $value%';
  }

  @override
  String get reusableLeftovers => 'Придатні залишки';

  @override
  String get scrap => 'Обрізки';

  @override
  String get kerfLoss => 'Втрати на пропил';

  @override
  String get trimLoss => 'Втрати на торцювання';

  @override
  String get reusable => 'Придатний';

  @override
  String get leftover => 'Залишок';

  @override
  String reusableExplanation(String threshold) {
    return 'Придатні: кінцеві залишки не коротші за $threshold. Обрізки включають пропил, торцювання та коротші залишки.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Заготовка $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count деталі',
      many: '$count деталей',
      few: '$count деталі',
      one: '$count деталь',
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
    return 'Торцювання: $length з кожного кінця';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Заготовка $number, $length, $parts, залишок $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Не розміщено деталей ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Для цієї деталі не залишилося достатньо заготовок.';

  @override
  String get resultLoadError => 'Не вдалося розрахувати цей список розкрою.';

  @override
  String get resultValidationError =>
      'Перед розрахунком перевірте заготовки, деталі й налаштування різання.';

  @override
  String get stockTooShortAfterTrim =>
      'Заготовка надто коротка після торцювання.';

  @override
  String get validBuyStockRequired =>
      'Перед розрахунком укажіть належну довжину заготовки.';

  @override
  String get tooLongResultReason =>
      'Ця деталь довша за найдовшу придатну заготовку.';

  @override
  String get editCutSettings => 'Змінити налаштування різання';

  @override
  String get units => 'Одиниці';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Міліметри';

  @override
  String get centimeters => 'Сантиметри';

  @override
  String get meters => 'Метри';

  @override
  String get feetAndInches => 'Фути й дюйми';

  @override
  String get kerf => 'Ширина пропилу';

  @override
  String get kerfHelper => 'Матеріал, що видаляється між сусідніми деталями.';

  @override
  String get kerfFinalPartHelper =>
      'Після останньої деталі на заготовці пропил не додається.';

  @override
  String get endTrimEachEnd => 'Торцювання (з кожного кінця)';

  @override
  String get endTrimHelper =>
      'Відріжте цю довжину з кожного кінця кожної заготовки.';

  @override
  String get reusableLeftover => 'Придатний залишок';

  @override
  String get reusableLeftoverHelper =>
      'Залишки такої довжини й довші вважаються придатними.';

  @override
  String get cutSettingsSaveError =>
      'Не вдалося зберегти налаштування різання. Спробуйте ще раз.';

  @override
  String get noUsableStockAfterTrim =>
      'Після торцювання не залишається придатної довжини заготовки.';

  @override
  String get someStockUnusableAfterTrim =>
      'Деякі заготовки надто короткі після торцювання.';

  @override
  String get nonnegativeLengthInvalid => 'Введіть число не менше нуля.';

  @override
  String get nonnegativeImperialInvalid =>
      'Введіть невід\'ємні цілі числа й дріб.';

  @override
  String get share => 'Поділитися';

  @override
  String get shareCutPlan => 'Поділитися планом розкрою';

  @override
  String get shareText => 'Поділитися текстом';

  @override
  String get sharePdf => 'Поділитися PDF';

  @override
  String get copyBuyList => 'Скопіювати список покупок';

  @override
  String get buyListCopied => 'Список покупок скопійовано';

  @override
  String get creatingPdf => 'Створення PDF…';

  @override
  String get pdfCreateError => 'Не вдалося створити PDF. Спробуйте ще раз.';

  @override
  String get shareError =>
      'Не вдалося поділитися планом розкрою. Спробуйте ще раз.';

  @override
  String get buyListCopyError =>
      'Не вдалося скопіювати список покупок. Спробуйте ще раз.';

  @override
  String get reportSummary => 'Підсумок';

  @override
  String get reportPurchase => 'Закупівля';

  @override
  String get generatedLabel => 'Створено';

  @override
  String generatedBy(String appName) {
    return 'Створено в $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Плани розкрою допомагають планувати роботу. Перед різанням перевірте кожен розмір на заготовці й дотримуйтеся правил безпеки під час роботи з інструментом.';

  @override
  String get reportFileFallback => 'План розкрою';

  @override
  String get addLeftoversToStock => 'Додати залишки до заготовок';

  @override
  String get addLeftoversTitle => 'Додати залишки до заготовок?';

  @override
  String get addLeftoversMessage =>
      'Ці придатні залишки буде додано до запасу заготовок проєкту для майбутніх планів розкрою.';

  @override
  String get addLeftoversFutureHint => 'Додавайте їх після завершення різання.';

  @override
  String get addToStock => 'Додати до заготовок';

  @override
  String get leftoversAddedToStock =>
      'Придатні залишки додано для майбутніх планів розкрою.';

  @override
  String get leftoversAddError =>
      'Не вдалося додати залишки. Спробуйте ще раз.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count придатного залишку',
      many: '$count придатних залишків',
      few: '$count придатні залишки',
      one: '$count придатний залишок',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Зберегти й додати ще';

  @override
  String get defaultsSectionTitle => 'Типові значення';

  @override
  String get appearanceSectionTitle => 'Вигляд';

  @override
  String get defaultReusableLeftover => 'Типовий розмір придатного залишку';

  @override
  String get newProjectsDefaultsHelper =>
      'Ці значення застосовуються до нових списків розкрою. Наявні списки не зміняться.';

  @override
  String get defaultReusableHelper =>
      'У нових проєктах залишки такої довжини й довші вважаються придатними.';

  @override
  String get themeSystem => 'Системна';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get settingsSaveError =>
      'Не вдалося зберегти налаштування. Спробуйте ще раз.';

  @override
  String get settingsLoadError => 'Не вдалося завантажити налаштування.';

  @override
  String get settingsSaved => 'Налаштування збережено';

  @override
  String get language => 'Мова';

  @override
  String get languageSystem => 'Як у системі';

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
  String get upgradeOnce => 'Придбайте один раз. Користуйтеся завжди.';

  @override
  String get noSubscription => 'Без передплати.';

  @override
  String get lifetimePro => 'Pro назавжди';

  @override
  String get removeAds => 'Прибрати рекламу';

  @override
  String unlockLifetimePro(String price) {
    return 'Відкрити Pro назавжди — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Прибрати рекламу — $price';
  }

  @override
  String get proActive => 'Pro назавжди активний';

  @override
  String get adFreeActive => 'Без реклами';

  @override
  String get includedWithPro => 'Входить до Pro назавжди';

  @override
  String get removeAdsDescription =>
      'Залиште безкоштовні функції та приберіть рекламу.';

  @override
  String get restorePurchases => 'Відновити покупки';

  @override
  String get restoringPurchases => 'Відновлення покупок…';

  @override
  String get purchasesRestored => 'Покупки відновлено';

  @override
  String get lifetimeProRestored => 'Pro назавжди відновлено';

  @override
  String get adFreeRestored => 'Режим без реклами відновлено';

  @override
  String get nothingToRestore => 'Немає покупок для відновлення';

  @override
  String get purchasePending => 'Покупка очікує оплати';

  @override
  String get purchasePendingMessage =>
      'Google Play ще обробляє оплату вашої покупки.';

  @override
  String get purchaseError => 'Не вдалося завершити покупку. Спробуйте ще раз.';

  @override
  String get restoreError => 'Не вдалося відновити покупки. Спробуйте ще раз.';

  @override
  String get billingUnavailable => 'Покупки зараз недоступні.';

  @override
  String get productUnavailable => 'Тимчасово недоступно.';

  @override
  String get processingPurchase => 'Перевірка покупки…';

  @override
  String get purchaseVerified => 'Покупку перевірено';

  @override
  String get kerfPlanFree => 'KerfPlan Безкоштовно';

  @override
  String get viewPro => 'Переглянути Pro';

  @override
  String get upgrade => 'Покращити';

  @override
  String get benefitUnlimitedProjects => 'Списки розкрою без обмежень';

  @override
  String get benefitMultipleStocks => 'Кілька довжин заготовок';

  @override
  String get benefitPdf => 'Експорт PDF для майстерні';

  @override
  String get benefitReuseLeftovers => 'Повторне використання залишків';

  @override
  String get benefitNoAds => 'Без реклами';

  @override
  String get onboardingIntro =>
      'Плануйте лінійний розкрій із меншими відходами.';

  @override
  String get howDoYouMeasure => 'У яких одиницях ви вимірюєте?';

  @override
  String get metric => 'Метрична';

  @override
  String get imperial => 'Імперська';

  @override
  String get metricDescription => 'Міліметри, сантиметри та метри';

  @override
  String get imperialDescription => 'Дюйми та фути';

  @override
  String get recommendedForRegion => 'Рекомендовано для вашого регіону';

  @override
  String get continueAction => 'Продовжити';

  @override
  String get measurementCanChangeLater =>
      'Пізніше це можна змінити в налаштуваннях.';

  @override
  String get measurements => 'Вимірювання';

  @override
  String get measurementSystem => 'Система вимірювання';

  @override
  String get commonLengths => 'Типові довжини';
}
