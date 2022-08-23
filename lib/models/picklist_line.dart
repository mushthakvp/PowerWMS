import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/product.dart';

part 'picklist_line.g.dart';

enum PicklistLineStatus {
  @JsonValue(1)
  added,
  @JsonValue(2)
  inProgress,
  @JsonValue(3)
  picked,
}

extension PicklistLineStatusExtension on PicklistLineStatus {
  int get name => toJson();

  toJson() {
    switch (this) {
      case PicklistLineStatus.added:
        return 1;
      case PicklistLineStatus.inProgress:
        return 2;
      case PicklistLineStatus.picked:
        return 3;
    }
  }
}

@JsonSerializable(explicitToJson: true)
class PicklistLine {
  final String picklist;
  final int picklistId;
  final int line;
  final String? uid;
  final String warehouse;
  final int warehouseId;
  final String? lineDate;
  final num pickAmount;
  final num? canceledAmount;
  final num pickedAmount;
  final num available;
  final String? descriptionA;
  final String? descriptionB;
  final String? internalMemo;
  final PicklistLineStatus status;
  final Product product;
  final String? location;
  final String? lineLocationCode;
  final String? lineWarehouseCode;
  final int id;
  final bool isNew;

  PicklistLine({
    required this.picklist,
    required this.picklistId,
    required this.line,
    this.uid,
    required this.warehouse,
    required this.warehouseId,
    this.lineDate,
    required this.pickAmount,
    this.canceledAmount,
    required this.pickedAmount,
    required this.available,
    this.descriptionA,
    this.descriptionB,
    this.internalMemo,
    required this.status,
    required this.product,
    this.location,
    this.lineLocationCode,
    this.lineWarehouseCode,
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
