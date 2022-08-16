import 'package:flutter/material.dart';
import 'package:scanner/providers/mutation_provider.dart';

class ProcessProductProvider extends ChangeNotifier {
  bool _canProcess = false;

  bool get canProcess => _canProcess;

  set canProcess(bool value) {
    _canProcess = value;
    notifyListeners();
  }

  MutationProvider? mutationProvider;
}
