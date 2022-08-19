import 'package:json_annotation/json_annotation.dart';

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

  factory SettingsRemote.fromJson(Map<String, dynamic> json) =>
      _$SettingsRemoteFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsRemoteToJson(this);
}
