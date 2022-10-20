import 'package:flutter/material.dart';
import 'package:scanner/models/picklist.dart';

class CompleteStockMutationProvider extends ChangeNotifier {
  PicklistStatus? _status;

  PicklistStatus? get status => _status;

  set status(PicklistStatus? value) {
    _status = value;
    notifyListeners();
  }
}
