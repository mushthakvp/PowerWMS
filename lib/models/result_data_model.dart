import 'package:scanner/models/product_identifier_model.dart';


class ResultData {
  ResultData({
    this.productIdentifier,
    this.unitCode,
    this.discontinued,
    this.freeStock,
    this.freeStockNoPurch,
    this.actualStock,
    this.reservedStock,
    this.blockedStock,
    this.availableStock,
    this.availableStockNoPurch,
    this.availableStockForSales,
    this.dateAvailablePreferredSupplier,
    this.nextDateAvailable,
    this.nextStockQuantity,
    this.actualStockBasedOnComponents,
    this.availableStockBasedOnComponents,
    this.availableStockBasedOnComponentsOnDate,
    this.assemblyDateAvailable,});

  ResultData.fromJson(dynamic json) {
    productIdentifier = json['productIdentifier'] != null ? ProductIdentifier.fromJson(json['productIdentifier']) : null;
    unitCode = json['unitCode'];
    discontinued = json['discontinued'];
    freeStock = json['freeStock'];
    freeStockNoPurch = json['freeStockNoPurch'];
    actualStock = json['actualStock'];
    reservedStock = json['reservedStock'];
    blockedStock = json['blockedStock'];
    availableStock = json['availableStock'];
    availableStockNoPurch = json['availableStockNoPurch'];
    availableStockForSales = json['availableStockForSales'];
    dateAvailablePreferredSupplier = json['dateAvailablePreferredSupplier'];
    nextDateAvailable = json['nextDateAvailable'];
    nextStockQuantity = json['nextStockQuantity'];
    actualStockBasedOnComponents = json['actualStockBasedOnComponents'];
    availableStockBasedOnComponents = json['availableStockBasedOnComponents'];
    availableStockBasedOnComponentsOnDate = json['availableStockBasedOnComponentsOnDate'];
    assemblyDateAvailable = json['assemblyDateAvailable'];
  }
  ProductIdentifier? productIdentifier;
  String? unitCode;
  bool? discontinued;
  double? freeStock;
  double? freeStockNoPurch;
  double? actualStock;
  double? reservedStock;
  double? blockedStock;
  double? availableStock;
  double? availableStockNoPurch;
  double? availableStockForSales;
  String? dateAvailablePreferredSupplier;
  String? nextDateAvailable;
  double? nextStockQuantity;
  double? actualStockBasedOnComponents;
  double? availableStockBasedOnComponents;
  dynamic availableStockBasedOnComponentsOnDate;
  dynamic assemblyDateAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (productIdentifier != null) {
      map['productIdentifier'] = productIdentifier?.toJson();
    }
    map['unitCode'] = unitCode;
    map['discontinued'] = discontinued;
    map['freeStock'] = freeStock;
    map['freeStockNoPurch'] = freeStockNoPurch;
    map['actualStock'] = actualStock;
    map['reservedStock'] = reservedStock;
    map['blockedStock'] = blockedStock;
    map['availableStock'] = availableStock;
    map['availableStockNoPurch'] = availableStockNoPurch;
    map['availableStockForSales'] = availableStockForSales;
    map['dateAvailablePreferredSupplier'] = dateAvailablePreferredSupplier;
    map['nextDateAvailable'] = nextDateAvailable;
    map['nextStockQuantity'] = nextStockQuantity;
    map['actualStockBasedOnComponents'] = actualStockBasedOnComponents;
    map['availableStockBasedOnComponents'] = availableStockBasedOnComponents;
    map['availableStockBasedOnComponentsOnDate'] = availableStockBasedOnComponentsOnDate;
    map['assemblyDateAvailable'] = assemblyDateAvailable;
    return map;
  }

}