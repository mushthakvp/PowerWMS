import 'package:flutter/material.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/repository/remote_db/picklist_api_provider.dart';

class CompletePicklistProvider extends ChangeNotifier {
  Future<BaseResponse?> completePicklist(int id) async {
    var _apiProvider = PicklistApiProvider();
    return await _apiProvider.completePicklist(id);
  }
}
