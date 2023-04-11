// import 'package:flutter/foundation.dart';
// import 'package:scanner/dio.dart';
//
// enum SettingForm { server, admin, userName, pwd }
//
// class SettingBloc extends ChangeNotifier {
//   SettingBloc({required this.settingDbProvider}) : super(SettingInitialState());
//
//   late SettingDbProvider settingDbProvider;
//   bool showUpdate = false;
//
//   Future<Setting?> fetchSetting() async {
//     var setting = await settingDbProvider.getSetting();
//     if (setting != null) {
//       showUpdate = true;
//       updateErpDio(
//           server: setting.server!,
//           admin: setting.admin!,
//           userName: setting.userName!,
//           password: setting.password!
//       );
//     }
//     emit(FetchedSettingState(setting: setting));
//     if (kDebugMode) {
//       print('====== Fetch setting: ${setting?.toJson()}');
//     }
//     return setting;
//   }
//
//   onChangedForm(SettingForm form, String val) {
//     switch (form) {
//       case SettingForm.server:
//         return emit(state.copyWith(server: val));
//       case SettingForm.admin:
//         return emit(state.copyWith(admin: val));
//       case SettingForm.userName:
//         return emit(state.copyWith(userName: val));
//       case SettingForm.pwd:
//         return emit(state.copyWith(password: val));
//     }
//   }
//
//   Future<void> doSaveAndUpdate() async {
//     var setting = Setting(
//         server: state.server,
//         admin: state.admin,
//         userName: state.userName,
//         password: state.password);
//     if (showUpdate) {
//       await settingDbProvider.updateSettings(setting);
//     } else {
//       await settingDbProvider.saveSettings(setting);
//     }
//     updateErpDio(
//         server: setting.server!,
//         admin: setting.admin!,
//         userName: setting.userName!,
//         password: setting.password!
//     );
//   }
//
//   dispose() {
//     emit(SettingInitialState());
//   }
// }
//
// class SettingState {
//   SettingState(
//       {required this.server,
//       required this.admin,
//       required this.userName,
//       required this.password});
//
//   final String? server;
//   final String? admin;
//   final String? userName;
//   final String? password;
//
//   SettingState copyWith(
//       {String? server, String? admin, String? userName, String? password}) {
//     return SettingState(
//         server: server ?? this.server,
//         admin: admin ?? this.admin,
//         userName: userName ?? this.userName,
//         password: password ?? this.password);
//   }
// }
//
// class SettingInitialState extends SettingState {
//   SettingInitialState()
//       : super(server: null, admin: null, userName: null, password: null);
// }
//
// class FetchedSettingState extends SettingState {
//   FetchedSettingState({required Setting? setting})
//       : super(
//             server: setting?.server,
//             admin: setting?.admin,
//             userName: setting?.userName,
//             password: setting?.password);
// }
