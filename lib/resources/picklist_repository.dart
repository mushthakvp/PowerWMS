import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/resources/picklist_api_provider.dart';
import 'package:scanner/resources/picklist_db_provider.dart';
import 'package:sembast/sembast.dart';

Future<bool> connectivityAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi ||
      connectivityResult == ConnectivityResult.ethernet);
}

class PicklistRepository {
  PicklistRepository(Database db) {
    _apiProvider = PicklistApiProvider();
    _dbProvider = PicklistDbProvider(db);
  }

  late PicklistApiProvider _apiProvider;
  late PicklistDbProvider _dbProvider;

  Stream<List<Picklist>> getPicklistsStream(String search) async* {
    if (await connectivityAvailable()) {
      await clear();
    }
    final stream = _dbProvider.getPicklistsStream(search);
    if (await _dbProvider.count() == 0) {
      final list = await _apiProvider.getPicklists(search);
      _dbProvider.savePicklists(list);
    }

    yield* stream;
  }

  Future<dynamic> clear() {
    return _dbProvider.clear();
  }
}
