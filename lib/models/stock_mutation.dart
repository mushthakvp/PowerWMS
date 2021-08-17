import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/stock_mutation_item.dart';

part 'stock_mutation.g.dart';

@JsonSerializable(explicitToJson: true)
class StockMutation {
  StockMutation(
    this.warehouseId,
    this.picklistId,
    this.lineId,
    this.isBook,
    this.items,
  );

  final int warehouseId;
  final int picklistId;
  final int lineId;
  final bool isBook;
  final List<StockMutationItem> items;

  int get totalAmount {
    return items.fold<int>(0, (sum, item) => sum + item.amount);
  }

  factory StockMutation.fromJson(Map<String, dynamic> json) =>
      _$StockMutationFromJson(json);
  Map<String, dynamic> toJson() => _$StockMutationToJson(this);
}
