// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancelled_stock_mutation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CancelledStockMutationItem _$CancelledStockMutationItemFromJson(
    Map<String, dynamic> json) {
  return CancelledStockMutationItem(
    id: json['id'] as int,
    productId: json['productId'] as int,
    amount: json['amount'] as int,
  );
}

Map<String, dynamic> _$CancelledStockMutationItemToJson(
        CancelledStockMutationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'amount': instance.amount,
    };
