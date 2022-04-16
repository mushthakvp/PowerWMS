import 'package:json_annotation/json_annotation.dart';

part 'debtor.g.dart';

@JsonSerializable(explicitToJson: true)
class Debtor {
  String uid;
  String name;
  String? email;
  String? street;
  String? number;
  String? streetNote;
  String? city;
  String? postalCode;
  String? country;
  String? vatNumber;
  num? chamberOfCommerceNumber;
  int status;
  int? agentId;
  String? organisation;
  int? organisationId;
  int? addressId;
  String? paymentConditionId;
  String? statusFormatted;
  String? address;
  String? googleQuery;
  int id;
  bool isNew;

  Debtor({
    required this.uid,
    required this.name,
    required this.email,
    required this.street,
    required this.number,
    required this.streetNote,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.vatNumber,
    required this.chamberOfCommerceNumber,
    required this.status,
    required this.agentId,
    required this.organisation,
    required this.organisationId,
    required this.addressId,
    required this.paymentConditionId,
    required this.statusFormatted,
    required this.address,
    required this.googleQuery,
    required this.id,
    required this.isNew,
  });

  factory Debtor.fromJson(Map<String, dynamic> json) => _$DebtorFromJson(json);
  Map<String, dynamic> toJson() => _$DebtorToJson(this);
}
