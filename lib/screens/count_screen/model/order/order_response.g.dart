// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      id: json['id'] as String?,
      adminCode: json['adminCode'] as String?,
      branchCode: json['branchCode'] as String?,
      calculateVat: json['calculateVat'] as String?,
      currencyCode: json['currencyCode'] as String?,
      customerCode: json['customerCode'] as String?,
      enteredByUser: json['enteredByUser'] as String?,
      orderType: json['orderType'] as String?,
      orderTypeCode: json['orderTypeCode'] as String?,
      propertiesToInclude: json['propertiesToInclude'] as String?,
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'adminCode': instance.adminCode,
      'branchCode': instance.branchCode,
      'calculateVat': instance.calculateVat,
      'currencyCode': instance.currencyCode,
      'customerCode': instance.customerCode,
      'enteredByUser': instance.enteredByUser,
      'orderType': instance.orderType,
      'orderTypeCode': instance.orderTypeCode,
      'propertiesToInclude': instance.propertiesToInclude,
    };
