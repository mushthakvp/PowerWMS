// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packaging_unit_translation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagingUnitTranslation _$PackagingUnitTranslationFromJson(
        Map<String, dynamic> json) =>
    PackagingUnitTranslation(
      culture: json['culture'] as String,
      value: json['value'] as String,
      id: json['id'] as int,
      isNew: json['isNew'] as bool,
    );

Map<String, dynamic> _$PackagingUnitTranslationToJson(
        PackagingUnitTranslation instance) =>
    <String, dynamic>{
      'culture': instance.culture,
      'value': instance.value,
      'id': instance.id,
      'isNew': instance.isNew,
    };
