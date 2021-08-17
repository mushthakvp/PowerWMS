import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/resources/stock_mutation_api_provider.dart';
import 'package:scanner/resources/stock_mutation_db_provider.dart';
import 'package:sembast/sembast.dart';

class StockMutationRepository {
  StockMutationRepository(Database db) {
    _apiProvider = StockMutationApiProvider();
    _dbProvider = StockMutationDbProvider(db);
  }

  late StockMutationApiProvider _apiProvider;
  late StockMutationDbProvider _dbProvider;

  Stream<Map<int, StockMutation>> getStockMutationsStream(int picklistId) {
    return _dbProvider.getStockMutationsStream(picklistId);
  }

  Future<dynamic> saveMutation(StockMutation mutation) async {
    final id = await _dbProvider.addStockMutation(mutation);
    addStockMutation(id, mutation);
  }

  Future<dynamic> processQueue() async {
    final mutations = await _dbProvider.getStockMutations();
    mutations.forEach(addStockMutation);
  }

  Future<dynamic> addStockMutation(int id, StockMutation mutation) async {
    try {
      var resp = await _apiProvider.addStockMutation(mutation);
      await _dbProvider.deleteStockMutation(id);
    } catch (e) {
      print(e);
    }
  }
}
