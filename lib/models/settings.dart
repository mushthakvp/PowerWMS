import 'dart:convert';

import 'package:scanner/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

PicklistSortType getStatusFromString(String sort) {
  for (PicklistSortType element in PicklistSortType.values) {
    if (element.toString() == sort) {
      return element;
    }
  }
  return PicklistSortType.productNumber;
}

class Settings {
  final PicklistSortType picklistSort;
  final bool finishedProductsAtBottom;
  final bool oneScanPickAll;
  final bool directlyProcess;
  final WholeSaleSettings? wholeSaleSettings;

  static Future<Settings> fromMemory() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('settings');
    if (json != null) {
      return Settings.fromJson(jsonDecode(json));
    } else {
      return Settings();
    }
  }

  Settings({
    this.picklistSort = PicklistSortType.productNumber,
    this.finishedProductsAtBottom = false,
    this.oneScanPickAll = true,
    this.directlyProcess = false,
    this.wholeSaleSettings,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        picklistSort: getStatusFromString(json['picklistSort']),
        finishedProductsAtBottom: json['finishedProductsAtBottom'] ?? false,
        oneScanPickAll: json['oneScanPickAll'] ?? true,
        directlyProcess: json['directlyProcess'] ?? false,
        wholeSaleSettings: json['whole_sale_settings'] != null
            ? WholeSaleSettings.fromJson(json['whole_sale_settings'])
            : null,
      );

  Settings copyWith(WholeSaleSettings? wholeSaleSettingsCopy) {
    return Settings(
      wholeSaleSettings: wholeSaleSettingsCopy ?? wholeSaleSettings,
      directlyProcess: directlyProcess,
      finishedProductsAtBottom: finishedProductsAtBottom,
      oneScanPickAll: oneScanPickAll,
      picklistSort: picklistSort,
    );
  }

  Map<String, dynamic> toJson() => {
        'picklistSort': picklistSort.toString(),
        'finishedProductsAtBottom': finishedProductsAtBottom,
        'oneScanPickAll': oneScanPickAll,
        'directlyProcess': directlyProcess,
        "whole_sale_settings": wholeSaleSettings?.toJson()
      };

  save() async {
    final prefs = await SharedPreferences.getInstance();
    print("pref Saving (())))(())))");
    print(toJson());
    prefs.setString('settings', jsonEncode(toJson()));
  }
}

class WholeSaleSettings {
  WholeSaleSettings({this.server, this.admin, this.userName, this.password});

  String? server;
  String? admin;
  String? userName;
  String? password;

  factory WholeSaleSettings.fromJson(Map<String, dynamic> json) =>
      WholeSaleSettings(
        admin: json['admin'],
        password: json['password'],
        server: json['server'],
        userName: json['username'],
      );

  Map<String, dynamic> toJson() => {
        'admin': admin,
        'password': password,
        'server': server,
        'username': userName,
      };
}
