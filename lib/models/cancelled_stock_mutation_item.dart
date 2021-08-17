import 'package:json_annotation/json_annotation.dart';

import 'stock_mutation_item.dart';

part 'cancelled_stock_mutation_item.g.dart';

@JsonSerializable()
class CancelledStockMutationItem {
  CancelledStockMutationItem({
    required this.id,
    required this.productId,
    required this.amount,
  });

  factory CancelledStockMutationItem.fromItem(StockMutationItem item) {
    assert(item.id != null);
    return CancelledStockMutationItem(
      id: item.id!,
      productId: item.productId,
      amount: item.amount,
    );
  }

  final int id;
  final int productId;
  final int amount;

  factory CancelledStockMutationItem.fromJson(Map<String, dynamic> json) =>
      _$CancelledStockMutationItemFromJson(json);
  Map<String, dynamic> toJson() => _$CancelledStockMutationItemToJson(this);
}
