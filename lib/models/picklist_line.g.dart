// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicklistLine _$PicklistLineFromJson(Map<String, dynamic> json) {
  return PicklistLine(
    picklist: json['picklist'] as String,
    picklistId: json['picklistId'] as int,
    line: json['line'] as int,
    uid: json['uid'] as String,
    warehouse: json['warehouse'] as String,
    warehouseId: json['warehouseId'] as int,
    lineDate: json['lineDate'] as String,
    pickAmount: json['pickAmount'] as num,
    canceledAmount: json['canceledAmount'] as num,
    pickedAmount: json['pickedAmount'] as num,
    available: json['available'] as num,
    descriptionA: json['descriptionA'] as String,
    descriptionB: json['descriptionB'] as String,
    internalMemo: json['internalMemo'] as String,
    status: json['status'] as int,
    product: Product.fromJson(json['product'] as Map<String, dynamic>),
    location: json['location'] as String,
    id: json['id'] as int,
    isNew: json['isNew'] as bool,
  );
}

Map<String, dynamic> _$PicklistLineToJson(PicklistLine instance) =>
    <String, dynamic>{
      'picklist': instance.picklist,
      'picklistId': instance.picklistId,
      'line': instance.line,
      'uid': instance.uid,
      'warehouse': instance.warehouse,
      'warehouseId': instance.warehouseId,
      'lineDate': instance.lineDate,
      'pickAmount': instance.pickAmount,
      'canceledAmount': instance.canceledAmount,
      'pickedAmount': instance.pickedAmount,
      'available': instance.available,
      'descriptionA': instance.descriptionA,
      'descriptionB': instance.descriptionB,
      'internalMemo': instance.internalMemo,
      'status': instance.status,
      'product': instance.product,
      'location': instance.location,
      'id': instance.id,
      'isNew': instance.isNew,
    };
