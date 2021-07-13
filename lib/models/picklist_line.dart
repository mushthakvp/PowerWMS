import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/product.dart';

part 'picklist_line.g.dart';

@JsonSerializable()
class PicklistLine {
  final String picklist;
  final int picklistId;
  final int line;
  final String uid;
  final String warehouse;
  final int warehouseId;
  final String? lineDate;
  final num pickAmount;
  final num? canceledAmount;
  num pickedAmount;
  final num available;
  final String descriptionA;
  final String descriptionB;
  final String internalMemo;
  final int status;
  final Product product;
  final String? location;
  final int id;
  final bool isNew;

  PicklistLine({
    required this.picklist,
    required this.picklistId,
    required this.line,
    required this.uid,
    required this.warehouse,
    required this.warehouseId,
    required this.lineDate,
    required this.pickAmount,
    required this.canceledAmount,
    required this.pickedAmount,
    required this.available,
    required this.descriptionA,
    required this.descriptionB,
    required this.internalMemo,
    required this.status,
    required this.product,
    required this.location,
    required this.id,
    required this.isNew,
  });

  isFullyPicked() {
    return pickAmount == pickedAmount;
  }

  factory PicklistLine.fromJson(Map<String, dynamic> json) =>
      _$PicklistLineFromJson(json);
  Map<String, dynamic> toJson() => _$PicklistLineToJson(this);
}
