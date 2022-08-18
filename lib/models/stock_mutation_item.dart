import 'package:json_annotation/json_annotation.dart';

part 'stock_mutation_item.g.dart';

enum StockMutationItemStatus {
  @JsonValue(null)
  New,
  @JsonValue(1)
  Reserved,
  @JsonValue(2)
  Exported,
  @JsonValue(3)
  Cancelled,
}

extension StockMutationItemStatusExtension on StockMutationItemStatus {
  int get name => toJson();

  toJson() {
    switch (this) {
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
}

amountFromJson(num value) => value.round();

dateFromJson(String? value) {
  if (value != null) {
    return DateTime.tryParse(value) ?? null;
  }
  return null;
}

@JsonSerializable()
class StockMutationItem {
  StockMutationItem({
    this.id,
    required this.amount,
    required this.batch,
    required this.productionDate,
    required this.expirationDate,
    required this.productId,
    required this.stickerCode,
    required this.picklistLineId,
    this.status = StockMutationItemStatus.New,
    this.createdDate,
  });

  final int? id;
  @JsonKey(fromJson: amountFromJson)
  final int amount;
  final String batch;
  final String? productionDate;
  final String? expirationDate;
  @JsonKey(fromJson: dateFromJson)
  final DateTime? createdDate;
  final int productId;
  final String? stickerCode;
  final int? picklistLineId;
  final StockMutationItemStatus? status;

  isNew() => status == StockMutationItemStatus.New;
  isReserved() => status == StockMutationItemStatus.Reserved;

  inCancelledQueue() => false;

  factory StockMutationItem.fromJson(Map<String, dynamic> json) =>
      _$StockMutationItemFromJson(json);
  Map<String, dynamic> toJson() => _$StockMutationItemToJson(this);
}
