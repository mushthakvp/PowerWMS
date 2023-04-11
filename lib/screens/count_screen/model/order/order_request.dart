import 'dart:convert';

String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  OrderRequest({
    this.orderTypeCode,
    this.customerCode,
    this.lastChangedByUser,
    this.lines,
    this.propertiesToInclude,
  });

  final String? orderTypeCode;
  final String? customerCode;
  final String? lastChangedByUser;
  final List<OrderLine>? lines;
  final String? propertiesToInclude;

  Map<String, dynamic> toJson() => {
    "orderTypeCode": orderTypeCode,
    "customerCode": customerCode,
    "lastChangedByUser": lastChangedByUser,
    "lines": lines == null ? null : List<dynamic>.from(lines!.map((x) => x.toJson())),
    "propertiesToInclude": propertiesToInclude,
  };
}

class OrderLine {
  OrderLine({
    this.productIdentifier,
    this.unitCode,
    this.qtyOrdered,
  });

  final ProductIdentifier? productIdentifier;
  final String? unitCode;
  final int? qtyOrdered;

  Map<String, dynamic> toJson() => {
    "productIdentifier": productIdentifier?.toJson(),
    "unitCode": unitCode,
    "qtyOrdered": qtyOrdered,
  };
}

class ProductIdentifier {
  ProductIdentifier({
    this.productCode,
  });

  final String? productCode;

  Map<String, dynamic> toJson() => {
    "productCode": productCode,
  };
}
