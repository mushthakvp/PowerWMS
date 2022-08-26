import 'package:flutter/material.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/models/user_info.dart';
import 'package:scanner/models/warehouse.dart';
import 'package:scanner/resources/settings_api_provider.dart';
import 'package:sembast/sembast.dart';

enum PicklistSortType {
  warehouseLocation, productNumber, description
}

extension PicklistSortTypeExt on PicklistSortType {
  String get name {
    switch (this) {
      case PicklistSortType.warehouseLocation:
        return 'Sort on Warehouse Location';
      case PicklistSortType.productNumber:
        return 'Sort on Product Number';
      case PicklistSortType.description:
        return 'Sort on Description';
    }
  }
}

class SettingProvider extends ChangeNotifier {
  SettingProvider(this.db);

  UserInfo? userInfo;
  List<Warehouse>? warehouses;
  SettingsRemote? settingsRemote;
  final Database db;

  bool get finishedProductsAtBottom {
    return settingsRemote!.finishedProductsAtBottom!;
  }

  setFinishedProductsAtBottom(bool value) {
    settingsRemote?.finishedProductsAtBottom = value;
    notifyListeners();
  }

  bool get oneScanPickAll {
    return settingsRemote!.oneScanPickAll!;
  }

  setOneScanPickAll(bool value) {
    settingsRemote?.oneScanPickAll = value;
    notifyListeners();
  }

  bool get directProcessing {
    return settingsRemote!.directProcessing!;
  }

  setDirectProcessing(bool value) {
    settingsRemote?.directProcessing = value;
    notifyListeners();
  }

  setCurrentWarehouse(Warehouse value) {
    settingsRemote?.warehouseId = value.id;
    notifyListeners();
  }

  Settings get settingsLocal {
    return Settings(
      picklistSort: this.picklistSortType(),
      finishedProductsAtBottom: this.finishedProductsAtBottom,
      oneScanPickAll: this.oneScanPickAll,
      directlyProcess: this.directProcessing,
    );
  }

  Future<void> getSettingInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    settingsRemote = await _apiProvider.getSettingsRemote();
    saveSettingLocal();
  }

  Future<void> saveSettingInfo() async {
    // Save to local
    saveSettingLocal();
    // Save to remote
    final data = settingsRemote!.copyWith(
      picklistSorting: this.picklistSortType().index + 1,
      finishedProductsAtBottom: this.finishedProductsAtBottom,
      oneScanPickAll: this.oneScanPickAll,
      directProcessing: this.directProcessing
    );
    var _apiProvider = SettingsApiProvider(db);
    _apiProvider.saveSettingsRemote(data);
    notifyListeners();
  }

  saveSettingLocal() {
    settingsLocal.save();
    notifyListeners();
  }

  /// Warehouse API
  Future<void> getWarehouses() async {
    var _apiProvider = SettingsApiProvider(db);
    warehouses = await _apiProvider.getWarehouses();
    notifyListeners();
  }

  Warehouse? get currentWareHouse {
    return this.warehouses
        ?.firstWhere((w) => w.id == this.settingsRemote?.warehouseId);
  }

  // User Info API
  Future<void> getUserInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    userInfo = await _apiProvider.getUserInfo();
    notifyListeners();
  }

  String get getUserInfoName {
    return '${userInfo?.firstName ?? 'Loading'} ${userInfo?.lastName ?? ''}';
  }

  setCurrentPicklistSorting(PicklistSortType value) {
    settingsRemote?.picklistSorting = (value.index + 1);
    notifyListeners();
  }

  PicklistSortType picklistSortType() {
    switch (settingsRemote?.picklistSorting ?? 1) {
      case 1:
        return PicklistSortType.warehouseLocation;
      case 2:
        return PicklistSortType.productNumber;
      case 3:
        return PicklistSortType.description;
      default:
        return PicklistSortType.productNumber;
    }
  }
}