class ProductStock {
  ProductStock({
    // this.unitCode,
    // this.warehouse,
    // this.warehouseGroup,
    this.resultData,
    // this.propertiesToInclude,
    // this.offset,
    // this.limit,
    // this.useFieldCodes,
  });

  // final String? unitCode;
  // final String? warehouse;
  // final String? warehouseGroup;
  final List<ResultData>? resultData;

  // final String? propertiesToInclude;
  // final int? offset;
  // final int? limit;
  // final bool? useFieldCodes;

  ProductStock copyWith({
    String? unitCode,
    String? warehouse,
    String? warehouseGroup,
    List<ResultData>? resultData,
    String? propertiesToInclude,
    int? offset,
    int? limit,
    bool? useFieldCodes,
  }) {
    return ProductStock(
      // unitCode: unitCode ?? this.unitCode,
      // warehouse: warehouse ?? this.warehouse,
      // warehouseGroup: warehouseGroup ?? this.warehouseGroup,
      resultData: resultData ?? this.resultData,
      // propertiesToInclude: propertiesToInclude ?? this.propertiesToInclude,
      // offset: offset ?? this.offset,
      // limit: limit ?? this.limit,
      // useFieldCodes: useFieldCodes ?? this.useFieldCodes,
    );
  }

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      // unitCode: json['unitCode'],
      // warehouse: json['warehouse'],
      // warehouseGroup: json['warehouseGroup'],
      resultData: List.from(json['resultData'])
          .map((e) => ResultData.fromJson(e))
          .toList(),
      // propertiesToInclude: json['propertiesToInclude'],
      // offset: json['offset'],
      // limit: json['limit'],
      // useFieldCodes: json['useFieldCodes'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['unitCode'] = unitCode;
    // _data['warehouse'] = warehouse;
    // _data['warehouseGroup'] = warehouseGroup;
    _data['resultData'] = resultData?.map((e) => e.toJson()).toList();
    // _data['propertiesToInclude'] = propertiesToInclude;
    // _data['offset'] = offset;
    // _data['limit'] = limit;
    // _data['useFieldCodes'] = useFieldCodes;
    return _data;
  }
}

class ResultData {
  ResultData({
    // required this.productIdentifier,
    this.unitCode,
    this.unitInfo,
    this.locationStock,
  });

  // final ProductIdentifier? productIdentifier;
  final String? unitCode;
  final UnitInfo? unitInfo;
  final List<LocationStock>? locationStock;

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      // productIdentifier: ProductIdentifier.fromJson(json['productIdentifier']),
      unitCode: json['unitCode'],
      unitInfo: UnitInfo.fromJson(json['unitInfo']),
      locationStock: List.from(json['locationStock'])
          .map((e) => LocationStock.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    // _data['productIdentifier'] = productIdentifier?.toJson();
    _data['unitCode'] = unitCode;
    _data['unitInfo'] = unitInfo?.toJson();
    _data['locationStock'] = locationStock?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class ProductIdentifier {
  ProductIdentifier({
    required this.productCode,
    required this.externalProductCode,
    required this.productGroupCodeExternalProduct,
  });

  late final String productCode;
  late final String externalProductCode;
  late final String productGroupCodeExternalProduct;

  ProductIdentifier.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    externalProductCode = json['externalProductCode'];
    productGroupCodeExternalProduct = json['productGroupCodeExternalProduct'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productCode'] = productCode;
    _data['externalProductCode'] = externalProductCode;
    _data['productGroupCodeExternalProduct'] = productGroupCodeExternalProduct;
    return _data;
  }
}

class UnitInfo {
  UnitInfo({
    required this.id,
    required this.description,
  });

  late final String id;
  late final String description;

  UnitInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['description'] = description;
    return _data;
  }
}

class LocationStock {
  LocationStock({
    this.warehouseCode,
    // required this.warehouseInfo,
    this.locationCode,
    this.locationInfo,
    this.batchCode,
    this.physicalStock,
    this.blocked,
    this.locationBlockCode,
  });

  final String? warehouseCode;

  // final WarehouseInfo warehouseInfo;
  final String? locationCode;
  final LocationInfo? locationInfo;
  final String? batchCode;
  final double? physicalStock;
  final bool? blocked;
  final String? locationBlockCode;

