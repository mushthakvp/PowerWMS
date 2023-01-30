import 'package:json_annotation/json_annotation.dart';
import 'package:scanner/models/settings.dart';

part 'settings_remote.g.dart';

@JsonSerializable(explicitToJson: true)
class SettingsRemote {
  SettingsRemote({
    this.warehouseId,
    this.fromWarehouseId,
    this.toWarehouseId,
    this.stockListWarehouseId,
    this.defaultPackagingUnitId,
    this.action,
    this.limitToDefaultAction,
    this.directScanning,
    this.continuousScanning,
    this.picklistSorting,
    this.finishedProductsAtBottom,
    this.oneScanPickAll,
    this.directProcessing,
    this.wholeSaleSettings,
  });

  int? warehouseId;
  int? fromWarehouseId;
  int? toWarehouseId;
  int? stockListWarehouseId;
  int? defaultPackagingUnitId;
  int? action;
  bool? limitToDefaultAction;
  bool? directScanning;
  bool? continuousScanning;
  int? picklistSorting;
  bool? finishedProductsAtBottom;
  bool? oneScanPickAll;
  bool? directProcessing;
  WholeSaleSettings? wholeSaleSettings;

  SettingsRemote copyWith({
    int? picklistSorting,
    bool? finishedProductsAtBottom,
    bool? oneScanPickAll,
    bool? directProcessing,
  }) =>
      SettingsRemote(
        warehouseId: this.warehouseId,
        fromWarehouseId: this.fromWarehouseId,
        toWarehouseId: this.toWarehouseId,
        stockListWarehouseId: this.stockListWarehouseId,
        defaultPackagingUnitId: this.defaultPackagingUnitId,
        action: this.action,
        limitToDefaultAction: this.limitToDefaultAction,
        directScanning: this.directScanning,
        continuousScanning: this.continuousScanning,
        picklistSorting: picklistSorting ?? this.picklistSorting,
        finishedProductsAtBottom: finishedProductsAtBottom ?? this.finishedProductsAtBottom,
        oneScanPickAll: oneScanPickAll ?? this.oneScanPickAll,
        directProcessing: directProcessing ?? this.directProcessing,
      );

  factory SettingsRemote.fromJson(Map<String, dynamic> json) =>
      _$SettingsRemoteFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsRemoteToJson(this);
}
