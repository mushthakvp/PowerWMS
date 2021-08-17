// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMutationItem _$StockMutationItemFromJson(Map<String, dynamic> json) {
  return StockMutationItem(
    id: json['id'] as int?,
    amount: amountFromJson(json['amount'] as num),
    batch: json['batch'] as String,
    productionDate: json['productionDate'] as String?,
    expirationDate: json['expirationDate'] as String?,
    productId: json['productId'] as int,
    stickerCode: json['stickerCode'] as String?,
    picklistLineId: json['picklistLineId'] as int,
    status:
        _$enumDecodeNullable(_$StockMutationItemStatusEnumMap, json['status']),
    createdDate: dateFromJson(json['createdDate'] as String?),
  );
}

Map<String, dynamic> _$StockMutationItemToJson(StockMutationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'batch': instance.batch,
      'productionDate': instance.productionDate,
      'expirationDate': instance.expirationDate,
      'createdDate': instance.createdDate?.toIso8601String(),
      'productId': instance.productId,
      'stickerCode': instance.stickerCode,
      'picklistLineId': instance.picklistLineId,
      'status': _$StockMutationItemStatusEnumMap[instance.status],
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$StockMutationItemStatusEnumMap = {
  StockMutationItemStatus.New: null,
  StockMutationItemStatus.Reserved: 1,
  StockMutationItemStatus.Exported: 2,
  StockMutationItemStatus.Cancelled: 3,
};
