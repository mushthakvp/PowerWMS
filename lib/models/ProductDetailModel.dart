class ProductDetailModel {
  ProductDetailModel({
    this.locationCode,
    this.warehouseCode,
  });

  ProductDetailModel.fromJson(dynamic json) {
    locationCode = json['locationCode'];
    warehouseCode = json['warehouseCode'];
  }

  String? locationCode;
  String? warehouseCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['locationCode'] = locationCode;

    map['warehouseCode'] = warehouseCode;

    return map;
  }
}
