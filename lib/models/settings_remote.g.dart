// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_remote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsRemote _$SettingsRemoteFromJson(Map<String, dynamic> json) =>
    SettingsRemote(
      warehouseId: json['warehouseId'] as int?,
      fromWarehouseId: json['fromWarehouseId'] as int?,
      toWarehouseId: json['toWarehouseId'] as int?,
      stockListWarehouseId: json['stockListWarehouseId'] as int?,
      defaultPackagingUnitId: json['defaultPackagingUnitId'] as int?,
      action: json['action'] as int?,
      limitToDefaultAction: json['limitToDefaultAction'] as bool?,
      directScanning: json['directScanning'] as bool?,
      continuousScanning: json['continuousScanning'] as bool?,
      picklistSorting: json['picklistSorting'] as int?,
      finishedProductsAtBottom: json['finishedProductsAtBottom'] as bool?,
      oneScanPickAll: json['oneScanPickAll'] as bool?,
      directProcessing: json['directProcessing'] as bool?,
      wholeSaleSettings: json['wholeSaleSettings'] == null
          ? null
          : WholeSaleSettings.fromJson(
              json['wholeSaleSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SettingsRemoteToJson(SettingsRemote instance) =>
    <String, dynamic>{
      'warehouseId': instance.warehouseId,
      'fromWarehouseId': instance.fromWarehouseId,
      'toWarehouseId': instance.toWarehouseId,
      'stockListWarehouseId': instance.stockListWarehouseId,
      'defaultPackagingUnitId': instance.defaultPackagingUnitId,
      'action': instance.action,
      'limitToDefaultAction': instance.limitToDefaultAction,
      'directScanning': instance.directScanning,
      'continuousScanning': instance.continuousScanning,
      'picklistSorting': instance.picklistSorting,
      'finishedProductsAtBottom': instance.finishedProductsAtBottom,
      'oneScanPickAll': instance.oneScanPickAll,
      'directProcessing': instance.directProcessing,
      'wholeSaleSettings': instance.wholeSaleSettings?.toJson(),
    };
