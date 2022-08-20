import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/settings_remote.dart';
import 'package:scanner/models/user_info.dart';
import 'package:scanner/models/warehouse.dart';
import 'package:sembast/sembast.dart';

const int settings_key = 11008901;
const int user_info = 11008902;

class SettingsApiProvider {
  final store = intMapStoreFactory.store('settings_remote');
  SettingsApiProvider(this.db);

  final Database db;

  Future<bool> connectivityAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.ethernet);
  }

  /// User info API
  ///
  Future<UserInfo?> getUserInfo() async {
    if (await connectivityAvailable()) {
      final response = await dio.post('/account/info');
      var result = UserInfo.fromJson(response.data);
      if (await _getUserInfoFromLocal() == null) {
        _saveUserInfoToLocal(result);
      } else {
        _updateUserInfoToLocal(result);
      }
      return result;
    } else {
      print('NO INTERNET');
      return await _getUserInfoFromLocal();
    }
  }

  Future<UserInfo?> _getUserInfoFromLocal() async {
    var jsn = await store.record(user_info).get(db);
    if (jsn == null) {
      return null;
    }
    return UserInfo.fromJson(jsn);
  }

  Future<void> _saveUserInfoToLocal(UserInfo userInfo) async {
    await store.record(user_info).add(db, userInfo.toJson());
  }

  Future<void> _updateUserInfoToLocal(UserInfo userInfo) async {
    await store.record(user_info).update(db, userInfo.toJson());
  }

  /// Warehouse API
  ///
  Future<List<Warehouse>?> getWarehouses() async {
    if (await connectivityAvailable()) {
      try {
        final response = await dio.get('/account/warehouses');
        if (response.statusCode == 200) {
          var result = (response.data as List<dynamic>)
              .map((x) => Warehouse.fromJson(x))
              .toList();
          if (await _getWarehouseFromLocal() == []) {
            await _saveWarehouseToLocal(result);
          } else {
            await _updateWarehouseToLocal(result);
          }
          return result;
        } else {
          return null;
        }
      } catch (error) {
        print(error);
      }
    } else {
      return await _getWarehouseFromLocal();
    }
    return null;
  }

  Future<void> _saveWarehouseToLocal(List<Warehouse> data) async {
    await store
        .records(data.map((w) => w.id!))
        .add(db, data.map((w) => w.toJson()).toList());
  }

  Future<void> _updateWarehouseToLocal(List<Warehouse> data) async {
    await store
        .records(data.map((w) => w.id!))
        .update(db, data.map((w) => w.toJson()).toList());
  }

  Future<List<Warehouse>> _getWarehouseFromLocal() async {
    var finder = Finder(filter: null);
    return store.find(db, finder: finder).then((records) =>
        records.map((snapshot) => Warehouse.fromJson(snapshot.value)).toList());
  }

  /// Settings APIs
  ///
  Future<void> saveSettingsRemote(SettingsRemote settingsRemote) async {
    final data = settingsRemote.toJson();
    if (await connectivityAvailable()) {
      final response = await dio.post('/account/defaults', data: data);
      print(response.data);
    } else {
      _updateSettingsRemote(settingsRemote);
      print('NO INTERNET');
    }
  }

  Future<SettingsRemote?> getSettingsRemote() async {
    if (await connectivityAvailable()) {
      try {
        final response = await dio.get('/account/defaults');
        if (response.statusCode == 200) {
          var data = SettingsRemote.fromJson(response.data);
          if (await _getSettingsRemoteFromLocal() == null) {
            _saveSettingsRemote(data);
          } else {
            _updateSettingsRemote(data);
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

  Future<void> _saveSettingsRemote(SettingsRemote settingsRemote) async {
    await store.record(settings_key).add(db, settingsRemote.toJson());
  }

  Future<void> _updateSettingsRemote(SettingsRemote settingsRemote) async {
    await store.record(settings_key).update(db, settingsRemote.toJson());
  }
}