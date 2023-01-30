class ProductIdentifier {
  ProductIdentifier({
    this.productCode,
    this.externalProductCode,
    this.productGroupCodeExternalProduct,});

  ProductIdentifier.fromJson(dynamic json) {
    productCode = json['productCode'];
    externalProductCode = json['externalProductCode'];
    productGroupCodeExternalProduct = json['productGroupCodeExternalProduct'];
  }
  String? productCode;
  String? externalProductCode;
  String? productGroupCodeExternalProduct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productCode'] = productCode;
    map['externalProductCode'] = externalProductCode;
    map['productGroupCodeExternalProduct'] = productGroupCodeExternalProduct;
    return map;
  }

}