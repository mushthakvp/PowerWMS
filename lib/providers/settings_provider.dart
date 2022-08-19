import 'package:flutter/material.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/resources/settings_api_provider.dart';
import 'package:sembast/sembast.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider(this.db);

  SettingsRemote? settingsRemote;
  final store = intMapStoreFactory.store('settings_remote');
  final Database db;

  Future<void> getSettingInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    settingsRemote = await _apiProvider.getSettingsRemote();
    if (settingsRemote != null) {
      await _saveSettings();
    }
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    if (settingsRemote != null) {
      await store.record(settings_key).add(db, settingsRemote!.toJson());
    }
  }
}