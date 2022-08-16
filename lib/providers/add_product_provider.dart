import 'package:flutter/material.dart';

class AddProductProvider extends ChangeNotifier {
  bool _canAdd = false;

  bool get canAdd => _canAdd;

  set canAdd(bool value) {
    _canAdd = value;
    notifyListeners();
  }
}
