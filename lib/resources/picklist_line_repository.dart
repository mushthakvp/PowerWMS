import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/picklist_line_api_provider.dart';
import 'package:scanner/resources/picklist_line_db_provider.dart';
import 'package:sembast/sembast.dart';

class PicklistLineRepository {
  PicklistLineRepository(Database db) {
    _apiProvider = PicklistLineApiProvider();
    _dbProvider = PicklistLineDbProvider(db);
  }

  late PicklistLineApiProvider _apiProvider;
  late PicklistLineDbProvider _dbProvider;

  Future<List<PicklistLine>> getPicklistLines(int picklistId) async {
    List<PicklistLine> list;
    if (await _dbProvider.count(picklistId) == 0) {
      list = await _apiProvider.getPicklistLines(picklistId);
      _dbProvider.savePicklistLines(list);
    } else {
      list = await _dbProvider.getPicklistLines(picklistId);
    }

    return list;
  }

  Future<PicklistLine?> refreshPicklistLine(int picklistId, int lineId) async {
    final line = await _apiProvider.getPicklistLine(picklistId, lineId);
    await _dbProvider.savePicklistLine(line);

    return line;
  }

  clearCache(int picklistId) async {
    _dbProvider.clear(picklistId);
  }
}
