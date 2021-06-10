import 'package:json_annotation/json_annotation.dart';

part 'stock_mutation_item.g.dart';

@JsonSerializable()
class StockMutationItem {
  final int mutationAmount;
  final String batch;
  final String productionDate;
  final String expirationDate;
  final int productId;
  final String stickerCode;

  StockMutationItem({
    required this.mutationAmount,
    required this.batch,
    required this.productionDate,
    required this.expirationDate,
    required this.productId,
    required this.stickerCode,
  });

  factory StockMutationItem.fromJson(Map<String, dynamic> json) => _$StockMutationItemFromJson(json);
  Map<String, dynamic> toJson() => _$StockMutationItemToJson(this);
}
