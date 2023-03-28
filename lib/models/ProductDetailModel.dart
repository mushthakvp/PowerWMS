class ProductDetailModel {
  ProductDetailModel({
      this.id, 
      this.adminCode, 
      this.countryCodeOrigin, 
      this.countryCodeProvenance, 
      this.description, 
      this.eanCodeGenerationKey, 
      this.eanCode, 
      this.eanCodeAsText, 
      this.length, 
      this.width, 
      this.heigth, 
      this.weight, 
      this.externalProductCode, 
      this.productGroupCodeExternalProduct, 
      this.guarantee, 
      this.locationCode, 
      this.packingUnit, 
      this.packingRatio, 
      this.productCode, 
      this.referenceJournalEntryCode, 
      this.searchName, 
      this.searchKeys, 
      this.unitCode, 
      this.vatGroup, 
      this.warehouseCode, 
      this.stockRegistration, 
      this.discontinued, 
      this.stockKeeping, 
      this.purchaseOrderRecommendation, 
      this.blocked, 
      this.batchRegistration, 
      this.oneOff, 
      this.inactive, 
      this.minimumStock, 
      this.maximumStock, 
      this.minimalPurchase, 
      this.compositionType, 
      this.storeUnit, 
      this.storeRatio, 
      this.bulkUnit, 
      this.bulkRatio, 
      this.statistics, 
      this.useOfSerialNumbers, 
      this.costPrice, 
      this.printStickers, 
      this.imagePath, 
      this.abcCode, 
      this.isAssembly, 
      this.assemblyRecommendation, 
      this.percentageLoss, 
      this.assemblyReferenceJournalEntryCode, 
      this.assemblyCosts, 
      this.assemblyWarehouseCode, 
      this.assemblyLocationCode, 
      this.surplusLocationCode, 
      this.numberOfUnitsPerWorkingDay, 
      this.numberOfDaysPerUnit, 
      this.numberOfSafetyDays, 
      this.assemblyInstruction, 
      this.assemblySubContractedWork, 
      this.assemblyOnlyThroughOutsourcedWork, 
      this.assemblyForecastNumber, 
      this.usePartialRelocation, 
      this.useComponentPartial, 
      this.partialRelocationMinimum, 
      this.applySubAssemblyEndProduct, 
      this.applySubAssemblyComponent, 
      this.subAssemblyApplicationType, 
      this.alternativeUnitCode, 
      this.packingRatioAlternativeUnit, 
      this.externalStatus, 
      this.stockCosts, 
      this.stockCostPercentage, 
      this.salesPriceBasedOnComponents, 
      this.factMeasure, 
      this.percentagePriceControl, 
      this.propertiesToInclude,});

  ProductDetailModel.fromJson(dynamic json) {
    id = json['id'];
    adminCode = json['adminCode'];
    countryCodeOrigin = json['countryCodeOrigin'];
    countryCodeProvenance = json['countryCodeProvenance'];
    description = json['description'];
    eanCodeGenerationKey = json['eanCodeGenerationKey'];
    eanCode = json['eanCode'];
    eanCodeAsText = json['eanCodeAsText'];
    length = json['length'];
    width = json['width'];
    heigth = json['heigth'];
    weight = json['weight'];
    externalProductCode = json['externalProductCode'];
    productGroupCodeExternalProduct = json['productGroupCodeExternalProduct'];
    guarantee = json['guarantee'];
    locationCode = json['locationCode'];
    packingUnit = json['packingUnit'];
    packingRatio = json['packingRatio'];
    productCode = json['productCode'];
    referenceJournalEntryCode = json['referenceJournalEntryCode'];
    searchName = json['searchName'];
    searchKeys = json['searchKeys'];
    unitCode = json['unitCode'];
    vatGroup = json['vatGroup'];
    warehouseCode = json['warehouseCode'];
    stockRegistration = json['stockRegistration'];
    discontinued = json['discontinued'];
    stockKeeping = json['stockKeeping'];
    purchaseOrderRecommendation = json['purchaseOrderRecommendation'];
    blocked = json['blocked'];
    batchRegistration = json['batchRegistration'];
    oneOff = json['oneOff'];
    inactive = json['inactive'];
    minimumStock = json['minimumStock'];
    maximumStock = json['maximumStock'];
    minimalPurchase = json['minimalPurchase'];
    compositionType = json['compositionType'];
    storeUnit = json['storeUnit'];
    storeRatio = json['storeRatio'];
    bulkUnit = json['bulkUnit'];
    bulkRatio = json['bulkRatio'];
    statistics = json['statistics'];
    useOfSerialNumbers = json['useOfSerialNumbers'];
    costPrice = json['costPrice'];
    printStickers = json['printStickers'];
    imagePath = json['imagePath'];
    abcCode = json['abcCode'];
    isAssembly = json['isAssembly'];
    assemblyRecommendation = json['assemblyRecommendation'];
    percentageLoss = json['percentageLoss'];
    assemblyReferenceJournalEntryCode = json['assemblyReferenceJournalEntryCode'];
    assemblyCosts = json['assemblyCosts'];
    assemblyWarehouseCode = json['assemblyWarehouseCode'];
    assemblyLocationCode = json['assemblyLocationCode'];
    surplusLocationCode = json['surplusLocationCode'];
    numberOfUnitsPerWorkingDay = json['numberOfUnitsPerWorkingDay'];
    numberOfDaysPerUnit = json['numberOfDaysPerUnit'];
    numberOfSafetyDays = json['numberOfSafetyDays'];
    assemblyInstruction = json['assemblyInstruction'];
    assemblySubContractedWork = json['assemblySubContractedWork'];
    assemblyOnlyThroughOutsourcedWork = json['assemblyOnlyThroughOutsourcedWork'];
    assemblyForecastNumber = json['assemblyForecastNumber'];
    usePartialRelocation = json['usePartialRelocation'];
    useComponentPartial = json['useComponentPartial'];
    partialRelocationMinimum = json['partialRelocationMinimum'];
    applySubAssemblyEndProduct = json['applySubAssemblyEndProduct'];
    applySubAssemblyComponent = json['applySubAssemblyComponent'];
    subAssemblyApplicationType = json['subAssemblyApplicationType'];
    alternativeUnitCode = json['alternativeUnitCode'];
    packingRatioAlternativeUnit = json['packingRatioAlternativeUnit'];
    externalStatus = json['externalStatus'];
    stockCosts = json['stockCosts'];
    stockCostPercentage = json['stockCostPercentage'];
    salesPriceBasedOnComponents = json['salesPriceBasedOnComponents'];
    factMeasure = json['factMeasure'];
    percentagePriceControl = json['percentagePriceControl'];
    propertiesToInclude = json['propertiesToInclude'];
  }
  String? id;
  String? adminCode;
  String? countryCodeOrigin;
  String? countryCodeProvenance;
  String? description;
  String? eanCodeGenerationKey;
  int?    eanCode;
  String? eanCodeAsText;
  int?   length;
  int?   width;
  int?   heigth;
  int?   weight;
  String? externalProductCode;
  String? productGroupCodeExternalProduct;
  int? guarantee;
  String? locationCode;
  String? packingUnit;
  int? packingRatio;
  String? productCode;
  String? referenceJournalEntryCode;
  String? searchName;
  String? searchKeys;
  String? unitCode;
  String? vatGroup;
  String? warehouseCode;
  bool? stockRegistration;
  bool? discontinued;
  bool? stockKeeping;
  bool? purchaseOrderRecommendation;
  bool? blocked;
  bool? batchRegistration;
  bool? oneOff;
  bool? inactive;
  int? minimumStock;
  int? maximumStock;
  int? minimalPurchase;
  String? compositionType;
  String? storeUnit;
  int? storeRatio;
  String? bulkUnit;
  int? bulkRatio;
  String? statistics;
  String? useOfSerialNumbers;
  double? costPrice;
  int? printStickers;
  String? imagePath;
  String? abcCode;
  bool? isAssembly;
  bool? assemblyRecommendation;
  int? percentageLoss;
  String? assemblyReferenceJournalEntryCode;
  int? assemblyCosts;
  String? assemblyWarehouseCode;
  String? assemblyLocationCode;
  String? surplusLocationCode;
  int? numberOfUnitsPerWorkingDay;
  int? numberOfDaysPerUnit;
  int? numberOfSafetyDays;
  String? assemblyInstruction;
  bool? assemblySubContractedWork;
  bool? assemblyOnlyThroughOutsourcedWork;
  int? assemblyForecastNumber;
  String? usePartialRelocation;
  String? useComponentPartial;
  int? partialRelocationMinimum;
  bool? applySubAssemblyEndProduct;
  bool? applySubAssemblyComponent;
  String? subAssemblyApplicationType;
  String? alternativeUnitCode;
  int? packingRatioAlternativeUnit;
  String? externalStatus;
  int? stockCosts;
  int? stockCostPercentage;
  bool? salesPriceBasedOnComponents;
  int? factMeasure;
  int? percentagePriceControl;
  String? propertiesToInclude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['adminCode'] = adminCode;
    map['countryCodeOrigin'] = countryCodeOrigin;
    map['countryCodeProvenance'] = countryCodeProvenance;
    map['description'] = description;
    map['eanCodeGenerationKey'] = eanCodeGenerationKey;
    map['eanCode'] = eanCode;
    map['eanCodeAsText'] = eanCodeAsText;
    map['length'] = length;
    map['width'] = width;
    map['heigth'] = heigth;
    map['weight'] = weight;
    map['externalProductCode'] = externalProductCode;
    map['productGroupCodeExternalProduct'] = productGroupCodeExternalProduct;
    map['guarantee'] = guarantee;
    map['locationCode'] = locationCode;
    map['packingUnit'] = packingUnit;
    map['packingRatio'] = packingRatio;
    map['productCode'] = productCode;
    map['referenceJournalEntryCode'] = referenceJournalEntryCode;
    map['searchName'] = searchName;
    map['searchKeys'] = searchKeys;
    map['unitCode'] = unitCode;
    map['vatGroup'] = vatGroup;
    map['warehouseCode'] = warehouseCode;
    map['stockRegistration'] = stockRegistration;
    map['discontinued'] = discontinued;
    map['stockKeeping'] = stockKeeping;
    map['purchaseOrderRecommendation'] = purchaseOrderRecommendation;
    map['blocked'] = blocked;
    map['batchRegistration'] = batchRegistration;
    map['oneOff'] = oneOff;
    map['inactive'] = inactive;
    map['minimumStock'] = minimumStock;
    map['maximumStock'] = maximumStock;
    map['minimalPurchase'] = minimalPurchase;
    map['compositionType'] = compositionType;
    map['storeUnit'] = storeUnit;
    map['storeRatio'] = storeRatio;
    map['bulkUnit'] = bulkUnit;
    map['bulkRatio'] = bulkRatio;
    map['statistics'] = statistics;
    map['useOfSerialNumbers'] = useOfSerialNumbers;
    map['costPrice'] = costPrice;
    map['printStickers'] = printStickers;
    map['imagePath'] = imagePath;
    map['abcCode'] = abcCode;
    map['isAssembly'] = isAssembly;
    map['assemblyRecommendation'] = assemblyRecommendation;
    map['percentageLoss'] = percentageLoss;
    map['assemblyReferenceJournalEntryCode'] = assemblyReferenceJournalEntryCode;
    map['assemblyCosts'] = assemblyCosts;
    map['assemblyWarehouseCode'] = assemblyWarehouseCode;
    map['assemblyLocationCode'] = assemblyLocationCode;
    map['surplusLocationCode'] = surplusLocationCode;
    map['numberOfUnitsPerWorkingDay'] = numberOfUnitsPerWorkingDay;
    map['numberOfDaysPerUnit'] = numberOfDaysPerUnit;
    map['numberOfSafetyDays'] = numberOfSafetyDays;
    map['assemblyInstruction'] = assemblyInstruction;
    map['assemblySubContractedWork'] = assemblySubContractedWork;
    map['assemblyOnlyThroughOutsourcedWork'] = assemblyOnlyThroughOutsourcedWork;
    map['assemblyForecastNumber'] = assemblyForecastNumber;
    map['usePartialRelocation'] = usePartialRelocation;
    map['useComponentPartial'] = useComponentPartial;
    map['partialRelocationMinimum'] = partialRelocationMinimum;
    map['applySubAssemblyEndProduct'] = applySubAssemblyEndProduct;
    map['applySubAssemblyComponent'] = applySubAssemblyComponent;
    map['subAssemblyApplicationType'] = subAssemblyApplicationType;
    map['alternativeUnitCode'] = alternativeUnitCode;
    map['packingRatioAlternativeUnit'] = packingRatioAlternativeUnit;
    map['externalStatus'] = externalStatus;
    map['stockCosts'] = stockCosts;
    map['stockCostPercentage'] = stockCostPercentage;
    map['salesPriceBasedOnComponents'] = salesPriceBasedOnComponents;
    map['factMeasure'] = factMeasure;
    map['percentagePriceControl'] = percentagePriceControl;
    map['propertiesToInclude'] = propertiesToInclude;
    return map;
  }

}