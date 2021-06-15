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
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    picklistSort: getStatusFromString(json['picklistSort']),
    finishedProductsAtBottom: json['finishedProductsAtBottom'],
    oneScanPickAll: json['oneScanPickAll'],
  );

  Map<String, dynamic> toJson() => {
    'picklistSort': picklistSort.toString(),
    'finishedProductsAtBottom': finishedProductsAtBottom,
    'oneScanPickAll': oneScanPickAll,
  };

  save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('settings', jsonEncode(toJson()));
  }
}
