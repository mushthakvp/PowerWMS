// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picklist _$PicklistFromJson(Map<String, dynamic> json) => Picklist(
      timezone: json['timezone'] as String?,
      uid: json['uid'] as String,
      orderDate: json['orderDate'] as String?,
      orderDateFormatted: json['orderDateFormatted'] as String?,
      deliveryDate: json['deliveryDate'] as String?,
      deliveryDateFormatted: json['deliveryDateFormatted'] as String?,
      debtor: json['debtor'] == null
          ? null
          : Debtor.fromJson(json['debtor'] as Map<String, dynamic>),
      agent: json['agent'] as String?,
      colliAmount: (json['colliAmount'] as num?)?.toDouble(),
      palletAmount: (json['palletAmount'] as num?)?.toDouble(),
      invoiceId: json['invoiceId'] as String?,
      deliveryConditionId: json['deliveryConditionId'] as String?,
      orderReference: json['orderReference'] as String?,
      internalMemo: json['internalMemo'] as String?,
      picker: json['picker'] as String?,
      lines: json['lines'] as int,
      status: $enumDecode(_$PicklistStatusEnumMap, json['status']),
      hasCancelled: json['hasCancelled'] as bool,
      id: json['id'] as int,
      isNew: json['isNew'] as bool,
      defaultStatus:
          $enumDecodeNullable(_$PicklistStatusEnumMap, json['defaultStatus']),
    );

Map<String, dynamic> _$PicklistToJson(Picklist instance) => <String, dynamic>{
      'timezone': instance.timezone,
      'uid': instance.uid,
      'orderDate': instance.orderDate,
      'orderDateFormatted': instance.orderDateFormatted,
      'deliveryDate': instance.deliveryDate,
      'deliveryDateFormatted': instance.deliveryDateFormatted,
      'debtor': instance.debtor?.toJson(),
      'agent': instance.agent,
      'colliAmount': instance.colliAmount,
      'palletAmount': instance.palletAmount,
      'invoiceId': instance.invoiceId,
      'deliveryConditionId': instance.deliveryConditionId,
      'orderReference': instance.orderReference,
      'internalMemo': instance.internalMemo,
      'picker': instance.picker,
      'lines': instance.lines,
      'status': _$PicklistStatusEnumMap[instance.status]!,
      'hasCancelled': instance.hasCancelled,
      'id': instance.id,
      'isNew': instance.isNew,
      'defaultStatus': _$PicklistStatusEnumMap[instance.defaultStatus],
    };

const _$PicklistStatusEnumMap = {
  PicklistStatus.added: 1,
  PicklistStatus.inProgress: 2,
  PicklistStatus.inactive: 3,
  PicklistStatus.picked: 4,
  PicklistStatus.completed: 5,
  PicklistStatus.archived: 6,
  PicklistStatus.priority: 7,
  PicklistStatus.check: 8,
};
