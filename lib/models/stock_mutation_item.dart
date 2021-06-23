import 'package:json_annotation/json_annotation.dart';

part 'stock_mutation_item.g.dart';

enum StockMutationItemStatus {
  New,
  Reserved,
  Exported,
  Cancelled,
}

amountFromJson(num value) => value.round();
statusFromJson(int value) {
  switch (value) {
    case 1:
      return StockMutationItemStatus.Reserved;
    case 2:
      return StockMutationItemStatus.Exported;
    case 3:
      return StockMutationItemStatus.Cancelled;
    default:
      return StockMutationItemStatus.New;
  }
}

statusToJson(StockMutationItemStatus status) {
  switch (status) {
    case StockMutationItemStatus.Reserved:
      return 1;
    case StockMutationItemStatus.Exported:
      return 2;
    case StockMutationItemStatus.Cancelled:
      return 3;
    default:
      return null;
  }
}

@JsonSerializable()
class StockMutationItem {
  final int? id;
  @JsonKey(fromJson: amountFromJson)
  final int amount;
  final String batch;
  final String productionDate;
  final String expirationDate;
  final int productId;
  final String stickerCode;
  @JsonKey(fromJson: statusFromJson, toJson: statusToJson)
  final StockMutationItemStatus status;

  StockMutationItem({
    this.id,
    required this.amount,
    required this.batch,
    required this.productionDate,
    required this.expirationDate,
    required this.productId,
    required this.stickerCode,
    this.status = StockMutationItemStatus.New,
  });

  isNew() => status == StockMutationItemStatus.New;
  isReserved() => status == StockMutationItemStatus.Reserved;

  factory StockMutationItem.fromJson(Map<String, dynamic> json) =>
      _$StockMutationItemFromJson(json);
  Map<String, dynamic> toJson() => _$StockMutationItemToJson(this);
}
