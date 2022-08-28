// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    uid: json['uid'] as String,
    name: json['name'] as String?,
    description: json['description'] as String?,
    ean: json['ean'] as String,
    productGroupName: json['productGroupName'] as String?,
    unit: json['unit'] as String,
    status: json['status'] as int,
    stock: json['stock'] as num,
    hasImage: json['hasImage'] as bool,
    extra1: json['extra1'] as String?,
    extra2: json['extra2'] as String?,
    extra3: json['extra3'] as String?,
    extra4: json['extra4'] as String?,
    extra5: json['extra5'] as String?,
    packagings: (json['packagings'] as List<dynamic>)
        .map((e) => Packaging.fromJson(e as Map<String, dynamic>))
        .toList(),
    id: json['id'] as int,
    isNew: json['isNew'] as bool,
    batchField: json['batchField'] as int?,
    productionDateField: json['productionDateField'] as int?,
    expirationDateField: json['expirationDateField'] as int?,
    serialNumberField: json['serialNumberField'] as bool?,
  );
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'description': instance.description,
      'ean': instance.ean,
      'productGroupName': instance.productGroupName,
      'unit': instance.unit,
      'status': instance.status,
      'stock': instance.stock,
      'hasImage': instance.hasImage,
      'extra1': instance.extra1,
      'extra2': instance.extra2,
      'extra3': instance.extra3,
      'extra4': instance.extra4,
      'extra5': instance.extra5,
      'packagings': instance.packagings.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'isNew': instance.isNew,
      'batchField': instance.batchField,
      'productionDateField': instance.productionDateField,
      'expirationDateField': instance.expirationDateField,
      'serialNumberField': instance.serialNumberField,
    };
