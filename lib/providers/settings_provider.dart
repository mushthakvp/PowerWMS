import 'package:flutter/material.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/resources/settings_api_provider.dart';
import 'package:sembast/sembast.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider(this.db);

  SettingsRemote? settingsRemote;
  final Database db;

  Future<void> getSettingInfo() async {
    var _apiProvider = SettingsApiProvider(db);
    settingsRemote = await _apiProvider.getSettingsRemote();
    notifyListeners();
  }
}