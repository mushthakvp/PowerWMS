// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packaging.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Packaging _$PackagingFromJson(Map<String, dynamic> json) {
  return Packaging(
    productId: json['productId'] as int,
    packagingUnitId: json['packagingUnitId'] as int,
    uid: json['uid'] as String?,
    defaultAmount: json['defaultAmount'] as num,
    weight: json['weight'] as num?,
    weightMeasurementUnitId: json['weightMeasurementUnitId'] as String?,
    length: json['length'] as num?,
    width: json['width'] as num?,
    height: json['height'] as num?,
    dimensionMeasurementUnitId: json['dimensionMeasurementUnitId'] as String?,
    product: json['product'] as String,
    productName: json['productName'] as String,
    productUnit: json['productUnit'] as String,
    productDecimals: json['productDecimals'] as num,
    productDescription: json['productDescription'] as String,
    batchField: json['batchField'] as int,
    productionDateField: json['productionDateField'] as int,
    expirationDateField: json['expirationDateField'] as int,
    packagingUnitTranslations: (json['packagingUnitTranlations']
            as List<dynamic>)
        .map(
            (e) => PackagingUnitTranslation.fromJson(e as Map<String, dynamic>))
        .toList(),
    translatedName: json['translatedName'] as String?,
    formattedDimension: json['formattedDimension'] as String,
    id: json['id'] as int,
    isNew: json['isNew'] as bool,
  );
}

Map<String, dynamic> _$PackagingToJson(Packaging instance) => <String, dynamic>{
      'productId': instance.productId,
      'packagingUnitId': instance.packagingUnitId,
      'uid': instance.uid,
      'defaultAmount': instance.defaultAmount,
      'weight': instance.weight,
      'weightMeasurementUnitId': instance.weightMeasurementUnitId,
      'length': instance.length,
      'width': instance.width,
      'height': instance.height,
      'dimensionMeasurementUnitId': instance.dimensionMeasurementUnitId,
      'product': instance.product,
      'productName': instance.productName,
      'productUnit': instance.productUnit,
      'productDecimals': instance.productDecimals,
      'productDescription': instance.productDescription,
      'batchField': instance.batchField,
      'productionDateField': instance.productionDateField,
      'expirationDateField': instance.expirationDateField,
      'packagingUnitTranlations': instance.packagingUnitTranslations,
      'translatedName': instance.translatedName,
      'formattedDimension': instance.formattedDimension,
      'id': instance.id,
      'isNew': instance.isNew,
    };
