// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get newCutList => 'Nueva lista de cortes';

  @override
  String get noProjectsTitle => 'Aún no hay listas de cortes';

  @override
  String get noProjectsMessage =>
      'Planifica tu primer trabajo en menos de un minuto.';

  @override
  String get appVersionLabel => 'Versión de la aplicación';

  @override
  String get defaultUnits => 'Unidades predeterminadas';

  @override
  String get defaultKerf => 'Ancho de corte predeterminado';

  @override
  String get theme => 'Tema';

  @override
  String get newProjectTitle => 'Nueva lista de cortes';

  @override
  String get projectNameLabel => 'Nombre del proyecto';

  @override
  String get projectNameHint => 'Marco del garaje';

  @override
  String get materialLabel => 'Material';

  @override
  String get materialHint => 'Acero 40x20';

  @override
  String get noteLabel => 'Nota';

  @override
  String get noteHint => 'Pared sur';

  @override
  String get createCutList => 'Crear lista de cortes';

  @override
  String get save => 'Guardar';

  @override
  String get editDetails => 'Editar detalles';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get copyLabel => 'Copia';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteProjectTitle => '¿Eliminar lista de cortes?';

  @override
  String deleteProjectMessage(String projectName) {
    return 'Esto eliminará permanentemente «$projectName» de este dispositivo.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get projectDeleted => 'Lista de cortes eliminada';

  @override
  String projectActions(String projectName) {
    return 'Acciones para $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Actualizado: $date';
  }

  @override
  String get stockSectionTitle => 'Material disponible';

  @override
  String get noStockYet => 'Aún no se han añadido longitudes de material.';

  @override
  String get partsSectionTitle => 'Piezas';

  @override
  String get noPartsYet => 'Aún no se han añadido piezas.';

  @override
  String get cutSettingsSectionTitle => 'Ajustes de corte';

  @override
  String get calculate => 'Calcular';

  @override
  String get calculateDisabledHint =>
      'Añade piezas para calcular un plan de corte.';

  @override
  String get projectNotFound => 'No se encontró la lista de cortes';

  @override
  String get backToProjects => 'Volver a las listas';

  @override
  String get projectNameRequired => 'Introduce el nombre del proyecto.';

  @override
  String get projectNameTooLong =>
      'El nombre del proyecto debe tener 80 caracteres o menos.';

  @override
  String get materialTooLong =>
      'El material debe tener 120 caracteres o menos.';

  @override
  String get noteTooLong => 'La nota debe tener 500 caracteres o menos.';

  @override
  String get projectSaveError =>
      'No se pudo guardar la lista de cortes. Inténtalo de nuevo.';

  @override
  String get projectDeleteError =>
      'No se pudo eliminar la lista de cortes. Inténtalo de nuevo.';

  @override
  String get projectDuplicateError =>
      'No se pudo duplicar la lista de cortes. Inténtalo de nuevo.';

  @override
  String get projectsLoadError => 'No se pudieron cargar las listas de cortes.';

  @override
  String get projectLoadError => 'No se pudo cargar esta lista de cortes.';

  @override
  String get retry => 'Reintentar';

  @override
  String get fixedInventory => 'Existencias fijas';

  @override
  String get buyStock => 'Comprar material';

  @override
  String get addStockLength => 'Añadir longitud de material';

  @override
  String get editStockLength => 'Editar longitud de material';

  @override
  String get stockLength => 'Longitud';

  @override
  String get quantity => 'Cantidad';

  @override
  String get labelOptional => 'Etiqueta (opcional)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Almacén';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Introduce una longitud.';

  @override
  String get stockLengthInvalid => 'Introduce un número mayor que cero.';

  @override
  String get stockLengthPrecision =>
      'Este valor no se puede guardar exactamente. Usa una longitud múltiplo de 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Esta longitud es demasiado grande.';

  @override
  String get quantityRequired => 'Introduce una cantidad.';

  @override
  String get quantityInvalid => 'Introduce un número entero entre 1 y 9999.';

  @override
  String get quantityTooLarge => 'La cantidad debe ser 9999 o menos.';

  @override
  String get stockLabelTooLong =>
      'La etiqueta debe tener 80 caracteres o menos.';

  @override
  String get saveStock => 'Guardar longitud de material';

  @override
  String get stockSaveError =>
      'No se pudo guardar esta longitud de material. Inténtalo de nuevo.';

  @override
  String get stockDeleteError =>
      'No se pudo eliminar esta longitud de material. Inténtalo de nuevo.';

  @override
  String get stockDuplicateError =>
      'No se pudo duplicar esta longitud de material. Inténtalo de nuevo.';

  @override
  String get stockLoadError => 'No se pudo cargar el material disponible.';

  @override
  String get stockNotFound => 'No se encontró la longitud de material';

  @override
  String get deleteStockTitle => '¿Eliminar longitud de material?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return 'Se quitará $length × $quantity de esta lista de cortes.';
  }

  @override
  String get stockDeleted => 'Longitud de material eliminada';

  @override
  String get duplicateStock => 'Duplicar longitud de material';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count longitudes de material',
      one: '1 longitud de material',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count piezas en total',
      one: '1 pieza en total',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Definir longitud de material';

  @override
  String get buyStockHelper => 'Calcularemos cuántas piezas necesitas comprar.';

  @override
  String get buyStockLengthMissing =>
      'Indica la longitud del material que piensas comprar.';

  @override
  String get stockModeSaveError =>
      'No se pudo cambiar el modo de material. Inténtalo de nuevo.';

  @override
  String get backToProject => 'Volver a la lista de cortes';

  @override
  String get decreaseQuantity => 'Reducir cantidad';

  @override
  String get increaseQuantity => 'Aumentar cantidad';

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
    return 'Acciones para $length';
  }

  @override
  String get decimalInchesHelper => 'Introduce pulgadas decimales.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Guardado exactamente: $value mm. La medida en pulgadas es aproximada. La longitud guardada seguirá siendo exacta salvo que la edites.';
  }

  @override
  String get addPart => 'Añadir pieza';

  @override
  String get editPart => 'Editar pieza';

  @override
  String get partNameOptional => 'Nombre de la pieza (opcional)';

  @override
  String get partNameHint => 'Montante';

  @override
  String get partNameTooLong =>
      'El nombre de la pieza debe tener 100 caracteres o menos.';

  @override
  String get partSaveError =>
      'No se pudo guardar esta pieza. Inténtalo de nuevo.';

  @override
  String get partDeleteError =>
      'No se pudo eliminar esta pieza. Inténtalo de nuevo.';

  @override
  String get partDuplicateError =>
      'No se pudo duplicar esta pieza. Inténtalo de nuevo.';

  @override
  String get partLoadError => 'No se pudieron cargar las piezas.';

  @override
  String get partNotFound => 'No se encontró la pieza';

  @override
  String get deletePartTitle => '¿Eliminar pieza?';

  @override
  String deletePartMessage(String description, int quantity) {
    return 'Se quitará $description × $quantity de esta lista de cortes.';
  }

  @override
  String get partDeleted => 'Pieza eliminada';

  @override
  String get duplicatePart => 'Duplicar pieza';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count líneas de piezas',
      one: '1 línea de piezas',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Pies';

  @override
  String get inches => 'Pulgadas';

  @override
  String get wholeInches => 'Pulgadas enteras';

  @override
  String get fraction => 'Fracción';

  @override
  String get inchesRange =>
      'Usa entre 0 y 11 pulgadas. Introduce los pies adicionales en el campo Pies.';

  @override
  String get imperialLengthInvalid =>
      'Introduce números enteros no negativos y una fracción que sumen más de cero.';

  @override
  String partTooLongWarning(String length) {
    return 'Esta pieza supera la mayor longitud útil de material ($length).';
  }

  @override
  String get addStockToContinue => 'Añade material para continuar.';

  @override
  String get cutPlanUnavailable => 'El plan de corte aún no está disponible.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Plan de corte';

  @override
  String get calculating => 'Calculando…';

  @override
  String get recalculate => 'Recalcular';

  @override
  String get editCutList => 'Editar lista de cortes';

  @override
  String stockPiecesUsed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count piezas de material utilizadas',
      one: '1 pieza de material utilizada',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count piezas de material por comprar',
      one: '1 pieza de material por comprar',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Comprar $length × $count';
  }

  @override
  String get requestedParts => 'Piezas solicitadas';

  @override
  String get placedParts => 'Piezas asignadas';

  @override
  String get unplacedParts => 'Piezas sin asignar';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested piezas',
      one: '1 pieza',
    );
    return 'Asignadas $placed de $_temp0';
  }

  @override
  String get totalFinishedLength => 'Longitud total de piezas';

  @override
  String get totalStockUsed => 'Longitud total de material usado';

  @override
  String get totalWaste => 'Desperdicio total';

  @override
  String wastePercentage(String value) {
    return 'Desperdicio: $value%';
  }

  @override
  String get reusableLeftovers => 'Retales reutilizables';

  @override
  String get scrap => 'Descarte';

  @override
  String get kerfLoss => 'Pérdida por corte';

  @override
  String get trimLoss => 'Pérdida por recorte';

  @override
  String get reusable => 'Reutilizable';

  @override
  String get leftover => 'Retal';

  @override
  String reusableExplanation(String threshold) {
    return 'Reutilizable: retales de al menos $threshold. El descarte incluye cortes, recortes y retales más cortos.';
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
      other: '$count piezas',
      one: '1 pieza',
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
    return 'Recorte de extremo: $length por extremo';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Barra de material $number, $length, $parts, retal $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Piezas sin asignar ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'No queda suficiente material para colocar esta pieza.';

  @override
  String get resultLoadError => 'No se pudo calcular esta lista de cortes.';

  @override
  String get resultValidationError =>
      'Revisa el material, las piezas y los ajustes de corte antes de calcular.';

  @override
  String get stockTooShortAfterTrim =>
      'El material es demasiado corto tras recortar los extremos.';

  @override
  String get validBuyStockRequired =>
      'Define una longitud válida de material antes de calcular.';

  @override
  String get tooLongResultReason =>
      'Esta pieza supera la mayor longitud útil de material.';

  @override
  String get editCutSettings => 'Editar ajustes de corte';

  @override
  String get units => 'Unidades';

  @override
  String get unitFtIn => 'ft + in';

  @override
  String get millimeters => 'Milímetros';

  @override
  String get centimeters => 'Centímetros';

  @override
  String get meters => 'Metros';

  @override
  String get feetAndInches => 'Pies y pulgadas';

  @override
  String get kerf => 'Ancho de corte';

  @override
  String get kerfHelper => 'Material eliminado entre piezas consecutivas.';

  @override
  String get kerfFinalPartHelper =>
      'No se añade un corte después de la última pieza de una barra.';

  @override
  String get endTrimEachEnd => 'Recorte de extremo (por extremo)';

  @override
  String get endTrimHelper =>
      'Recorta esta longitud de cada extremo de cada barra.';

  @override
  String get reusableLeftover => 'Retal reutilizable';

  @override
  String get reusableLeftoverHelper =>
      'Los retales de esta longitud o más se cuentan como reutilizables.';

  @override
  String get cutSettingsSaveError =>
      'No se pudieron guardar los ajustes de corte. Inténtalo de nuevo.';

  @override
  String get noUsableStockAfterTrim =>
      'No queda longitud útil de material tras recortar los extremos.';

  @override
  String get someStockUnusableAfterTrim =>
      'Algunas barras son demasiado cortas tras el recorte de extremos.';

  @override
  String get nonnegativeLengthInvalid =>
      'Introduce un número mayor o igual que cero.';

  @override
  String get nonnegativeImperialInvalid =>
      'Introduce números enteros no negativos y una fracción.';

  @override
  String get share => 'Compartir';

  @override
  String get shareCutPlan => 'Compartir plan de corte';

  @override
  String get shareText => 'Compartir texto';

  @override
  String get sharePdf => 'Compartir PDF';

  @override
  String get copyBuyList => 'Copiar lista de compra';

  @override
  String get buyListCopied => 'Lista de compra copiada';

  @override
  String get creatingPdf => 'Creando PDF…';

  @override
  String get pdfCreateError => 'No se pudo crear el PDF. Inténtalo de nuevo.';

  @override
  String get shareError =>
      'No se pudo compartir el plan de corte. Inténtalo de nuevo.';

  @override
  String get buyListCopyError =>
      'No se pudo copiar la lista de compra. Inténtalo de nuevo.';

  @override
  String get reportSummary => 'Resumen';

  @override
  String get reportPurchase => 'Compra';

  @override
  String get generatedLabel => 'Generado';

  @override
  String generatedBy(String appName) {
    return 'Generado por $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Los planes de corte son una ayuda para planificar. Comprueba cada medida en el material antes de cortar y sigue las normas de seguridad de las herramientas.';

  @override
  String get reportFileFallback => 'Plan de corte';

  @override
  String get addLeftoversToStock => 'Añadir retales al material disponible';

  @override
  String get addLeftoversTitle => '¿Añadir retales al material disponible?';

  @override
  String get addLeftoversMessage =>
      'Estos retales reutilizables se añadirán a las existencias fijas de este proyecto para futuros planes de corte.';

  @override
  String get addLeftoversFutureHint =>
      'Añádelos después de completar los cortes.';

  @override
  String get addToStock => 'Añadir al material disponible';

  @override
  String get leftoversAddedToStock =>
      'Retales reutilizables añadidos para futuros planes de corte.';

  @override
  String get leftoversAddError =>
      'No se pudieron añadir los retales. Inténtalo de nuevo.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count piezas reutilizables',
      one: '1 pieza reutilizable',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Guardar y añadir otra';

  @override
  String get defaultsSectionTitle => 'Valores predeterminados';

  @override
  String get appearanceSectionTitle => 'Apariencia';

  @override
  String get defaultReusableLeftover => 'Retal reutilizable predeterminado';

  @override
  String get newProjectsDefaultsHelper =>
      'Estos valores se usan al crear una nueva lista de cortes. Las listas existentes no cambian.';

  @override
  String get defaultReusableHelper =>
      'En proyectos nuevos, los retales de esta longitud o más se cuentan como reutilizables.';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get settingsSaveError =>
      'No se pudieron guardar los ajustes. Inténtalo de nuevo.';

  @override
  String get settingsLoadError => 'No se pudieron cargar los ajustes.';

  @override
  String get settingsSaved => 'Ajustes guardados';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

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
  String get upgradeOnce => 'Paga una vez. Disfrútalo para siempre.';

  @override
  String get noSubscription => 'Sin suscripción.';

  @override
  String get lifetimePro => 'Pro de por vida';

  @override
  String get removeAds => 'Eliminar anuncios';

  @override
  String unlockLifetimePro(String price) {
    return 'Desbloquear Pro de por vida — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Eliminar anuncios — $price';
  }

  @override
  String get proActive => 'Pro de por vida activo';

  @override
  String get adFreeActive => 'Sin anuncios';

  @override
  String get includedWithPro => 'Incluido con Pro de por vida';

  @override
  String get removeAdsDescription =>
      'Conserva las funciones gratuitas y elimina la publicidad.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoringPurchases => 'Restaurando compras…';

  @override
  String get purchasesRestored => 'Compras restauradas';

  @override
  String get lifetimeProRestored => 'Pro de por vida restaurado';

  @override
  String get adFreeRestored => 'Versión sin anuncios restaurada';

  @override
  String get nothingToRestore => 'No hay compras que restaurar';

  @override
  String get purchasePending => 'Compra pendiente';

  @override
  String get purchasePendingMessage =>
      'Tu compra está esperando a que Google Play complete el pago.';

  @override
  String get purchaseError =>
      'No se pudo completar la compra. Inténtalo de nuevo.';

  @override
  String get restoreError =>
      'No se pudieron restaurar las compras. Inténtalo de nuevo.';

  @override
  String get billingUnavailable => 'Las compras no están disponibles ahora.';

  @override
  String get productUnavailable => 'No disponible temporalmente.';

  @override
  String get processingPurchase => 'Verificando compra…';

  @override
  String get purchaseVerified => 'Compra verificada';

  @override
  String get kerfPlanFree => 'KerfPlan Gratis';

  @override
  String get viewPro => 'Ver Pro';

  @override
  String get upgrade => 'Mejorar plan';

  @override
  String get benefitUnlimitedProjects => 'Listas de cortes ilimitadas';

  @override
  String get benefitMultipleStocks => 'Varias longitudes de material';

  @override
  String get benefitPdf => 'Exportación a PDF para el taller';

  @override
  String get benefitReuseLeftovers => 'Reutilizar retales';

  @override
  String get benefitNoAds => 'Sin anuncios';

  @override
  String get onboardingIntro =>
      'Planifica cortes lineales con menos desperdicio.';

  @override
  String get howDoYouMeasure => '¿Qué sistema de medida usas?';

  @override
  String get metric => 'Métrico';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricDescription => 'Milímetros, centímetros y metros';

  @override
  String get imperialDescription => 'Pulgadas y pies';

  @override
  String get recommendedForRegion => 'Recomendado para tu región';

  @override
  String get continueAction => 'Continuar';

  @override
  String get measurementCanChangeLater =>
      'Puedes cambiarlo más tarde en Ajustes.';

  @override
  String get measurements => 'Medidas';

  @override
  String get measurementSystem => 'Sistema de medida';

  @override
  String get commonLengths => 'Longitudes habituales';
}
