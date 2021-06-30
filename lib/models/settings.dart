import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum PicklistSort {
  productNumber,
  warehouseLocation,
}

PicklistSort getStatusFromString(String sort) {
  for (PicklistSort element in PicklistSort.values) {
    if (element.toString() == sort) {
      return element;
    }
  }
  return PicklistSort.productNumber;
}

class Settings {
  final PicklistSort picklistSort;
  final bool finishedProductsAtBottom;
  final bool oneScanPickAll;
  final bool directlyProcess;

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
    this.picklistSort = PicklistSort.productNumber,
    this.finishedProductsAtBottom = false,
    this.oneScanPickAll = true,
    this.directlyProcess = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        picklistSort: getStatusFromString(json['picklistSort']),
        finishedProductsAtBottom: json['finishedProductsAtBottom'] ?? false,
        oneScanPickAll: json['oneScanPickAll'] ?? true,
        directlyProcess: json['directlyProcess'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'picklistSort': picklistSort.toString(),
        'finishedProductsAtBottom': finishedProductsAtBottom,
        'oneScanPickAll': oneScanPickAll,
        'directlyProcess': directlyProcess,
      };

  save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(toJson()));
  }
}
