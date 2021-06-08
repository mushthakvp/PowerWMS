// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picklist _$PicklistFromJson(Map<String, dynamic> json) {
  return Picklist(
    timezone: json['timezone'] as String,
    uid: json['uid'] as String,
    orderDate: json['orderDate'] as String,
    orderDateFormatted: json['orderDateFormatted'] as String,
    deliveryDate: json['deliveryDate'] as String,
    deliveryDateFormatted: json['deliveryDateFormatted'] as String,
    debtor: _debtorFromJson(json['debtor'] as Map<String, dynamic>),
    agent: json['agent'] as String,
    colliAmount: (json['colliAmount'] as num).toDouble(),
    palletAmount: (json['palletAmount'] as num).toDouble(),
    invoiceId: json['invoiceId'] as String,
    deliveryConditionId: json['deliveryConditionId'] as String,
    internalMemo: json['internalMemo'] as String,
    picker: json['picker'] as String,
    lines: json['lines'] as int,
    status: json['status'] as int,
    hasCancelled: json['hasCancelled'] as bool,
    id: json['id'] as int,
    isNew: json['isNew'] as bool,
  );
}

Map<String, dynamic> _$PicklistToJson(Picklist instance) => <String, dynamic>{
      'timezone': instance.timezone,
      'uid': instance.uid,
      'orderDate': instance.orderDate,
      'orderDateFormatted': instance.orderDateFormatted,
      'deliveryDate': instance.deliveryDate,
      'deliveryDateFormatted': instance.deliveryDateFormatted,
      'debtor': _debtorToJson(instance.debtor),
      'agent': instance.agent,
      'colliAmount': instance.colliAmount,
      'palletAmount': instance.palletAmount,
      'invoiceId': instance.invoiceId,
      'deliveryConditionId': instance.deliveryConditionId,
      'internalMemo': instance.internalMemo,
      'picker': instance.picker,
      'lines': instance.lines,
      'status': instance.status,
      'hasCancelled': instance.hasCancelled,
      'id': instance.id,
      'isNew': instance.isNew,
    };
