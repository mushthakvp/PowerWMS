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
    productionDate: json['productionDate'] as String,
    expirationDate: json['expirationDate'] as String,
    productId: json['productId'] as int,
    stickerCode: json['stickerCode'] as String,
    status: statusFromJson(json['status'] as int),
  );
}

Map<String, dynamic> _$StockMutationItemToJson(StockMutationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'batch': instance.batch,
      'productionDate': instance.productionDate,
      'expirationDate': instance.expirationDate,
      'productId': instance.productId,
      'stickerCode': instance.stickerCode,
      'status': statusToJson(instance.status),
    };
