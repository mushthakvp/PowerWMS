// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debtor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Debtor _$DebtorFromJson(Map<String, dynamic> json) {
  return Debtor(
    uid: json['uid'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    street: json['street'] as String,
    number: json['number'] as String,
    streetNote: json['streetNote'] as String,
    city: json['city'] as String,
    postalCode: json['postalCode'] as String,
    country: json['country'] as String,
    vatNumber: json['vatNumber'] as String,
    chamberOfCommerceNumber: json['chamberOfCommerceNumber'] as num,
    status: json['status'] as int,
    agentId: json['agentId'] as int,
    organisation: json['organisation'] as String,
    organisationId: json['organisationId'] as int,
    addressId: json['addressId'] as int,
    paymentConditionId: json['paymentConditionId'] as String,
    statusFormatted: json['statusFormatted'] as String,
    address: json['address'] as String,
    googleQuery: json['googleQuery'] as String,
    id: json['id'] as int,
    isNew: json['isNew'] as bool,
  );
}

Map<String, dynamic> _$DebtorToJson(Debtor instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'street': instance.street,
      'number': instance.number,
      'streetNote': instance.streetNote,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'vatNumber': instance.vatNumber,
      'chamberOfCommerceNumber': instance.chamberOfCommerceNumber,
      'status': instance.status,
      'agentId': instance.agentId,
      'organisation': instance.organisation,
      'organisationId': instance.organisationId,
      'addressId': instance.addressId,
      'paymentConditionId': instance.paymentConditionId,
      'statusFormatted': instance.statusFormatted,
      'address': instance.address,
      'googleQuery': instance.googleQuery,
      'id': instance.id,
      'isNew': instance.isNew,
    };
