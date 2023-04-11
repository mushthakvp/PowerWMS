import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderResponse {
  OrderResponse({
    this.id,
    this.adminCode,
    this.branchCode,
    this.calculateVat,
    this.currencyCode,
    this.customerCode,
    this.enteredByUser,
    this.orderType,
    this.orderTypeCode,
    this.propertiesToInclude,
  });

  final String? id;
  final String? adminCode;
  final String? branchCode;
  final String? calculateVat;
  final String? currencyCode;
  final String? customerCode;
  final String? enteredByUser;
  final String? orderType;
  final String? orderTypeCode;
  final String? propertiesToInclude;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}
