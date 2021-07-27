import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/debtor.dart';

part 'picklist.g.dart';

Map<String, dynamic> _debtorToJson(Debtor debtor) => debtor.toJson();
Debtor _debtorFromJson(Map<String, dynamic> json) => new Debtor.fromJson(json);

@JsonSerializable()
class Picklist {
  String? timezone;
  String uid;
  String? orderDate;
  String? orderDateFormatted;
  String? deliveryDate;
  String? deliveryDateFormatted;
  @JsonKey(fromJson: _debtorFromJson, toJson: _debtorToJson)
  Debtor debtor;
  String? agent;
  double? colliAmount;
  double? palletAmount;
  String? invoiceId;
  String? deliveryConditionId;
  String? internalMemo;
  String? picker;
  int lines;
  int status;
  bool hasCancelled;
  int id;
  bool isNew;

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
    required this.internalMemo,
    required this.picker,
    required this.lines,
    required this.status,
    required this.hasCancelled,
    required this.id,
    required this.isNew,
  });

  factory Picklist.fromJson(Map<String, dynamic> json) =>
      _$PicklistFromJson(json);
  Map<String, dynamic> toJson() => _$PicklistToJson(this);
}
