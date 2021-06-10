// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_mutation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockMutationItem _$StockMutationItemFromJson(Map<String, dynamic> json) {
  return StockMutationItem(
    mutationAmount: json['mutationAmount'] as int,
    batch: json['batch'] as String,
    productionDate: json['productionDate'] as String,
    expirationDate: json['expirationDate'] as String,
    productId: json['productId'] as int,
    stickerCode: json['stickerCode'] as String,
  );
}

Map<String, dynamic> _$StockMutationItemToJson(StockMutationItem instance) =>
    <String, dynamic>{
      'mutationAmount': instance.mutationAmount,
      'batch': instance.batch,
      'productionDate': instance.productionDate,
      'expirationDate': instance.expirationDate,
      'productId': instance.productId,
      'stickerCode': instance.stickerCode,
    };
