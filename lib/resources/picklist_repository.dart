import 'package:scanner/models/picklist.dart';
import 'package:scanner/resources/picklist_api_provider.dart';
import 'package:scanner/resources/picklist_db_provider.dart';
import 'package:sembast/sembast.dart';

class PicklistRepository {
  PicklistRepository(Database db) {
    _apiProvider = PicklistApiProvider();
    _dbProvider = PicklistDbProvider(db);
  }

  late PicklistApiProvider _apiProvider;
  late PicklistDbProvider _dbProvider;

  Future<List<Picklist>> getPicklists(String? search) async {
    List<Picklist> list;
    if (await _dbProvider.count() == 0) {
      list = await _apiProvider.getPicklists(search);
      _dbProvider.savePicklists(list);
    } else {
      list = await _dbProvider.getPicklists(search);
    }

    return list;
  }

  clearCache() async {
    _dbProvider.clear();
  }
}
