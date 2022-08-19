import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:sembast/sembast.dart';

const int settings_key = 11008901;

class SettingsApiProvider {
  final store = intMapStoreFactory.store('settings_remote');
  SettingsApiProvider(this.db);

  final Database db;

  Future<SettingsRemote?> getSettingsRemote() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet
    ) {
      try {
        final response = await dio.get('/account/defaults');
        if (response.statusCode == 200) {
          var data = SettingsRemote.fromJson(response.data);
          if (await _getSettingsRemoteFromLocal() == null) {
            _saveSettings(data);
          } else {
            _updateSettings(data);
          }
          return SettingsRemote.fromJson(response.data);
        } else {
          return null;
        }
      } catch (error) {
        print(error);
      }
    } else {
      return await _getSettingsRemoteFromLocal();
    }
    return null;
  }

  Future<SettingsRemote?> _getSettingsRemoteFromLocal() async {
    var jsn = await store.record(settings_key).get(db);
    if (jsn == null) {
      return null;
    }
    return SettingsRemote.fromJson(jsn);
  }

  Future<void> _saveSettings(SettingsRemote settingsRemote) async {
    await store.record(settings_key).add(db, settingsRemote.toJson());
  }

  Future<void> _updateSettings(SettingsRemote settingsRemote) async {
    await store.record(settings_key).update(db, settingsRemote.toJson());
  }
}