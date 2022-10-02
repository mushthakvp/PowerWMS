import 'package:flutter/material.dart';

class AddProductProvider extends ChangeNotifier {
  bool _canAdd = false;

  bool get canAdd => _canAdd;

  set canAdd(bool value) {
    _canAdd = value;
    notifyListeners();
  }

  String? _value;

  String? get value => _value;

  set value(String? value) {
    _value = value;
    notifyListeners();
  }
}
