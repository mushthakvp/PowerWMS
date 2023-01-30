import 'package:scanner/models/result_data_model.dart';


class ProductStock {
  ProductStock({
    this.productIdentifierFrom,
    this.productIdentifierTill,
    this.unitCode,
    this.skipNotExistingProducts,
    this.warehouseGroup,
    this.stockDate,
    this.onlyActiveProducts,
    this.calcAssemblyDate,
    this.amountToAssemble,
    this.resultData,
    this.propertiesToInclude,
    this.offset,
    this.price,
    this.limit,
    this.useFieldCodes,
  });

  ProductStock.fromJson(Map<String, dynamic> json) {
    productIdentifierFrom = json['productIdentifierFrom'];
    productIdentifierTill = json['productIdentifierTill'];
    unitCode = json['unitCode'];
    skipNotExistingProducts = json['skipNotExistingProducts'];
    warehouseGroup = json['warehouseGroup'];
    stockDate = json['stockDate'];
    onlyActiveProducts = json['onlyActiveProducts'];
    calcAssemblyDate = json['calcAssemblyDate'];
    amountToAssemble = json['amountToAssemble'];
    if (json['resultData'] != null) {
      resultData = [];
      json['resultData'].forEach((v) {
        resultData?.add(ResultData.fromJson(v));
      });
    }
    propertiesToInclude = json['propertiesToInclude'];
    offset = json['offset'];
    limit = json['limit'];
    useFieldCodes = json['useFieldCodes'];
  }

  String? productIdentifierFrom;
  String? productIdentifierTill;
  String? unitCode;
  bool? skipNotExistingProducts;
  String? warehouseGroup;
  String? stockDate;
  bool? onlyActiveProducts;
  bool? calcAssemblyDate;
  int? amountToAssemble;
  double? price;
  List<ResultData>? resultData;
  String? propertiesToInclude;
  int? offset;
  int? limit;
  bool? useFieldCodes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productIdentifierFrom'] = productIdentifierFrom;
    map['productIdentifierTill'] = productIdentifierTill;
    map['unitCode'] = unitCode;
    map['skipNotExistingProducts'] = skipNotExistingProducts;
    map['warehouseGroup'] = warehouseGroup;
    map['stockDate'] = stockDate;
    map['onlyActiveProducts'] = onlyActiveProducts;
    map['calcAssemblyDate'] = calcAssemblyDate;
    map['amountToAssemble'] = amountToAssemble;
    if (resultData != null) {
      map['resultData'] = resultData?.map((v) => v.toJson()).toList();
    }
    map['propertiesToInclude'] = propertiesToInclude;
    map['offset'] = offset;
    map['limit'] = limit;
    map['useFieldCodes'] = useFieldCodes;
    return map;
  }

  ProductStock copyWith({double? priceValue}) => ProductStock(
      productIdentifierFrom: productIdentifierFrom,
      productIdentifierTill: productIdentifierTill,
      unitCode: unitCode,
      skipNotExistingProducts: skipNotExistingProducts,
      warehouseGroup: warehouseGroup,
      stockDate: stockDate,
      onlyActiveProducts: onlyActiveProducts,
      calcAssemblyDate: calcAssemblyDate,
      amountToAssemble: amountToAssemble,
      resultData: resultData,
      propertiesToInclude: propertiesToInclude,
      offset: offset,
      price: priceValue ?? price,
      limit: limit,
      useFieldCodes: useFieldCodes);
}
