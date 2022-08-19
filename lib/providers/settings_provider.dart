import 'package:flutter/material.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/resources/settings_api_provider.dart';
import 'package:sembast/sembast.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider(this.db);

  SettingsRemote? settingsRemote;
  final Database db;

  PicklistSort picklistSort = PicklistSort.productNumber;

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

  Settings get settingsLocal {
    return Settings(
      picklistSort: this.picklistSort,
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
      picklistSorting: 3,
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
}