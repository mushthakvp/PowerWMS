// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMutationItem _$StockMutationItemFromJson(Map<String, dynamic> json) =>
    StockMutationItem(
      id: json['id'] as int?,
      amount: amountFromJson(json['amount'] as num),
      batch: json['batch'] as String,
      productionDate: json['productionDate'] as String?,
      expirationDate: json['expirationDate'] as String?,
      productId: json['productId'] as int,
      picklistId: json['picklistId'] as int,
      stickerCode: json['stickerCode'] as String?,
      picklistLineId: json['picklistLineId'] as int?,
      warehouse: json['warehouse'] as String?,
      warehouseCode: json['warehouseCode'] as String?,
      status: $enumDecodeNullable(
              _$StockMutationItemStatusEnumMap, json['status']) ??
          StockMutationItemStatus.New,
      createdDate: dateFromJson(json['createdDate'] as String?),
    );

Map<String, dynamic> _$StockMutationItemToJson(StockMutationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'batch': instance.batch,
      'productionDate': instance.productionDate,
      'expirationDate': instance.expirationDate,
      'createdDate': instance.createdDate?.toIso8601String(),
      'productId': instance.productId,
      'picklistId': instance.picklistId,
      'stickerCode': instance.stickerCode,
      'warehouse': instance.warehouse,
      'warehouseCode': instance.warehouseCode,
      'picklistLineId': instance.picklistLineId,
      'status': _$StockMutationItemStatusEnumMap[instance.status],
    };

const _$StockMutationItemStatusEnumMap = {
  StockMutationItemStatus.New: null,
  StockMutationItemStatus.Reserved: 1,
  StockMutationItemStatus.Exported: 2,
  StockMutationItemStatus.Cancelled: 3,
};
