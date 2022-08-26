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
