import 'package:flutter/material.dart';
import 'package:scanner/resources/picklist_api_provider.dart';

class CompletePicklistProvider extends ChangeNotifier {
  Future<String?> completePicklist(int id) async {
    var _apiProvider = PicklistApiProvider();
    return await _apiProvider.completePicklist(id);
  }
}