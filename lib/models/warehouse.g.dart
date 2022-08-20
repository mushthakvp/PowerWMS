// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Warehouse _$WarehouseFromJson(Map<String, dynamic> json) {
  return Warehouse(
    name: json['name'] as String?,
    code: json['code'] as String?,
    globalLocationNumber: json['globalLocationNumber'] as int?,
    id: json['id'] as int?,
    isNew: json['isNew'] as bool?,
  );
}

Map<String, dynamic> _$WarehouseToJson(Warehouse instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'globalLocationNumber': instance.globalLocationNumber,
      'id': instance.id,
      'isNew': instance.isNew,
    };