  factory LocationStock.fromJson(Map<String, dynamic> json) {
    return LocationStock(
      warehouseCode: json['warehouseCode'],
      // warehouseInfo: WarehouseInfo.fromJson(json['warehouseInfo']),
      locationCode: json['locationCode'],
      locationInfo: LocationInfo.fromJson(json['locationInfo']),
      batchCode: json['batchCode'],
      physicalStock: json['physicalStock']?.toDouble(),
      blocked: json['blocked'],
      locationBlockCode: json['locationBlockCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['warehouseCode'] = warehouseCode;
    // _data['warehouseInfo'] = warehouseInfo.toJson();
    _data['locationCode'] = locationCode;
    _data['locationInfo'] = locationInfo?.toJson();
    _data['batchCode'] = batchCode;
    _data['physicalStock'] = physicalStock;
    _data['blocked'] = blocked;
    _data['locationBlockCode'] = locationBlockCode;
    return _data;
  }
}

// class WarehouseInfo {
//   WarehouseInfo({
//     required this.id,
//     required this.warehouseInfo,
//     required this.warehouseUse,
//     required this.warehouseUseDescription,
//     required this.warehouseBlockCode,
//     required this.warehouseGroupCode,
//     required this.warehouseGroupInfo,
//     required this.branchCode,
//     required this.branchInfo,
//   });
//
//   late final String id;
//   late final WarehouseInfo warehouseInfo;
//   late final String warehouseUse;
//   late final String warehouseUseDescription;
//   late final String warehouseBlockCode;
//   late final String warehouseGroupCode;
//   late final WarehouseGroupInfo warehouseGroupInfo;
//   late final String branchCode;
//   late final BranchInfo branchInfo;
//
//   WarehouseInfo.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     warehouseInfo = WarehouseInfo.fromJson(json['warehouseInfo']);
//     warehouseUse = json['warehouseUse'];
//     warehouseUseDescription = json['warehouseUseDescription'];
//     warehouseBlockCode = json['warehouseBlockCode'];
//     warehouseGroupCode = json['warehouseGroupCode'];
//     warehouseGroupInfo =
//         WarehouseGroupInfo.fromJson(json['warehouseGroupInfo']);
//     branchCode = json['branchCode'];
//     branchInfo = BranchInfo.fromJson(json['branchInfo']);
//   }
//
//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['id'] = id;
//     _data['warehouseInfo'] = warehouseInfo.toJson();
//     _data['warehouseUse'] = warehouseUse;
//     _data['warehouseUseDescription'] = warehouseUseDescription;
//     _data['warehouseBlockCode'] = warehouseBlockCode;
//     _data['warehouseGroupCode'] = warehouseGroupCode;
//     _data['warehouseGroupInfo'] = warehouseGroupInfo.toJson();
//     _data['branchCode'] = branchCode;
//     _data['branchInfo'] = branchInfo.toJson();
//     return _data;
//   }
// }

class WarehouseGroupInfo {
  WarehouseGroupInfo({
    required this.id,
    required this.description,
  });

  late final String id;
  late final String description;

  WarehouseGroupInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['description'] = description;
    return _data;
  }
}

class BranchInfo {
  BranchInfo({
    required this.branchCode,
    required this.description,
  });

  late final String branchCode;
  late final String description;

  BranchInfo.fromJson(Map<String, dynamic> json) {
    branchCode = json['branchCode'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['branchCode'] = branchCode;
    _data['description'] = description;
    return _data;
  }
}

class LocationInfo {
  LocationInfo({
    required this.id,
    required this.wareHouseCode,
    required this.wareHouseLocationCode,
    required this.abcCode,
    required this.block,
    required this.eanCode,
    required this.fixedProductLocation,
    required this.heigth,
    required this.inactive,
    required this.length,
    required this.stock,
    required this.typeOfUse,
    required this.weigthPresent,
    required this.width,
  });

  final String? id;
  final String? wareHouseCode;
  final String? wareHouseLocationCode;
  final String? abcCode;
  final String? block;
  final String? eanCode;
  final bool? fixedProductLocation;
  final double? heigth;
  final bool? inactive;
  final double? length;
  final bool? stock;
  final String? typeOfUse;
  final double? weigthPresent;
  final double? width;

  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      id: json['id'],
      wareHouseCode: json['wareHouseCode'],
      wareHouseLocationCode: json['wareHouseLocationCode'],
      abcCode: json['abcCode'],
      block: json['block'],
      eanCode: json['eanCode'],
      fixedProductLocation: json['fixedProductLocation'],
      heigth: json['heigth'].toDouble(),
      inactive: json['inactive'],
      length: json['length'].toDouble(),
      stock: json['stock'],
      typeOfUse: json['typeOfUse'],
      weigthPresent: json['weigthPresent'].toDouble(),
      width: json['width'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['wareHouseCode'] = wareHouseCode;
    _data['wareHouseLocationCode'] = wareHouseLocationCode;
    _data['abcCode'] = abcCode;
    _data['block'] = block;
    _data['eanCode'] = eanCode;
    _data['fixedProductLocation'] = fixedProductLocation;
    _data['heigth'] = heigth;
    _data['inactive'] = inactive;
    _data['length'] = length;
    _data['stock'] = stock;
    _data['typeOfUse'] = typeOfUse;
    _data['weigthPresent'] = weigthPresent;
    _data['width'] = width;
    return _data;
  }
}
