// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get newCutList => 'Nova lista de cortes';

  @override
  String get noProjectsTitle => 'Nenhuma lista de cortes ainda';

  @override
  String get noProjectsMessage =>
      'Planeje seu primeiro serviço em menos de um minuto.';

  @override
  String get appVersionLabel => 'Versão do aplicativo';

  @override
  String get defaultUnits => 'Unidades padrão';

  @override
  String get defaultKerf => 'Largura de corte padrão';

  @override
  String get theme => 'Tema';

  @override
  String get newProjectTitle => 'Nova lista de cortes';

  @override
  String get projectNameLabel => 'Nome do projeto';

  @override
  String get projectNameHint => 'Estrutura da garagem';

  @override
  String get materialLabel => 'Material';

  @override
  String get materialHint => 'Aço 40x20';

  @override
  String get noteLabel => 'Observação';

  @override
  String get noteHint => 'Parede sul';

  @override
  String get createCutList => 'Criar lista de cortes';

  @override
  String get save => 'Salvar';

  @override
  String get editDetails => 'Editar detalhes';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get copyLabel => 'Cópia';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteProjectTitle => 'Excluir lista de cortes?';

  @override
  String deleteProjectMessage(String projectName) {
    return 'Isso exclui permanentemente “$projectName” deste dispositivo.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get projectDeleted => 'Lista de cortes excluída';

  @override
  String projectActions(String projectName) {
    return 'Ações para $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Atualizado em $date';
  }

  @override
  String get stockSectionTitle => 'Material disponível';

  @override
  String get noStockYet => 'Nenhum comprimento de material adicionado.';

  @override
  String get partsSectionTitle => 'Peças';

  @override
  String get noPartsYet => 'Nenhuma peça adicionada.';

  @override
  String get cutSettingsSectionTitle => 'Configurações de corte';

  @override
  String get calculate => 'Calcular';

  @override
  String get calculateDisabledHint =>
      'Adicione peças para calcular um plano de corte.';

  @override
  String get projectNotFound => 'Lista de cortes não encontrada';

  @override
  String get backToProjects => 'Voltar às listas';

  @override
  String get projectNameRequired => 'Digite o nome do projeto.';

  @override
  String get projectNameTooLong =>
      'O nome do projeto deve ter no máximo 80 caracteres.';

  @override
  String get materialTooLong => 'O material deve ter no máximo 120 caracteres.';

  @override
  String get noteTooLong => 'A observação deve ter no máximo 500 caracteres.';

  @override
  String get projectSaveError =>
      'Não foi possível salvar a lista de cortes. Tente novamente.';

  @override
  String get projectDeleteError =>
      'Não foi possível excluir a lista de cortes. Tente novamente.';

  @override
  String get projectDuplicateError =>
      'Não foi possível duplicar a lista de cortes. Tente novamente.';

  @override
  String get projectsLoadError =>
      'Não foi possível carregar suas listas de cortes.';

  @override
  String get projectLoadError =>
      'Não foi possível carregar esta lista de cortes.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get fixedInventory => 'Estoque fixo';

  @override
  String get buyStock => 'Comprar material';

  @override
  String get addStockLength => 'Adicionar comprimento de material';

  @override
  String get editStockLength => 'Editar comprimento de material';

  @override
  String get stockLength => 'Comprimento';

  @override
  String get quantity => 'Quantidade';

  @override
  String get labelOptional => 'Etiqueta (opcional)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Depósito';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Digite um comprimento.';

  @override
  String get stockLengthInvalid => 'Digite um número maior que zero.';

  @override
  String get stockLengthPrecision =>
      'Este valor não pode ser salvo exatamente. Use um comprimento múltiplo de 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Este comprimento é grande demais.';

  @override
  String get quantityRequired => 'Digite uma quantidade.';

  @override
  String get quantityInvalid => 'Digite um número inteiro de 1 a 9999.';

  @override
  String get quantityTooLarge => 'A quantidade deve ser no máximo 9999.';

  @override
  String get stockLabelTooLong =>
      'A etiqueta deve ter no máximo 80 caracteres.';

  @override
  String get saveStock => 'Salvar comprimento de material';

  @override
  String get stockSaveError =>
      'Não foi possível salvar este comprimento. Tente novamente.';

  @override
  String get stockDeleteError =>
      'Não foi possível excluir este comprimento. Tente novamente.';

  @override
  String get stockDuplicateError =>
      'Não foi possível duplicar este comprimento. Tente novamente.';

  @override
  String get stockLoadError =>
      'Não foi possível carregar o material disponível.';

  @override
  String get stockNotFound => 'Comprimento de material não encontrado';

  @override
  String get deleteStockTitle => 'Excluir comprimento de material?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity será removido desta lista de cortes.';
  }

  @override
  String get stockDeleted => 'Comprimento de material excluído';

  @override
  String get duplicateStock => 'Duplicar comprimento de material';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comprimentos de material',
      one: '1 comprimento de material',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças no total',
      one: '1 peça no total',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Definir comprimento de material';

  @override
  String get buyStockHelper =>
      'Calcularemos quantas peças você precisa comprar.';

  @override
  String get buyStockLengthMissing =>
      'Defina o comprimento do material que pretende comprar.';

  @override
  String get stockModeSaveError =>
      'Não foi possível alterar o modo de estoque. Tente novamente.';

  @override
  String get backToProject => 'Voltar à lista de cortes';

  @override
  String get decreaseQuantity => 'Diminuir quantidade';

  @override
  String get increaseQuantity => 'Aumentar quantidade';

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
    return 'Ações para $length';
  }

  @override
  String get decimalInchesHelper => 'Digite polegadas decimais.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Salvo exatamente: $value mm. A medida em polegadas é aproximada. O comprimento salvo permanece exato até que você o edite.';
  }

  @override
  String get addPart => 'Adicionar peça';

  @override
  String get editPart => 'Editar peça';

  @override
  String get partNameOptional => 'Nome da peça (opcional)';

  @override
  String get partNameHint => 'Montante';

  @override
  String get partNameTooLong =>
      'O nome da peça deve ter no máximo 100 caracteres.';

  @override
  String get partSaveError =>
      'Não foi possível salvar esta peça. Tente novamente.';

  @override
  String get partDeleteError =>
      'Não foi possível excluir esta peça. Tente novamente.';

  @override
  String get partDuplicateError =>
      'Não foi possível duplicar esta peça. Tente novamente.';

  @override
  String get partLoadError => 'Não foi possível carregar as peças.';

  @override
  String get partNotFound => 'Peça não encontrada';

  @override
  String get deletePartTitle => 'Excluir peça?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity será removido desta lista de cortes.';
  }

  @override
  String get partDeleted => 'Peça excluída';

  @override
  String get duplicatePart => 'Duplicar peça';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas de peças',
      one: '1 linha de peças',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Pés';

  @override
  String get inches => 'Polegadas';

  @override
  String get wholeInches => 'Polegadas inteiras';

  @override
  String get fraction => 'Fração';

  @override
  String get inchesRange =>
      'Use de 0 a 11 polegadas. Digite os pés adicionais no campo Pés.';

  @override
  String get imperialLengthInvalid =>
      'Digite números inteiros não negativos e uma fração cuja soma seja maior que zero.';

  @override
  String partTooLongWarning(String length) {
    return 'Esta peça excede o maior comprimento útil de material ($length).';
  }

  @override
  String get addStockToContinue => 'Adicione material para continuar.';

  @override
  String get cutPlanUnavailable =>
      'O plano de corte ainda não está disponível.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Plano de corte';

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
      other: '$count peças de material usadas',
      one: '1 peça de material usada',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças de material para comprar',
      one: '1 peça de material para comprar',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Comprar $length × $count';
  }

  @override
  String get requestedParts => 'Peças solicitadas';

  @override
  String get placedParts => 'Peças alocadas';

  @override
  String get unplacedParts => 'Peças não alocadas';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested peças',
      one: '1 peça',
    );
    return '$placed de $_temp0 alocadas';
  }

  @override
  String get totalFinishedLength => 'Comprimento total das peças acabadas';

  @override
  String get totalStockUsed => 'Comprimento total de material usado';

  @override
  String get totalWaste => 'Desperdício total';

  @override
  String wastePercentage(String value) {
    return 'Desperdício: $value%';
  }

  @override
  String get reusableLeftovers => 'Sobras reutilizáveis';

  @override
  String get scrap => 'Refugo';

  @override
  String get kerfLoss => 'Perda pela serra';

  @override
  String get trimLoss => 'Perda pelo desbaste das pontas';

  @override
  String get reusable => 'Reutilizável';

  @override
  String get leftover => 'Sobra';

  @override
  String reusableExplanation(String threshold) {
    return 'Reutilizáveis: sobras com pelo menos $threshold. O refugo inclui a largura de corte, o desbaste das pontas e sobras menores.';
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
      other: '$count peças',
      one: '1 peça',
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
    return 'Desbaste: $length em cada ponta';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Barra de material $number, $length, $parts, sobra $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Peças não alocadas ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Não há material suficiente para alocar esta peça.';

  @override
  String get resultLoadError =>
      'Não foi possível calcular esta lista de cortes.';

  @override
  String get resultValidationError =>
      'Confira o material, as peças e as configurações de corte antes de calcular.';

  @override
  String get stockTooShortAfterTrim =>
      'O material é curto demais após o desbaste das pontas.';

  @override
  String get validBuyStockRequired =>
      'Defina um comprimento válido de material antes de calcular.';

  @override
  String get tooLongResultReason =>
      'Esta peça excede o maior comprimento útil de material.';

  @override
  String get editCutSettings => 'Editar configurações de corte';

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
  String get feetAndInches => 'Pés e polegadas';

  @override
  String get kerf => 'Largura de corte';

  @override
  String get kerfHelper => 'Material removido entre peças consecutivas.';

  @override
  String get kerfFinalPartHelper =>
      'Não se adiciona um corte após a última peça de uma barra.';

  @override
  String get endTrimEachEnd => 'Desbaste das pontas (cada ponta)';

  @override
  String get endTrimHelper =>
      'Remova este comprimento de cada ponta de cada barra.';

  @override
  String get reusableLeftover => 'Sobra reutilizável';

  @override
  String get reusableLeftoverHelper =>
      'Sobras com este comprimento ou mais são consideradas reutilizáveis.';

  @override
  String get cutSettingsSaveError =>
      'Não foi possível salvar as configurações de corte. Tente novamente.';

  @override
  String get noUsableStockAfterTrim =>
      'Não resta comprimento útil após o desbaste das pontas.';

  @override
  String get someStockUnusableAfterTrim =>
      'Algumas barras são curtas demais após o desbaste das pontas.';

  @override
  String get nonnegativeLengthInvalid =>
      'Digite um número maior ou igual a zero.';

  @override
  String get nonnegativeImperialInvalid =>
      'Digite números inteiros não negativos e uma fração.';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareCutPlan => 'Compartilhar plano de corte';

  @override
  String get shareText => 'Compartilhar texto';

  @override
  String get sharePdf => 'Compartilhar PDF';

  @override
  String get copyBuyList => 'Copiar lista de compras';

  @override
  String get buyListCopied => 'Lista de compras copiada';

  @override
  String get creatingPdf => 'Criando PDF…';

  @override
  String get pdfCreateError => 'Não foi possível criar o PDF. Tente novamente.';

  @override
  String get shareError =>
      'Não foi possível compartilhar o plano de corte. Tente novamente.';

  @override
  String get buyListCopyError =>
      'Não foi possível copiar a lista de compras. Tente novamente.';

  @override
  String get reportSummary => 'Resumo';

  @override
  String get reportPurchase => 'Compra';

  @override
  String get generatedLabel => 'Gerado';

  @override
  String generatedBy(String appName) {
    return 'Gerado por $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Planos de corte ajudam no planejamento. Confira cada medida no material antes de cortar e siga as normas de segurança das ferramentas.';

  @override
  String get reportFileFallback => 'Plano de corte';

  @override
  String get addLeftoversToStock => 'Adicionar sobras ao estoque';

  @override
  String get addLeftoversTitle => 'Adicionar sobras ao estoque?';

  @override
  String get addLeftoversMessage =>
      'Estas sobras reutilizáveis serão adicionadas ao estoque fixo deste projeto para futuros planos de corte.';

  @override
  String get addLeftoversFutureHint =>
      'Adicione-as depois de concluir os cortes.';

  @override
  String get addToStock => 'Adicionar ao estoque';

  @override
  String get leftoversAddedToStock =>
      'Sobras reutilizáveis adicionadas ao estoque para futuros planos de corte.';

  @override
  String get leftoversAddError =>
      'Não foi possível adicionar as sobras ao estoque. Tente novamente.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças reutilizáveis',
      one: '1 peça reutilizável',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Salvar e adicionar outra';

  @override
  String get defaultsSectionTitle => 'Padrões';

  @override
  String get appearanceSectionTitle => 'Aparência';

  @override
  String get defaultReusableLeftover => 'Sobra reutilizável padrão';

  @override
  String get newProjectsDefaultsHelper =>
      'Estes valores são usados em novas listas de cortes. As listas existentes não mudam.';

  @override
  String get defaultReusableHelper =>
      'Em novos projetos, sobras com este comprimento ou mais são reutilizáveis.';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsSaveError =>
      'Não foi possível salvar as configurações. Tente novamente.';

  @override
  String get settingsLoadError => 'Não foi possível carregar as configurações.';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

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
  String get upgradeOnce => 'Compre uma vez. Use para sempre.';

  @override
  String get noSubscription => 'Sem assinatura.';

  @override
  String get lifetimePro => 'Pro vitalício';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String unlockLifetimePro(String price) {
    return 'Desbloquear Pro vitalício — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Remover anúncios — $price';
  }

  @override
  String get proActive => 'Pro vitalício ativo';

  @override
  String get adFreeActive => 'Sem anúncios';

  @override
  String get includedWithPro => 'Incluído no Pro vitalício';

  @override
  String get removeAdsDescription =>
      'Mantenha os recursos gratuitos e remova os anúncios.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoringPurchases => 'Restaurando compras…';

  @override
  String get purchasesRestored => 'Compras restauradas';

  @override
  String get lifetimeProRestored => 'Pro vitalício restaurado';

  @override
  String get adFreeRestored => 'Versão sem anúncios restaurada';

  @override
  String get nothingToRestore => 'Nenhuma compra para restaurar';

  @override
  String get purchasePending => 'Compra pendente';

  @override
  String get purchasePendingMessage =>
      'Sua compra aguarda a conclusão do pagamento pelo Google Play.';

  @override
  String get purchaseError =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get restoreError =>
      'Não foi possível restaurar as compras. Tente novamente.';

  @override
  String get billingUnavailable => 'As compras não estão disponíveis agora.';

  @override
  String get productUnavailable => 'Temporariamente indisponível.';

  @override
  String get processingPurchase => 'Verificando compra…';

  @override
  String get purchaseVerified => 'Compra verificada';

  @override
  String get kerfPlanFree => 'KerfPlan Grátis';

  @override
  String get viewPro => 'Ver Pro';

  @override
  String get upgrade => 'Fazer upgrade';

  @override
  String get benefitUnlimitedProjects => 'Listas de cortes ilimitadas';

  @override
  String get benefitMultipleStocks => 'Vários comprimentos de material';

  @override
  String get benefitPdf => 'Exportação em PDF para a oficina';

  @override
  String get benefitReuseLeftovers => 'Reaproveitar sobras';

  @override
  String get benefitNoAds => 'Sem anúncios';

  @override
  String get onboardingIntro =>
      'Planeje cortes lineares com menos desperdício.';

  @override
  String get howDoYouMeasure => 'Como você mede?';

  @override
  String get metric => 'Métrico';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricDescription => 'Milímetros, centímetros e metros';

  @override
  String get imperialDescription => 'Polegadas e pés';

  @override
  String get recommendedForRegion => 'Recomendado para sua região';

  @override
  String get continueAction => 'Continuar';

  @override
  String get measurementCanChangeLater =>
      'Você pode mudar isso depois nas Configurações.';

  @override
  String get measurements => 'Medidas';

  @override
  String get measurementSystem => 'Sistema de medidas';

  @override
  String get commonLengths => 'Comprimentos comuns';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'KerfPlan';

  @override
  String get homeTitle => 'KerfPlan';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get newCutList => 'Nova lista de cortes';

  @override
  String get noProjectsTitle => 'Nenhuma lista de cortes ainda';

  @override
  String get noProjectsMessage =>
      'Planeje seu primeiro serviço em menos de um minuto.';

  @override
  String get appVersionLabel => 'Versão do aplicativo';

  @override
  String get defaultUnits => 'Unidades padrão';

  @override
  String get defaultKerf => 'Largura de corte padrão';

  @override
  String get theme => 'Tema';

  @override
  String get newProjectTitle => 'Nova lista de cortes';

  @override
  String get projectNameLabel => 'Nome do projeto';

  @override
  String get projectNameHint => 'Estrutura da garagem';

  @override
  String get materialLabel => 'Material';

  @override
  String get materialHint => 'Aço 40x20';

  @override
  String get noteLabel => 'Observação';

  @override
  String get noteHint => 'Parede sul';

  @override
  String get createCutList => 'Criar lista de cortes';

  @override
  String get save => 'Salvar';

  @override
  String get editDetails => 'Editar detalhes';

  @override
  String get duplicate => 'Duplicar';

  @override
  String get copyLabel => 'Cópia';

  @override
  String get delete => 'Excluir';

  @override
  String get deleteProjectTitle => 'Excluir lista de cortes?';

  @override
  String deleteProjectMessage(String projectName) {
    return 'Isso exclui permanentemente “$projectName” deste dispositivo.';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get projectDeleted => 'Lista de cortes excluída';

  @override
  String projectActions(String projectName) {
    return 'Ações para $projectName';
  }

  @override
  String updatedLabel(String date) {
    return 'Atualizado em $date';
  }

  @override
  String get stockSectionTitle => 'Material disponível';

  @override
  String get noStockYet => 'Nenhum comprimento de material adicionado.';

  @override
  String get partsSectionTitle => 'Peças';

  @override
  String get noPartsYet => 'Nenhuma peça adicionada.';

  @override
  String get cutSettingsSectionTitle => 'Configurações de corte';

  @override
  String get calculate => 'Calcular';

  @override
  String get calculateDisabledHint =>
      'Adicione peças para calcular um plano de corte.';

  @override
  String get projectNotFound => 'Lista de cortes não encontrada';

  @override
  String get backToProjects => 'Voltar às listas';

  @override
  String get projectNameRequired => 'Digite o nome do projeto.';

  @override
  String get projectNameTooLong =>
      'O nome do projeto deve ter no máximo 80 caracteres.';

  @override
  String get materialTooLong => 'O material deve ter no máximo 120 caracteres.';

  @override
  String get noteTooLong => 'A observação deve ter no máximo 500 caracteres.';

  @override
  String get projectSaveError =>
      'Não foi possível salvar a lista de cortes. Tente novamente.';

  @override
  String get projectDeleteError =>
      'Não foi possível excluir a lista de cortes. Tente novamente.';

  @override
  String get projectDuplicateError =>
      'Não foi possível duplicar a lista de cortes. Tente novamente.';

  @override
  String get projectsLoadError =>
      'Não foi possível carregar suas listas de cortes.';

  @override
  String get projectLoadError =>
      'Não foi possível carregar esta lista de cortes.';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get fixedInventory => 'Estoque fixo';

  @override
  String get buyStock => 'Comprar material';

  @override
  String get addStockLength => 'Adicionar comprimento de material';

  @override
  String get editStockLength => 'Editar comprimento de material';

  @override
  String get stockLength => 'Comprimento';

  @override
  String get quantity => 'Quantidade';

  @override
  String get labelOptional => 'Etiqueta (opcional)';

  @override
  String get stockLengthHint => '6000';

  @override
  String get stockLengthCmHint => '244';

  @override
  String get stockLengthMHint => '2,4';

  @override
  String get stockLabelHint => 'Depósito';

  @override
  String get quantityHint => '10';

  @override
  String get stockLengthRequired => 'Digite um comprimento.';

  @override
  String get stockLengthInvalid => 'Digite um número maior que zero.';

  @override
  String get stockLengthPrecision =>
      'Este valor não pode ser salvo exatamente. Use um comprimento múltiplo de 0,0001 mm.';

  @override
  String get stockLengthTooLarge => 'Este comprimento é grande demais.';

  @override
  String get quantityRequired => 'Digite uma quantidade.';

  @override
  String get quantityInvalid => 'Digite um número inteiro de 1 a 9999.';

  @override
  String get quantityTooLarge => 'A quantidade deve ser no máximo 9999.';

  @override
  String get stockLabelTooLong =>
      'A etiqueta deve ter no máximo 80 caracteres.';

  @override
  String get saveStock => 'Salvar comprimento de material';

  @override
  String get stockSaveError =>
      'Não foi possível salvar este comprimento. Tente novamente.';

  @override
  String get stockDeleteError =>
      'Não foi possível excluir este comprimento. Tente novamente.';

  @override
  String get stockDuplicateError =>
      'Não foi possível duplicar este comprimento. Tente novamente.';

  @override
  String get stockLoadError =>
      'Não foi possível carregar o material disponível.';

  @override
  String get stockNotFound => 'Comprimento de material não encontrado';

  @override
  String get deleteStockTitle => 'Excluir comprimento de material?';

  @override
  String deleteStockMessage(String length, int quantity) {
    return '$length × $quantity será removido desta lista de cortes.';
  }

  @override
  String get stockDeleted => 'Comprimento de material excluído';

  @override
  String get duplicateStock => 'Duplicar comprimento de material';

  @override
  String stockSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comprimentos de material',
      one: '1 comprimento de material',
    );
    return '$_temp0';
  }

  @override
  String totalPieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças no total',
      one: '1 peça no total',
    );
    return '$_temp0';
  }

  @override
  String get setBuyStockLength => 'Definir comprimento de material';

  @override
  String get buyStockHelper =>
      'Calcularemos quantas peças você precisa comprar.';

  @override
  String get buyStockLengthMissing =>
      'Defina o comprimento do material que pretende comprar.';

  @override
  String get stockModeSaveError =>
      'Não foi possível alterar o modo de estoque. Tente novamente.';

  @override
  String get backToProject => 'Voltar à lista de cortes';

  @override
  String get decreaseQuantity => 'Diminuir quantidade';

  @override
  String get increaseQuantity => 'Aumentar quantidade';

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
    return 'Ações para $length';
  }

  @override
  String get decimalInchesHelper => 'Digite polegadas decimais.';

  @override
  String exactStoredLengthHelper(String value) {
    return 'Salvo exatamente: $value mm. A medida em polegadas é aproximada. O comprimento salvo permanece exato até que você o edite.';
  }

  @override
  String get addPart => 'Adicionar peça';

  @override
  String get editPart => 'Editar peça';

  @override
  String get partNameOptional => 'Nome da peça (opcional)';

  @override
  String get partNameHint => 'Montante';

  @override
  String get partNameTooLong =>
      'O nome da peça deve ter no máximo 100 caracteres.';

  @override
  String get partSaveError =>
      'Não foi possível salvar esta peça. Tente novamente.';

  @override
  String get partDeleteError =>
      'Não foi possível excluir esta peça. Tente novamente.';

  @override
  String get partDuplicateError =>
      'Não foi possível duplicar esta peça. Tente novamente.';

  @override
  String get partLoadError => 'Não foi possível carregar as peças.';

  @override
  String get partNotFound => 'Peça não encontrada';

  @override
  String get deletePartTitle => 'Excluir peça?';

  @override
  String deletePartMessage(String description, int quantity) {
    return '$description × $quantity será removido desta lista de cortes.';
  }

  @override
  String get partDeleted => 'Peça excluída';

  @override
  String get duplicatePart => 'Duplicar peça';

  @override
  String partSummary(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count linhas de peças',
      one: '1 linha de peças',
    );
    return '$_temp0';
  }

  @override
  String get feet => 'Pés';

  @override
  String get inches => 'Polegadas';

  @override
  String get wholeInches => 'Polegadas inteiras';

  @override
  String get fraction => 'Fração';

  @override
  String get inchesRange =>
      'Use de 0 a 11 polegadas. Digite os pés adicionais no campo Pés.';

  @override
  String get imperialLengthInvalid =>
      'Digite números inteiros não negativos e uma fração cuja soma seja maior que zero.';

  @override
  String partTooLongWarning(String length) {
    return 'Esta peça excede o maior comprimento útil de material ($length).';
  }

  @override
  String get addStockToContinue => 'Adicione material para continuar.';

  @override
  String get cutPlanUnavailable =>
      'O plano de corte ainda não está disponível.';

  @override
  String namedPartLength(String name, String length) {
    return '$name — $length';
  }

  @override
  String get cutPlanTitle => 'Plano de corte';

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
      other: '$count peças de material usadas',
      one: '1 peça de material usada',
    );
    return '$_temp0';
  }

  @override
  String stockPiecesToBuy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças de material para comprar',
      one: '1 peça de material para comprar',
    );
    return '$_temp0';
  }

  @override
  String buySummary(String length, int count) {
    return 'Comprar $length × $count';
  }

  @override
  String get requestedParts => 'Peças solicitadas';

  @override
  String get placedParts => 'Peças alocadas';

  @override
  String get unplacedParts => 'Peças não alocadas';

  @override
  String placedOfRequested(int placed, int requested) {
    String _temp0 = intl.Intl.pluralLogic(
      requested,
      locale: localeName,
      other: '$requested peças',
      one: '1 peça',
    );
    return '$placed de $_temp0 alocadas';
  }

  @override
  String get totalFinishedLength => 'Comprimento total das peças acabadas';

  @override
  String get totalStockUsed => 'Comprimento total de material usado';

  @override
  String get totalWaste => 'Desperdício total';

  @override
  String wastePercentage(String value) {
    return 'Desperdício: $value%';
  }

  @override
  String get reusableLeftovers => 'Sobras reutilizáveis';

  @override
  String get scrap => 'Refugo';

  @override
  String get kerfLoss => 'Perda pela serra';

  @override
  String get trimLoss => 'Perda pelo desbaste das pontas';

  @override
  String get reusable => 'Reutilizável';

  @override
  String get leftover => 'Sobra';

  @override
  String reusableExplanation(String threshold) {
    return 'Reutilizáveis: sobras com pelo menos $threshold. O refugo inclui a largura de corte, o desbaste das pontas e sobras menores.';
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
      other: '$count peças',
      one: '1 peça',
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
    return 'Desbaste: $length em cada ponta';
  }

  @override
  String barDiagramDescription(
    int number,
    String length,
    String parts,
    String tail,
  ) {
    return 'Barra de material $number, $length, $parts, sobra $tail.';
  }

  @override
  String unplacedCount(int count) {
    return 'Peças não alocadas ($count)';
  }

  @override
  String lengthQuantity(String length, int quantity) {
    return '$length × $quantity';
  }

  @override
  String get inventoryExhaustedResultReason =>
      'Não há material suficiente para alocar esta peça.';

  @override
  String get resultLoadError =>
      'Não foi possível calcular esta lista de cortes.';

  @override
  String get resultValidationError =>
      'Confira o material, as peças e as configurações de corte antes de calcular.';

  @override
  String get stockTooShortAfterTrim =>
      'O material é curto demais após o desbaste das pontas.';

  @override
  String get validBuyStockRequired =>
      'Defina um comprimento válido de material antes de calcular.';

  @override
  String get tooLongResultReason =>
      'Esta peça excede o maior comprimento útil de material.';

  @override
  String get editCutSettings => 'Editar configurações de corte';

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
  String get feetAndInches => 'Pés e polegadas';

  @override
  String get kerf => 'Largura de corte';

  @override
  String get kerfHelper => 'Material removido entre peças consecutivas.';

  @override
  String get kerfFinalPartHelper =>
      'Não se adiciona um corte após a última peça de uma barra.';

  @override
  String get endTrimEachEnd => 'Desbaste das pontas (cada ponta)';

  @override
  String get endTrimHelper =>
      'Remova este comprimento de cada ponta de cada barra.';

  @override
  String get reusableLeftover => 'Sobra reutilizável';

  @override
  String get reusableLeftoverHelper =>
      'Sobras com este comprimento ou mais são consideradas reutilizáveis.';

  @override
  String get cutSettingsSaveError =>
      'Não foi possível salvar as configurações de corte. Tente novamente.';

  @override
  String get noUsableStockAfterTrim =>
      'Não resta comprimento útil após o desbaste das pontas.';

  @override
  String get someStockUnusableAfterTrim =>
      'Algumas barras são curtas demais após o desbaste das pontas.';

  @override
  String get nonnegativeLengthInvalid =>
      'Digite um número maior ou igual a zero.';

  @override
  String get nonnegativeImperialInvalid =>
      'Digite números inteiros não negativos e uma fração.';

  @override
  String get share => 'Compartilhar';

  @override
  String get shareCutPlan => 'Compartilhar plano de corte';

  @override
  String get shareText => 'Compartilhar texto';

  @override
  String get sharePdf => 'Compartilhar PDF';

  @override
  String get copyBuyList => 'Copiar lista de compras';

  @override
  String get buyListCopied => 'Lista de compras copiada';

  @override
  String get creatingPdf => 'Criando PDF…';

  @override
  String get pdfCreateError => 'Não foi possível criar o PDF. Tente novamente.';

  @override
  String get shareError =>
      'Não foi possível compartilhar o plano de corte. Tente novamente.';

  @override
  String get buyListCopyError =>
      'Não foi possível copiar a lista de compras. Tente novamente.';

  @override
  String get reportSummary => 'Resumo';

  @override
  String get reportPurchase => 'Compra';

  @override
  String get generatedLabel => 'Gerado';

  @override
  String generatedBy(String appName) {
    return 'Gerado por $appName';
  }

  @override
  String get verifyBeforeCutting =>
      'Planos de corte ajudam no planejamento. Confira cada medida no material antes de cortar e siga as normas de segurança das ferramentas.';

  @override
  String get reportFileFallback => 'Plano de corte';

  @override
  String get addLeftoversToStock => 'Adicionar sobras ao estoque';

  @override
  String get addLeftoversTitle => 'Adicionar sobras ao estoque?';

  @override
  String get addLeftoversMessage =>
      'Estas sobras reutilizáveis serão adicionadas ao estoque fixo deste projeto para futuros planos de corte.';

  @override
  String get addLeftoversFutureHint =>
      'Adicione-as depois de concluir os cortes.';

  @override
  String get addToStock => 'Adicionar ao estoque';

  @override
  String get leftoversAddedToStock =>
      'Sobras reutilizáveis adicionadas ao estoque para futuros planos de corte.';

  @override
  String get leftoversAddError =>
      'Não foi possível adicionar as sobras ao estoque. Tente novamente.';

  @override
  String reusablePieces(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count peças reutilizáveis',
      one: '1 peça reutilizável',
    );
    return '$_temp0';
  }

  @override
  String get saveAndAddAnother => 'Salvar e adicionar outra';

  @override
  String get defaultsSectionTitle => 'Padrões';

  @override
  String get appearanceSectionTitle => 'Aparência';

  @override
  String get defaultReusableLeftover => 'Sobra reutilizável padrão';

  @override
  String get newProjectsDefaultsHelper =>
      'Estes valores são usados em novas listas de cortes. As listas existentes não mudam.';

  @override
  String get defaultReusableHelper =>
      'Em novos projetos, sobras com este comprimento ou mais são reutilizáveis.';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get settingsSaveError =>
      'Não foi possível salvar as configurações. Tente novamente.';

  @override
  String get settingsLoadError => 'Não foi possível carregar as configurações.';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get language => 'Idioma';

  @override
  String get languageSystem => 'Padrão do sistema';

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
  String get upgradeOnce => 'Compre uma vez. Use para sempre.';

  @override
  String get noSubscription => 'Sem assinatura.';

  @override
  String get lifetimePro => 'Pro vitalício';

  @override
  String get removeAds => 'Remover anúncios';

  @override
  String unlockLifetimePro(String price) {
    return 'Desbloquear Pro vitalício — $price';
  }

  @override
  String removeAdsCta(String price) {
    return 'Remover anúncios — $price';
  }

  @override
  String get proActive => 'Pro vitalício ativo';

  @override
  String get adFreeActive => 'Sem anúncios';

  @override
  String get includedWithPro => 'Incluído no Pro vitalício';

  @override
  String get removeAdsDescription =>
      'Mantenha os recursos gratuitos e remova os anúncios.';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get restoringPurchases => 'Restaurando compras…';

  @override
  String get purchasesRestored => 'Compras restauradas';

  @override
  String get lifetimeProRestored => 'Pro vitalício restaurado';

  @override
  String get adFreeRestored => 'Versão sem anúncios restaurada';

  @override
  String get nothingToRestore => 'Nenhuma compra para restaurar';

  @override
  String get purchasePending => 'Compra pendente';

  @override
  String get purchasePendingMessage =>
      'Sua compra aguarda a conclusão do pagamento pelo Google Play.';

  @override
  String get purchaseError =>
      'Não foi possível concluir a compra. Tente novamente.';

  @override
  String get restoreError =>
      'Não foi possível restaurar as compras. Tente novamente.';

  @override
  String get billingUnavailable => 'As compras não estão disponíveis agora.';

  @override
  String get productUnavailable => 'Temporariamente indisponível.';

  @override
  String get processingPurchase => 'Verificando compra…';

  @override
  String get purchaseVerified => 'Compra verificada';

  @override
  String get kerfPlanFree => 'KerfPlan Grátis';

  @override
  String get viewPro => 'Ver Pro';

  @override
  String get upgrade => 'Fazer upgrade';

  @override
  String get benefitUnlimitedProjects => 'Listas de cortes ilimitadas';

  @override
  String get benefitMultipleStocks => 'Vários comprimentos de material';

  @override
  String get benefitPdf => 'Exportação em PDF para a oficina';

  @override
  String get benefitReuseLeftovers => 'Reaproveitar sobras';

  @override
  String get benefitNoAds => 'Sem anúncios';

  @override
  String get onboardingIntro =>
      'Planeje cortes lineares com menos desperdício.';

  @override
  String get howDoYouMeasure => 'Como você mede?';

  @override
  String get metric => 'Métrico';

  @override
  String get imperial => 'Imperial';

  @override
  String get metricDescription => 'Milímetros, centímetros e metros';

  @override
  String get imperialDescription => 'Polegadas e pés';

  @override
  String get recommendedForRegion => 'Recomendado para sua região';

  @override
  String get continueAction => 'Continuar';

  @override
  String get measurementCanChangeLater =>
      'Você pode mudar isso depois nas Configurações.';

  @override
  String get measurements => 'Medidas';

  @override
  String get measurementSystem => 'Sistema de medidas';

  @override
  String get commonLengths => 'Comprimentos comuns';
}
