/// id : "100100,DOOSA,no,2017-01-01,,"
/// adminCode : "01"
/// productIdentifier : {"productCode":"100100","externalProductCode":"","productGroupCodeExternalProduct":""}
/// unitCode : "DOOSA"
/// promotion : false
/// startDate : "2017-01-01"
/// endDate : "9999-12-31"
/// hasExpired : false
/// price : 49.23
/// currencyCode : ""
/// ladderCode : ""
/// pricePer : 4.0
/// propertiesToInclude : ""

class ProductPriceModel {
  ProductPriceModel({
      String? id, 
      String? adminCode, 
      ProductIdentifier? productIdentifier, 
      String? unitCode, 
      bool? promotion, 
      String? startDate, 
      String? endDate, 
      bool? hasExpired, 
      num? price, 
      String? currencyCode, 
      String? ladderCode, 
      num? pricePer, 
      String? propertiesToInclude,}){
    _id = id;
    _adminCode = adminCode;
    _productIdentifier = productIdentifier;
    _unitCode = unitCode;
    _promotion = promotion;
    _startDate = startDate;
    _endDate = endDate;
    _hasExpired = hasExpired;
    _price = price;
    _currencyCode = currencyCode;
    _ladderCode = ladderCode;
    _pricePer = pricePer;
    _propertiesToInclude = propertiesToInclude;
}

  ProductPriceModel.fromJson(dynamic json) {
    _id = json['id'];
    _adminCode = json['adminCode'];
    _productIdentifier = json['productIdentifier'] != null ? ProductIdentifier.fromJson(json['productIdentifier']) : null;
    _unitCode = json['unitCode'];
    _promotion = json['promotion'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
    _hasExpired = json['hasExpired'];
    _price = json['price'];
    _currencyCode = json['currencyCode'];
    _ladderCode = json['ladderCode'];
    _pricePer = json['pricePer'];
    _propertiesToInclude = json['propertiesToInclude'];
  }
  String? _id;
  String? _adminCode;
  ProductIdentifier? _productIdentifier;
  String? _unitCode;
  bool? _promotion;
  String? _startDate;
  String? _endDate;
  bool? _hasExpired;
  num? _price;
  String? _currencyCode;
  String? _ladderCode;
  num? _pricePer;
  String? _propertiesToInclude;
ProductPriceModel copyWith({  String? id,
  String? adminCode,
  ProductIdentifier? productIdentifier,
  String? unitCode,
  bool? promotion,
  String? startDate,
  String? endDate,
  bool? hasExpired,
  num? price,
  String? currencyCode,
  String? ladderCode,
  num? pricePer,
  String? propertiesToInclude,
}) => ProductPriceModel(  id: id ?? _id,
  adminCode: adminCode ?? _adminCode,
  productIdentifier: productIdentifier ?? _productIdentifier,
  unitCode: unitCode ?? _unitCode,
  promotion: promotion ?? _promotion,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  hasExpired: hasExpired ?? _hasExpired,
  price: price ?? _price,
  currencyCode: currencyCode ?? _currencyCode,
  ladderCode: ladderCode ?? _ladderCode,
  pricePer: pricePer ?? _pricePer,
  propertiesToInclude: propertiesToInclude ?? _propertiesToInclude,
);
  String? get id => _id;
  String? get adminCode => _adminCode;
  ProductIdentifier? get productIdentifier => _productIdentifier;
  String? get unitCode => _unitCode;
  bool? get promotion => _promotion;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  bool? get hasExpired => _hasExpired;
  num? get price => _price;
  String? get currencyCode => _currencyCode;
  String? get ladderCode => _ladderCode;
  num? get pricePer => _pricePer;
  String? get propertiesToInclude => _propertiesToInclude;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['adminCode'] = _adminCode;
    if (_productIdentifier != null) {
      map['productIdentifier'] = _productIdentifier?.toJson();
    }
    map['unitCode'] = _unitCode;
    map['promotion'] = _promotion;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['hasExpired'] = _hasExpired;
    map['price'] = _price;
    map['currencyCode'] = _currencyCode;
    map['ladderCode'] = _ladderCode;
    map['pricePer'] = _pricePer;
    map['propertiesToInclude'] = _propertiesToInclude;
    return map;
  }

}

/// productCode : "100100"
/// externalProductCode : ""
/// productGroupCodeExternalProduct : ""

class ProductIdentifier {
  ProductIdentifier({
      String? productCode, 
      String? externalProductCode, 
      String? productGroupCodeExternalProduct,}){
    _productCode = productCode;
    _externalProductCode = externalProductCode;
    _productGroupCodeExternalProduct = productGroupCodeExternalProduct;
}

  ProductIdentifier.fromJson(dynamic json) {
    _productCode = json['productCode'];
    _externalProductCode = json['externalProductCode'];
    _productGroupCodeExternalProduct = json['productGroupCodeExternalProduct'];
  }
  String? _productCode;
  String? _externalProductCode;
  String? _productGroupCodeExternalProduct;
ProductIdentifier copyWith({  String? productCode,
  String? externalProductCode,
  String? productGroupCodeExternalProduct,
}) => ProductIdentifier(  productCode: productCode ?? _productCode,
  externalProductCode: externalProductCode ?? _externalProductCode,
  productGroupCodeExternalProduct: productGroupCodeExternalProduct ?? _productGroupCodeExternalProduct,
);
  String? get productCode => _productCode;
  String? get externalProductCode => _externalProductCode;
  String? get productGroupCodeExternalProduct => _productGroupCodeExternalProduct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['productCode'] = _productCode;
    map['externalProductCode'] = _externalProductCode;
    map['productGroupCodeExternalProduct'] = _productGroupCodeExternalProduct;
    return map;
  }

}