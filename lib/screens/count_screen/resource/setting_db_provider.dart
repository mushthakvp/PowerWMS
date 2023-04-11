// import 'package:sembast/sembast.dart';
//
// const int settings_key = 11008901;
//
// class SettingDbProvider {
//   SettingDbProvider(this.db);
//
//   final _store = intMapStoreFactory.store('settings');
//   final Database db;
//
//   Future<Setting?> getSetting() async {
//     var json = await _store.record(settings_key).get(db);
//     if (json == null) {
//       return null;
//     }
//     return Setting.fromJson(json);
//   }
//
//   Future<void> saveSettings(Setting setting) async {
//     await _store.record(settings_key).add(db, setting.toJson());
//   }
//
//   Future<void> updateSettings(Setting setting) async {
//     await _store.record(settings_key).update(db, setting.toJson());
//   }
// }