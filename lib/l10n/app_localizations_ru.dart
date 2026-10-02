// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get newCutList => 'Новый список распила';

  @override
  String get noProjectsTitle => 'Списков распила пока нет';

  @override
  String get noProjectsMessage =>
      'Спланируйте первую работу меньше чем за минуту.';

  @override
  String get appVersionLabel => 'Версия приложения';

  @override
  String get defaultUnits => 'Единицы по умолчанию';

  @override
  String get defaultKerf => 'Ширина пропила по умолчанию';

  @override
  String get theme => 'Тема';

  @override
  String get newProjectTitle => 'Новый список распила';

  @override
  String get projectNameLabel => 'Название проекта';

  @override
  String get projectNameHint => 'Каркас гаража';

  @override
  String get materialLabel => 'Материал';

  @override
  String get materialHint => 'Сталь 40x20';

  @override
  String get noteLabel => 'Заметка';

  @override
  String get noteHint => 'Южная стена';

  @override
  String get createCutList => 'Создать список распила';

  @override
  String get save => 'Сохранить';

  @override
  String get editDetails => 'Изменить сведения';

  @override
  String get duplicate => 'Дублировать';

  @override
  String get copyLabel => 'Копия';

  @override
  String get delete => 'Удалить';

  @override
  String get deleteProjectTitle => 'Удалить список распила?';

  @override
  String deleteProjectMessage(String projectName) {
    return '«$projectName» будет навсегда удалён с этого устройства.';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get projectDeleted => 'Список распила удалён';

  @override
  String projectActions(String projectName) {
    return 'Действия для $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Обновлено: $date';
  }

  @override
  String get stockSectionTitle => 'Заготовки';

  @override
  String get noStockYet => 'Заготовки пока не добавлены.';

  @override
  String get partsSectionTitle => 'Детали';

  @override
  String get noPartsYet => 'Детали пока не добавлены.';

  @override
  String get cutSettingsSectionTitle => 'Настройки резки';

  @override
  String get calculate => 'Рассчитать';

  @override
  String get calculateDisabledHint =>
      'Добавьте детали, чтобы рассчитать план распила.';

  @override
  String get projectNotFound => 'Список распила не найден';

  @override
  String get backToProjects => 'К спискам распила';

  @override
  String get projectNameRequired => 'Введите название проекта.';

  @override
  String get projectNameTooLong => 'Название проекта — не более 80 символов.';

  @override
  String get materialTooLong => 'Материал — не более 120 символов.';

  @override
  String get noteTooLong => 'Заметка — не более 500 символов.';

  @override
  String get projectSaveError =>
      'Не удалось сохранить список распила. Попробуйте ещё раз.';

  @override
  String get projectDeleteError =>
      'Не удалось удалить список распила. Попробуйте ещё раз.';

  @override
  String get projectDuplicateError =>
      'Не удалось дублировать список распила. Попробуйте ещё раз.';

  @override
  String get projectsLoadError => 'Не удалось загрузить списки распила.';

  @override
  String get projectLoadError => 'Не удалось загрузить этот список распила.';

  @override
  String get retry => 'Повторить';

  @override
  String get fixedInventory => 'Свои заготовки';

  @override
  String get buyStock => 'Купить заготовки';

  @override
  String get addStockLength => 'Добавить длину заготовки';

  @override
  String get editStockLength => 'Изменить длину заготовки';

  @override
  String get stockLength => 'Длина';

  @override
  String get quantity => 'Количество';

  @override
  String get labelOptional => 'Метка (необязательно)';

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
  String get stockLengthRequired => 'Введите длину.';

  @override
  String get stockLengthInvalid => 'Введите число больше нуля.';

  @override
  String get stockLengthPrecision =>
      'Это значение нельзя сохранить точно. Используйте длину, кратную 0,0001 мм.';

  @override
  String get stockLengthTooLarge => 'Слишком большая длина.';

  @override
  String get quantityRequired => 'Введите количество.';

  @override
  String get quantityInvalid => 'Введите целое число от 1 до 9999.';

  @override
  String get quantityTooLarge => 'Количество не должно превышать 9999.';

  @override
  String get stockLabelTooLong => 'Метка — не более 80 символов.';

  @override
  String get saveStock => 'Сохранить заготовку';

  @override
  String get stockSaveError =>
      'Не удалось сохранить заготовку. Попробуйте ещё раз.';

  @override
  String get stockDeleteError =>
      'Не удалось удалить заготовку. Попробуйте ещё раз.';

  @override
  String get stockDuplicateError =>
      'Не удалось дублировать заготовку. Попробуйте ещё раз.';

  @override
  String get stockLoadError => 'Не удалось загрузить заготовки.';

  @override
  String get stockNotFound => 'Заготовка не найдена';

  @override
  String get deleteStockTitle => 'Удалить заготовку?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity будет удалено из этого списка распила.';
  }

  @override
  String get stockDeleted => 'Заготовка удалена';

  @override
  String get duplicateStock => 'Дублировать заготовку';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count длины заготовки',
      many: '$count длин заготовок',
      few: '$count длины заготовок',
      one: '$count длина заготовки',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Всего $count штуки',
      many: 'Всего $count штук',
      few: 'Всего $count штуки',
      one: 'Всего $count штука',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Задать длину заготовки';

  @override
  String get buyStockHelper => 'Рассчитаем, сколько заготовок нужно купить.';

  @override
  String get buyStockLengthMissing =>
      'Укажите длину заготовки, которую планируете купить.';

  @override
  String get stockModeSaveError =>
      'Не удалось сменить режим заготовок. Попробуйте ещё раз.';

  @override
  String get backToProject => 'К списку распила';

  @override
  String get decreaseQuantity => 'Уменьшить количество';

  @override
  String get increaseQuantity => 'Увеличить количество';

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
    return 'Действия для $length';
  }

  @override
  String get decimalInchesHelper => 'Введите дюймы десятичным числом.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Точное сохранённое значение: $value мм. Значение в дюймах приблизительное. Длина останется точной, пока вы её не измените.';
  }

  @override
  String get addPart => 'Добавить деталь';

  @override
  String get editPart => 'Изменить деталь';

  @override
  String get partNameOptional => 'Название детали (необязательно)';

  @override
  String get partNameHint => 'Стойка';

  @override
  String get partNameTooLong => 'Название детали — не более 100 символов.';

  @override
  String get partSaveError =>
      'Не удалось сохранить деталь. Попробуйте ещё раз.';

  @override
  String get partDeleteError =>
      'Не удалось удалить деталь. Попробуйте ещё раз.';

  @override
  String get partDuplicateError =>
      'Не удалось дублировать деталь. Попробуйте ещё раз.';

  @override
  String get partLoadError => 'Не удалось загрузить детали.';

  @override
  String get partNotFound => 'Деталь не найдена';

  @override
  String get deletePartTitle => 'Удалить деталь?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity будет удалено из этого списка распила.';
  }

  @override
  String get partDeleted => 'Деталь удалена';

  @override
  String get duplicatePart => 'Дублировать деталь';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count позиции деталей',
      many: '$count позиций деталей',
      few: '$count позиции деталей',
      one: '$count позиция деталей',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Футы';

  @override
  String get inches => 'Дюймы';

  @override
  String get wholeInches => 'Целые дюймы';

  @override
  String get fraction => 'Дробь';

  @override
  String get inchesRange =>
      'Укажите от 0 до 11 дюймов. Дополнительные футы введите в поле «Футы».';

  @override
  String get imperialLengthInvalid =>
      'Введите неотрицательные целые числа и дробь, чтобы итог был больше нуля.';

  @override
  String partTooLongWarning(String length) {
    return 'Эта деталь длиннее самой длинной пригодной заготовки ($length).';
  }

  @override
  String get addStockToContinue => 'Добавьте заготовки, чтобы продолжить.';

  @override
  String get cutPlanUnavailable => 'План распила пока недоступен.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'План распила';

  @override
  String get calculating => 'Расчёт…';

  @override
  String get recalculate => 'Пересчитать';

  @override
  String get editCutList => 'Изменить список распила';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Использовано $count заготовки',
      many: 'Использовано $count заготовок',
      few: 'Использовано $count заготовки',
      one: 'Использована $count заготовка',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Купить $count заготовки',
      many: 'Купить $count заготовок',
      few: 'Купить $count заготовки',
      one: 'Купить $count заготовку',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Купить $length × $count';
  }

  @override
  String get requestedParts => 'Требуется деталей';

  @override
  String get placedParts => 'Размещено деталей';

  @override
  String get unplacedParts => 'Не размещено деталей';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested детали',
      many: '$requested деталей',
      few: '$requested деталей',
      one: '$requested детали',
    );
    return 'Размещено $placed из $_temp0';
  }

  @override
  String get totalFinishedLength => 'Общая длина готовых деталей';

  @override
  String get totalStockUsed => 'Общая длина использованных заготовок';

  @override
  String get totalWaste => 'Общие отходы';

  @override
  String wastePercentage(String value) {
    return 'Отходы: $value%';
  }

  @override
  String get reusableLeftovers => 'Пригодные остатки';

  @override
  String get scrap => 'Обрезки';

  @override
  String get kerfLoss => 'Потери на пропил';

  @override
  String get trimLoss => 'Потери на торцовку';

  @override
  String get reusable => 'Пригоден';

  @override
  String get leftover => 'Остаток';

  @override
  String reusableExplanation(String threshold) {
    return 'Пригодны: концевые остатки не короче $threshold. Обрезки включают пропил, торцовку и более короткие остатки.';
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
      other: '$count детали',
      many: '$count деталей',
      few: '$count детали',
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
    return 'Торцовка: $length с каждого конца';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Заготовка $number, $length, $parts, остаток $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Не размещено деталей ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Для этой детали не осталось достаточно заготовок.';

  @override
  String get resultLoadError => 'Не удалось рассчитать этот список распила.';

  @override
  String get resultValidationError =>
      'Перед расчётом проверьте заготовки, детали и настройки резки.';

  @override
  String get stockTooShortAfterTrim =>
      'Заготовка слишком короткая после торцовки.';

  @override
  String get validBuyStockRequired =>
      'Перед расчётом укажите подходящую длину заготовки.';

  @override
  String get tooLongResultReason =>
      'Эта деталь длиннее самой длинной пригодной заготовки.';

  @override
  String get editCutSettings => 'Изменить настройки резки';

  @override
  String get units => 'Единицы';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Миллиметры';

  @override
  String get centimeters => 'Сантиметры';

  @override
  String get meters => 'Метры';

  @override
  String get feetAndInches => 'Футы и дюймы';

  @override
  String get kerf => 'Ширина пропила';

  @override
  String get kerfHelper => 'Материал, удаляемый между соседними деталями.';

  @override
  String get kerfFinalPartHelper =>
      'После последней детали на заготовке пропил не добавляется.';

  @override
  String get endTrimEachEnd => 'Торцовка (с каждого конца)';

  @override
  String get endTrimHelper =>
      'Срежьте эту длину с каждого конца каждой заготовки.';

  @override
  String get reusableLeftover => 'Пригодный остаток';

  @override
  String get reusableLeftoverHelper =>
      'Остатки такой длины и длиннее считаются пригодными.';

  @override
  String get cutSettingsSaveError =>
      'Не удалось сохранить настройки резки. Попробуйте ещё раз.';

  @override
  String get noUsableStockAfterTrim =>
      'После торцовки не остаётся пригодной длины заготовки.';

  @override
  String get someStockUnusableAfterTrim =>
      'Некоторые заготовки слишком короткие после торцовки.';

  @override
  String get nonnegativeLengthInvalid => 'Введите число не меньше нуля.';

  @override
  String get nonnegativeImperialInvalid =>
      'Введите неотрицательные целые числа и дробь.';

  @override
  String get share => 'Поделиться';

  @override
  String get shareCutPlan => 'Поделиться планом распила';

  @override
  String get shareText => 'Поделиться текстом';

  @override
  String get sharePdf => 'Поделиться PDF';

  @override
  String get copyBuyList => 'Скопировать список покупок';

  @override
  String get buyListCopied => 'Список покупок скопирован';

  @override
  String get creatingPdf => 'Создание PDF…';

  @override
  String get pdfCreateError => 'Не удалось создать PDF. Попробуйте ещё раз.';

  @override
  String get shareError =>
      'Не удалось поделиться планом распила. Попробуйте ещё раз.';

  @override
  String get buyListCopyError =>
      'Не удалось скопировать список покупок. Попробуйте ещё раз.';

  @override
  String get reportSummary => 'Сводка';

  @override
  String get reportPurchase => 'Закупка';

  @override
  String get generatedLabel => 'Создано';

  @override
  String generatedBy(String appName) {
    return 'Создано в $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Планы распила помогают планировать работу. Перед резкой проверьте каждый размер на заготовке и соблюдайте правила безопасности при работе с инструментом.';

  @override
  String get reportFileFallback => 'План распила';

  @override
  String get addLeftoversToStock => 'Добавить остатки к заготовкам';

  @override
  String get addLeftoversTitle => 'Добавить остатки к заготовкам?';

  @override
  String get addLeftoversMessage =>
      'Эти пригодные остатки будут добавлены к запасу заготовок проекта для будущих планов распила.';

  @override
  String get addLeftoversFutureHint =>
      'Добавляйте их после выполнения распила.';

  @override
  String get addToStock => 'Добавить к заготовкам';

  @override
  String get leftoversAddedToStock =>
      'Пригодные остатки добавлены для будущих планов распила.';

  @override
  String get leftoversAddError =>
      'Не удалось добавить остатки. Попробуйте ещё раз.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пригодного остатка',
      many: '$count пригодных остатков',
      few: '$count пригодных остатка',
      one: '$count пригодный остаток',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Сохранить и добавить ещё';

  @override
  String get defaultsSectionTitle => 'Значения по умолчанию';

  @override
  String get appearanceSectionTitle => 'Оформление';

  @override
  String get defaultReusableLeftover =>
      'Размер пригодного остатка по умолчанию';

  @override
  String get newProjectsDefaultsHelper =>
      'Эти значения применяются к новым спискам распила. Существующие списки не изменятся.';

  @override
  String get defaultReusableHelper =>
      'В новых проектах остатки такой длины и длиннее считаются пригодными.';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get settingsSaveError =>
      'Не удалось сохранить настройки. Попробуйте ещё раз.';

  @override
  String get settingsLoadError => 'Не удалось загрузить настройки.';

  @override
  String get settingsSaved => 'Настройки сохранены';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Как в системе';

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
  String get upgradeOnce => 'Купите один раз. Пользуйтесь всегда.';

  @override
  String get noSubscription => 'Без подписки.';

  @override
  String get lifetimePro => 'Pro навсегда';

  @override
  String get removeAds => 'Убрать рекламу';

  @override
  String unlockLifetimePro(String price) {
    return 'Открыть Pro навсегда — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Убрать рекламу — $price';
  }

  @override
  String get proActive => 'Pro навсегда активен';

  @override
  String get adFreeActive => 'Без рекламы';

  @override
  String get includedWithPro => 'Входит в Pro навсегда';

  @override
  String get removeAdsDescription =>
      'Сохраните бесплатные функции и уберите рекламу.';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get restoringPurchases => 'Восстановление покупок…';

  @override
  String get purchasesRestored => 'Покупки восстановлены';

  @override
  String get lifetimeProRestored => 'Pro навсегда восстановлен';

  @override
  String get adFreeRestored => 'Режим без рекламы восстановлен';

  @override
  String get nothingToRestore => 'Нечего восстанавливать';

  @override
  String get purchasePending => 'Покупка ожидает оплаты';

  @override
  String get purchasePendingMessage =>
      'Google Play ещё обрабатывает оплату вашей покупки.';

  @override
  String get purchaseError =>
      'Не удалось завершить покупку. Попробуйте ещё раз.';

  @override
  String get restoreError =>
      'Не удалось восстановить покупки. Попробуйте ещё раз.';

  @override
  String get billingUnavailable => 'Покупки сейчас недоступны.';

  @override
  String get productUnavailable => 'Временно недоступно.';

  @override
  String get processingPurchase => 'Проверка покупки…';

  @override
  String get purchaseVerified => 'Покупка проверена';

  @override
  String get kerfPlanFree => 'KerfPlan Бесплатно';

  @override
  String get viewPro => 'Смотреть Pro';

  @override
  String get upgrade => 'Улучшить';

  @override
  String get benefitUnlimitedProjects => 'Списки распила без ограничений';

  @override
  String get benefitMultipleStocks => 'Несколько длин заготовок';

  @override
  String get benefitPdf => 'Экспорт PDF для мастерской';

  @override
  String get benefitReuseLeftovers => 'Повторное использование остатков';

  @override
  String get benefitNoAds => 'Без рекламы';

  @override
  String get onboardingIntro =>
      'Планируйте линейный раскрой с меньшими отходами.';

  @override
  String get howDoYouMeasure => 'В каких единицах вы измеряете?';

  @override
  String get metric => 'Метрическая';

  @override
  String get imperial => 'Имперская';

  @override
  String get metricDescription => 'Миллиметры, сантиметры и метры';

  @override
  String get imperialDescription => 'Дюймы и футы';

  @override
  String get recommendedForRegion => 'Рекомендуется для вашего региона';

  @override
  String get continueAction => 'Продолжить';

  @override
  String get measurementCanChangeLater =>
      'Позже это можно изменить в настройках.';

  @override
  String get measurements => 'Измерения';

  @override
  String get measurementSystem => 'Система измерения';

  @override
  String get commonLengths => 'Типовые длины';
}
