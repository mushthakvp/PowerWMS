import 'package:flutter/material.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/setting_api.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/models/user_info.dart';
import 'package:scanner/models/warehouse.dart';
import 'package:scanner/resources/settings_api_provider.dart';
import 'package:sembast/sembast.dart';

enum PicklistSortType { warehouseLocation, productNumber, description }

extension PicklistSortTypeExt on PicklistSortType {
  String title(BuildContext context) {
    switch (this) {
      case PicklistSortType.warehouseLocation:
        return AppLocalizations.of(context)!.warehouseLocation;
      case PicklistSortType.productNumber:
        return AppLocalizations.of(context)!.productNumber;
      case PicklistSortType.description:
        return AppLocalizations.of(context)!.description;
    }
  }
}

class SettingProvider extends ChangeNotifier {
  SettingProvider(this.db);

  UserInfo? userInfo;
  SettingApi? apiSettings;
  List<Warehouse>? warehouses;
  SettingsRemote? settingsRemote;
  WholeSaleSettings? wholeSaleSettings;
  final Database db;

  bool get finishedProductsAtBottom {
    return settingsRemote?.finishedProductsAtBottom ?? false;
  }

  setFinishedProductsAtBottom(bool value) {
    settingsRemote?.finishedProductsAtBottom = value;
    notifyListeners();
  }

  bool get oneScanPickAll {
    return settingsRemote?.oneScanPickAll ?? false;
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
        finishedProductsAtBottom: finishedProductsAtBottom,
        oneScanPickAll: this.oneScanPickAll,
        directlyProcess: this.directProcessing,
        wholeSaleSettings: wholeSaleSettings);
  }

  Future<void> getSettingInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    settingsRemote = await _apiProvider.getSettingsRemote();
    print(")))))${settingsRemote?.wholeSaleSettings}");
    saveSettingLocal();
    // await getWholeSetting();
  }

  Future<bool?> postSerialNumbers(
      {required List<String> serialNumberList,
      String? receiptCode,
      int? lineNumber}) async {
    var _apiProvider = SettingsApiProvider(db);
    return await _apiProvider.postSerialNumbers(
      serialNumberList: serialNumberList,
      lineNumber: lineNumber,
      receiptCode: receiptCode,
    );
  }

  // getWholeSetting() async {
  //   var settings = await Settings.fromMemory();
  //
  //   wholeSaleSettings = settings.wholeSaleSettings;
  //   print(settings.wholeSaleSettings);
  //   if (settings.wholeSaleSettings != null) {
  //     print("UPDATING WEP DIO");
  //     updateErpDio(
  //       server: wholeSaleSettings!.server ?? "",
  //       admin: wholeSaleSettings!.admin ?? "",
  //       userName: wholeSaleSettings!.userName ?? "",
  //       password: wholeSaleSettings!.password ?? "",
  //     );
  //   }else{
  //     print("NOT UPDATING WEP DIO");
  //   }
  // }

  Future<void> saveSettingInfo() async {
    // Save to local
    saveSettingLocal();
    // Save to remote
    final data = settingsRemote!.copyWith(
        picklistSorting: this.picklistSortType().index + 1,
        finishedProductsAtBottom: this.finishedProductsAtBottom,
        oneScanPickAll: this.oneScanPickAll,
        directProcessing: this.directProcessing);
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
    return this
        .warehouses
        ?.firstWhere((w) => w.id == this.settingsRemote?.warehouseId);
  }

  // User Info API
  Future<void> getUserInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    userInfo = await _apiProvider.getUserInfo();
    notifyListeners();
  }

  // User Info API
  Future<void> getApiInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    apiSettings = await _apiProvider.getSettingApi();
    ApiSettings? settingsApi = apiSettings?.apiSettings?.first;
    if (settingsApi?.type == 1) {
      wholeSaleSettings = WholeSaleSettings(
          server: settingsApi?.baseEndpoint,
          admin: settingsApi?.administrationCode,
          userName: settingsApi?.basicAuthorizationUser,
          password: settingsApi?.basicAuthorizationPassword);
      updateErpDio(
        server: wholeSaleSettings!.server ?? "",
        admin: wholeSaleSettings!.admin ?? "",
        userName: wholeSaleSettings!.userName ?? "",
        password: wholeSaleSettings!.password ?? "",
      );
      print("wholeSaleSettings.toJson()");
      print(wholeSaleSettings?.toJson());
      // await saveSettingInfo();
    }

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
