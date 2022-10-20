import 'dart:async';
import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/resources/picklist_api_provider.dart';
import 'package:scanner/resources/picklist_db_provider.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:sembast/sembast.dart';

class PicklistRepository {
  PicklistRepository(Database db) {
    _apiProvider = PicklistApiProvider();
    _dbProvider = PicklistDbProvider(db);
  }

  late PicklistApiProvider _apiProvider;
  late PicklistDbProvider _dbProvider;

  Stream<List<Picklist>> getPicklistsStream(String search) async* {
    final stream = _dbProvider.getPicklistsStream(search);
    if (await _dbProvider.count() == 0) {
      if (!InternetState.shared.connectivityAvailable()) {
        throw NoConnection('Intentional exception');
      }
      final list = await _apiProvider.getPicklists(search);
      _dbProvider.savePicklists(list);
    }

    yield* stream;
  }

  Future<void> updatePicklistStatus(int id, PicklistStatus status) async {
    await _dbProvider.updatePicklistStatus(id, status);
  }

  Future<dynamic> clear() {
    return _dbProvider.clear();
  }
}
