// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get newCutList => 'Yeni kesim listesi';

  @override
  String get noProjectsTitle => 'Henüz kesim listesi yok';

  @override
  String get noProjectsMessage =>
      'İlk işinizi bir dakikadan kısa sürede planlayın.';

  @override
  String get appVersionLabel => 'Uygulama sürümü';

  @override
  String get defaultUnits => 'Varsayılan birimler';

  @override
  String get defaultKerf => 'Varsayılan kesim payı';

  @override
  String get theme => 'Tema';

  @override
  String get newProjectTitle => 'Yeni kesim listesi';

  @override
  String get projectNameLabel => 'Proje adı';

  @override
  String get projectNameHint => 'Garaj çerçevesi';

  @override
  String get materialLabel => 'Malzeme';

  @override
  String get materialHint => '40x20 çelik';

  @override
  String get noteLabel => 'Not';

  @override
  String get noteHint => 'Güney duvarı';

  @override
  String get createCutList => 'Kesim listesi oluştur';

  @override
  String get save => 'Kaydet';

  @override
  String get editDetails => 'Ayrıntıları düzenle';

  @override
  String get duplicate => 'Çoğalt';

  @override
  String get copyLabel => 'Kopya';

  @override
  String get delete => 'Sil';

  @override
  String get deleteProjectTitle => 'Kesim listesi silinsin mi?';

  @override
  String deleteProjectMessage(String projectName) {
    return '“$projectName” bu cihazdan kalıcı olarak silinecek.';
  }

  @override
  String get cancel => 'İptal';

  @override
  String get projectDeleted => 'Kesim listesi silindi';

  @override
  String projectActions(String projectName) {
    return '$projectName için işlemler';
  }

  @override
  String updatedLabel(String date) {
    return 'Güncellendi: $date';
  }

  @override
  String get stockSectionTitle => 'Stok malzeme';

  @override
  String get noStockYet => 'Henüz stok uzunluğu eklenmedi.';

  @override
  String get partsSectionTitle => 'Parçalar';

  @override
  String get noPartsYet => 'Henüz parça eklenmedi.';

  @override
  String get cutSettingsSectionTitle => 'Kesim ayarları';

  @override
  String get calculate => 'Hesapla';

  @override
  String get calculateDisabledHint =>
      'Kesim planı hesaplamak için parça ekleyin.';

  @override
  String get projectNotFound => 'Kesim listesi bulunamadı';

  @override
  String get backToProjects => 'Listelere dön';

  @override
  String get projectNameRequired => 'Proje adı girin.';

  @override
  String get projectNameTooLong => 'Proje adı en fazla 80 karakter olabilir.';

  @override
  String get materialTooLong => 'Malzeme en fazla 120 karakter olabilir.';

  @override
  String get noteTooLong => 'Not en fazla 500 karakter olabilir.';

  @override
  String get projectSaveError => 'Kesim listesi kaydedilemedi. Tekrar deneyin.';

  @override
  String get projectDeleteError => 'Kesim listesi silinemedi. Tekrar deneyin.';

  @override
  String get projectDuplicateError =>
      'Kesim listesi çoğaltılamadı. Tekrar deneyin.';

  @override
  String get projectsLoadError => 'Kesim listeleriniz yüklenemedi.';

  @override
  String get projectLoadError => 'Bu kesim listesi yüklenemedi.';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get fixedInventory => 'Mevcut stok';

  @override
  String get buyStock => 'Malzeme satın al';

  @override
  String get addStockLength => 'Stok uzunluğu ekle';

  @override
  String get editStockLength => 'Stok uzunluğunu düzenle';

  @override
  String get stockLength => 'Uzunluk';

  @override
  String get quantity => 'Adet';

  @override
  String get labelOptional => 'Etiket (isteğe bağlı)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Depo';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Uzunluk girin.';

  @override
  String get stockLengthInvalid => 'Sıfırdan büyük bir sayı girin.';

  @override
  String get stockLengthPrecision =>
      'Bu değer tam olarak kaydedilemiyor. 0,0001 mm\'nin katı olan bir uzunluk kullanın.';

  @override
  String get stockLengthTooLarge => 'Bu uzunluk çok büyük.';

  @override
  String get quantityRequired => 'Adet girin.';

  @override
  String get quantityInvalid => '1 ile 9999 arasında bir tam sayı girin.';

  @override
  String get quantityTooLarge => 'Adet en fazla 9999 olabilir.';

  @override
  String get stockLabelTooLong => 'Etiket en fazla 80 karakter olabilir.';

  @override
  String get saveStock => 'Stok uzunluğunu kaydet';

  @override
  String get stockSaveError =>
      'Bu stok uzunluğu kaydedilemedi. Tekrar deneyin.';

  @override
  String get stockDeleteError => 'Bu stok uzunluğu silinemedi. Tekrar deneyin.';

  @override
  String get stockDuplicateError =>
      'Bu stok uzunluğu çoğaltılamadı. Tekrar deneyin.';

  @override
  String get stockLoadError => 'Stok yüklenemedi.';

  @override
  String get stockNotFound => 'Stok uzunluğu bulunamadı';

  @override
  String get deleteStockTitle => 'Stok uzunluğu silinsin mi?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity bu kesim listesinden kaldırılacak.';
  }

  @override
  String get stockDeleted => 'Stok uzunluğu silindi';

  @override
  String get duplicateStock => 'Stok uzunluğunu çoğalt';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stok uzunluğu',
      one: '$count stok uzunluğu',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toplam $count adet',
      one: 'Toplam $count adet',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Stok uzunluğunu belirle';

  @override
  String get buyStockHelper =>
      'Kaç adet satın almanız gerektiğini hesaplayacağız.';

  @override
  String get buyStockLengthMissing =>
      'Satın almayı planladığınız stok uzunluğunu belirleyin.';

  @override
  String get stockModeSaveError => 'Stok modu değiştirilemedi. Tekrar deneyin.';

  @override
  String get backToProject => 'Kesim listesine dön';

  @override
  String get decreaseQuantity => 'Adedi azalt';

  @override
  String get increaseQuantity => 'Adedi artır';

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
    return '$length için işlemler';
  }

  @override
  String get decimalInchesHelper => 'Ondalıklı inç değeri girin.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Tam kayıtlı değer: $value mm. İnç gösterimi yaklaşık değerdir. Düzenlemediğiniz sürece kayıtlı uzunluk tam olarak korunur.';
  }

  @override
  String get addPart => 'Parça ekle';

  @override
  String get editPart => 'Parçayı düzenle';

  @override
  String get partNameOptional => 'Parça adı (isteğe bağlı)';

  @override
  String get partNameHint => 'Dikme';

  @override
  String get partNameTooLong => 'Parça adı en fazla 100 karakter olabilir.';

  @override
  String get partSaveError => 'Bu parça kaydedilemedi. Tekrar deneyin.';

  @override
  String get partDeleteError => 'Bu parça silinemedi. Tekrar deneyin.';

  @override
  String get partDuplicateError => 'Bu parça çoğaltılamadı. Tekrar deneyin.';

  @override
  String get partLoadError => 'Parçalar yüklenemedi.';

  @override
  String get partNotFound => 'Parça bulunamadı';

  @override
  String get deletePartTitle => 'Parça silinsin mi?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity bu kesim listesinden kaldırılacak.';
  }

  @override
  String get partDeleted => 'Parça silindi';

  @override
  String get duplicatePart => 'Parçayı çoğalt';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parça satırı',
      one: '$count parça satırı',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Fit';

  @override
  String get inches => 'İnç';

  @override
  String get wholeInches => 'Tam inç';

  @override
  String get fraction => 'Kesir';

  @override
  String get inchesRange =>
      '0 ile 11 inç kullanın. Fazla fit değerini Fit alanına girin.';

  @override
  String get imperialLengthInvalid =>
      'Toplamı sıfırdan büyük olacak şekilde negatif olmayan tam sayılar ve bir kesir girin.';

  @override
  String partTooLongWarning(String length) {
    return 'Bu parça kullanılabilir en uzun stoktan ($length) daha uzun.';
  }

  @override
  String get addStockToContinue => 'Devam etmek için stok ekleyin.';

  @override
  String get cutPlanUnavailable => 'Kesim planı henüz kullanılamıyor.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Kesim planı';

  @override
  String get calculating => 'Hesaplanıyor…';

  @override
  String get recalculate => 'Yeniden hesapla';

  @override
  String get editCutList => 'Kesim listesini düzenle';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stok parçası kullanıldı',
      one: '$count stok parçası kullanıldı',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Satın alınacak $count stok parçası',
      one: 'Satın alınacak $count stok parçası',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Satın al: $length × $count';
  }

  @override
  String get requestedParts => 'İstenen parçalar';

  @override
  String get placedParts => 'Yerleştirilen parçalar';

  @override
  String get unplacedParts => 'Yerleştirilemeyen parçalar';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested parçadan',
      one: '$requested parçadan',
    );
    return '$_temp0 $placed tanesi yerleştirildi';
  }

  @override
  String get totalFinishedLength => 'Bitmiş parçaların toplam uzunluğu';

  @override
  String get totalStockUsed => 'Kullanılan toplam stok uzunluğu';

  @override
  String get totalWaste => 'Toplam fire';

  @override
  String wastePercentage(String value) {
    return 'Fire: %$value';
  }

  @override
  String get reusableLeftovers => 'Yeniden kullanılabilir artıklar';

  @override
  String get scrap => 'Hurda';

  @override
  String get kerfLoss => 'Kesim payı kaybı';

  @override
  String get trimLoss => 'Uç kırpma kaybı';

  @override
  String get reusable => 'Yeniden kullanılabilir';

  @override
  String get leftover => 'Artık';

  @override
  String reusableExplanation(String threshold) {
    return 'Yeniden kullanılabilir: en az $threshold uzunluğundaki uç artıklar. Hurda; kesim payı, uç kırpma ve kısa artıkları içerir.';
  }

  @override
  String resultMetric(String label, String value) {
    return '$label: $value';
  }

  @override
  String barTitle(int number, String length) {
    return 'Çubuk $number · $length';
  }

  @override
  String partsOnBar(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parça',
      one: '$count parça',
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
    return 'Uç kırpma: her uçtan $length';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Stok çubuğu $number, $length, $parts, artık $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Yerleştirilemeyen parçalar ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Bu parça için yeterli stok kalmadı.';

  @override
  String get resultLoadError => 'Bu kesim listesi hesaplanamadı.';

  @override
  String get resultValidationError =>
      'Hesaplamadan önce stok, parçalar ve kesim ayarlarını kontrol edin.';

  @override
  String get stockTooShortAfterTrim =>
      'Uç kırpma sonrası stok çok kısa kalıyor.';

  @override
  String get validBuyStockRequired =>
      'Hesaplamadan önce geçerli bir stok uzunluğu belirleyin.';

  @override
  String get tooLongResultReason =>
      'Bu parça kullanılabilir en uzun stoktan daha uzun.';

  @override
  String get editCutSettings => 'Kesim ayarlarını düzenle';

  @override
  String get units => 'Birimler';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Milimetre';

  @override
  String get centimeters => 'Santimetre';

  @override
  String get meters => 'Metre';

  @override
  String get feetAndInches => 'Fit ve inç';

  @override
  String get kerf => 'Kesim payı';

  @override
  String get kerfHelper =>
      'Ardışık parçalar arasında kesilerek kaybolan malzeme.';

  @override
  String get kerfFinalPartHelper =>
      'Çubuktaki son parçadan sonra kesim payı eklenmez.';

  @override
  String get endTrimEachEnd => 'Uç kırpma (her uçtan)';

  @override
  String get endTrimHelper =>
      'Her stok çubuğunun iki ucundan da bu uzunluğu kırpın.';

  @override
  String get reusableLeftover => 'Yeniden kullanılabilir artık';

  @override
  String get reusableLeftoverHelper =>
      'Bu uzunluk ve üzerindeki artıklar yeniden kullanılabilir sayılır.';

  @override
  String get cutSettingsSaveError =>
      'Kesim ayarları kaydedilemedi. Tekrar deneyin.';

  @override
  String get noUsableStockAfterTrim =>
      'Uç kırpma sonrası kullanılabilir stok uzunluğu kalmıyor.';

  @override
  String get someStockUnusableAfterTrim =>
      'Bazı stok çubukları uç kırpma sonrası çok kısa kalıyor.';

  @override
  String get nonnegativeLengthInvalid =>
      'Sıfır veya daha büyük bir sayı girin.';

  @override
  String get nonnegativeImperialInvalid =>
      'Negatif olmayan tam sayılar ve bir kesir girin.';

  @override
  String get share => 'Paylaş';

  @override
  String get shareCutPlan => 'Kesim planını paylaş';

  @override
  String get shareText => 'Metin olarak paylaş';

  @override
  String get sharePdf => 'PDF paylaş';

  @override
  String get copyBuyList => 'Alışveriş listesini kopyala';

  @override
  String get buyListCopied => 'Alışveriş listesi kopyalandı';

  @override
  String get creatingPdf => 'PDF oluşturuluyor…';

  @override
  String get pdfCreateError => 'PDF oluşturulamadı. Tekrar deneyin.';

  @override
  String get shareError => 'Kesim planı paylaşılamadı. Tekrar deneyin.';

  @override
  String get buyListCopyError =>
      'Alışveriş listesi kopyalanamadı. Tekrar deneyin.';

  @override
  String get reportSummary => 'Özet';

  @override
  String get reportPurchase => 'Satın alma';

  @override
  String get generatedLabel => 'Oluşturulma';

  @override
  String generatedBy(String appName) {
    return '$appName ile oluşturuldu';
  }

  @override
  String get verifyBeforeCutting =>
      'Kesim planları planlama yardımcısıdır. Kesmeden önce her ölçüyü malzeme üzerinde doğrulayın ve alet güvenliği kurallarına uyun.';

  @override
  String get reportFileFallback => 'Kesim planı';

  @override
  String get addLeftoversToStock => 'Artıkları stoka ekle';

  @override
  String get addLeftoversTitle => 'Artıklar stoka eklensin mi?';

  @override
  String get addLeftoversMessage =>
      'Bu yeniden kullanılabilir artıklar gelecekteki kesim planları için projenin mevcut stoğuna eklenecek.';

  @override
  String get addLeftoversFutureHint =>
      'Artıkları kesimleri tamamladıktan sonra ekleyin.';

  @override
  String get addToStock => 'Stoka ekle';

  @override
  String get leftoversAddedToStock =>
      'Yeniden kullanılabilir artıklar gelecekteki planlar için stoka eklendi.';

  @override
  String get leftoversAddError => 'Artıklar stoka eklenemedi. Tekrar deneyin.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yeniden kullanılabilir parça',
      one: '$count yeniden kullanılabilir parça',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Kaydet ve yenisini ekle';

  @override
  String get defaultsSectionTitle => 'Varsayılanlar';

  @override
  String get appearanceSectionTitle => 'Görünüm';

  @override
  String get defaultReusableLeftover =>
      'Varsayılan yeniden kullanılabilir artık';

  @override
  String get newProjectsDefaultsHelper =>
      'Bu değerler yeni kesim listelerinde kullanılır. Mevcut listeler değişmez.';

  @override
  String get defaultReusableHelper =>
      'Yeni projelerde bu uzunluk ve üzerindeki artıklar yeniden kullanılabilir sayılır.';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get settingsSaveError => 'Ayarlar kaydedilemedi. Tekrar deneyin.';

  @override
  String get settingsLoadError => 'Ayarlar yüklenemedi.';

  @override
  String get settingsSaved => 'Ayarlar kaydedildi';

  @override
  String get language => 'Dil';

  @override
  String get languageSystem => 'Sistem varsayılanı';

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
  String get upgradeOnce => 'Bir kez satın alın. Süresiz kullanın.';

  @override
  String get noSubscription => 'Abonelik yok.';

  @override
  String get lifetimePro => 'Ömür boyu Pro';

  @override
  String get removeAds => 'Reklamları kaldır';

  @override
  String unlockLifetimePro(String price) {
    return 'Ömür boyu Pro\'yu aç — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Reklamları kaldır — $price';
  }

  @override
  String get proActive => 'Ömür boyu Pro etkin';

  @override
  String get adFreeActive => 'Reklamsız';

  @override
  String get includedWithPro => 'Ömür boyu Pro\'ya dahil';

  @override
  String get removeAdsDescription =>
      'Ücretsiz özellikleri koruyun, reklamları kaldırın.';

  @override
  String get restorePurchases => 'Satın alımları geri yükle';

  @override
  String get restoringPurchases => 'Satın alımlar geri yükleniyor…';

  @override
  String get purchasesRestored => 'Satın alımlar geri yüklendi';

  @override
  String get lifetimeProRestored => 'Ömür boyu Pro geri yüklendi';

  @override
  String get adFreeRestored => 'Reklamsız sürüm geri yüklendi';

  @override
  String get nothingToRestore => 'Geri yüklenecek satın alım yok';

  @override
  String get purchasePending => 'Satın alım beklemede';

  @override
  String get purchasePendingMessage =>
      'Satın alımınızın ödemesi Google Play tarafından işlenmeyi bekliyor.';

  @override
  String get purchaseError => 'Satın alım tamamlanamadı. Tekrar deneyin.';

  @override
  String get restoreError => 'Satın alımlar geri yüklenemedi. Tekrar deneyin.';

  @override
  String get billingUnavailable => 'Satın alımlar şu anda kullanılamıyor.';

  @override
  String get productUnavailable => 'Geçici olarak kullanılamıyor.';

  @override
  String get processingPurchase => 'Satın alım doğrulanıyor…';

  @override
  String get purchaseVerified => 'Satın alım doğrulandı';

  @override
  String get kerfPlanFree => 'KerfPlan Ücretsiz';

  @override
  String get viewPro => 'Pro\'yu görüntüle';

  @override
  String get upgrade => 'Yükselt';

  @override
  String get benefitUnlimitedProjects => 'Sınırsız kesim listesi';

  @override
  String get benefitMultipleStocks => 'Birden çok stok uzunluğu';

  @override
  String get benefitPdf => 'Atölye için PDF dışa aktarma';

  @override
  String get benefitReuseLeftovers => 'Artıkları yeniden kullan';

  @override
  String get benefitNoAds => 'Reklam yok';

  @override
  String get onboardingIntro => 'Daha az fireyle doğrusal kesimleri planlayın.';

  @override
  String get howDoYouMeasure => 'Hangi ölçü sistemini kullanıyorsunuz?';

  @override
  String get metric => 'Metrik';

  @override
  String get imperial => 'İngiliz';

  @override
  String get metricDescription => 'Milimetre, santimetre ve metre';

  @override
  String get imperialDescription => 'İnç ve fit';

  @override
  String get recommendedForRegion => 'Bölgeniz için önerilir';

  @override
  String get continueAction => 'Devam et';

  @override
  String get measurementCanChangeLater =>
      'Bunu daha sonra Ayarlar bölümünden değiştirebilirsiniz.';

  @override
  String get measurements => 'Ölçüler';

  @override
  String get measurementSystem => 'Ölçü sistemi';

  @override
  String get commonLengths => 'Yaygın uzunluklar';
}
