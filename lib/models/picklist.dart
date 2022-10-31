import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/debtor.dart';

part 'picklist.g.dart';

enum PicklistStatus {
  @JsonValue(1)
  added,
  @JsonValue(2)
  inProgress,
  @JsonValue(3)
  inactive,
  @JsonValue(4)
  picked,
  @JsonValue(5)
  completed,
  @JsonValue(6)
  archived,
  @JsonValue(7)
  priority,
  @JsonValue(8)
  check
}

extension PicklistStatusExtension on PicklistStatus {
  int get name => toJson();

  toJson() {
    switch (this) {
      case PicklistStatus.added:
        return 1;
      case PicklistStatus.inProgress:
        return 2;
      case PicklistStatus.inactive:
        return 3;
      case PicklistStatus.picked:
        return 4;
      case PicklistStatus.completed:
        return 5;
      case PicklistStatus.archived:
        return 6;
      case PicklistStatus.priority:
        return 7;
      case PicklistStatus.check:
        return 8;
    }
  }
}

@JsonSerializable(explicitToJson: true)
class Picklist {
  final String? timezone;
  final String uid;
  final String? orderDate;
  final String? orderDateFormatted;
  final String? deliveryDate;
  final String? deliveryDateFormatted;
  final Debtor debtor;
  final String? agent;
  final double? colliAmount;
  final double? palletAmount;
  final String? invoiceId;
  final String? deliveryConditionId;
  final String? orderReference;
  final String? internalMemo;
  final String? picker;
  final int lines;
  final PicklistStatus status;
  final bool hasCancelled;
  final int id;
  final bool isNew;
  final PicklistStatus? defaultStatus;

  Picklist({
    required this.timezone,
    required this.uid,
    required this.orderDate,
    required this.orderDateFormatted,
    required this.deliveryDate,
    required this.deliveryDateFormatted,
    required this.debtor,
    required this.agent,
    required this.colliAmount,
    required this.palletAmount,
    required this.invoiceId,
    required this.deliveryConditionId,
    required this.orderReference,
    required this.internalMemo,
    required this.picker,
    required this.lines,
    required this.status,
    required this.hasCancelled,
    required this.id,
    required this.isNew,
    required this.defaultStatus
  });

  isNotPicked() {
    return status == PicklistStatus.added ||
        status == PicklistStatus.inProgress ||
        status == PicklistStatus.check ||
        status == PicklistStatus.priority;
  }

  isPicked() {
    return status == PicklistStatus.picked;
  }

  factory Picklist.fromJson(Map<String, dynamic> json) =>
      _$PicklistFromJson(json);
  Map<String, dynamic> toJson() => _$PicklistToJson(this);
}
