// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMutation _$StockMutationFromJson(Map<String, dynamic> json) =>
    StockMutation(
      json['warehouseId'] as int,
      json['picklistId'] as int,
      json['lineId'] as int,
      json['isBook'] as bool,
      (json['items'] as List<dynamic>)
          .map((e) => StockMutationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StockMutationToJson(StockMutation instance) =>
    <String, dynamic>{
      'warehouseId': instance.warehouseId,
      'picklistId': instance.picklistId,
      'lineId': instance.lineId,
      'isBook': instance.isBook,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };
