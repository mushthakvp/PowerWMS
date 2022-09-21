import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/resources/stock_mutation_db_provider.dart';
import 'package:sembast/sembast.dart';

class StockMutationRepository {
  StockMutationRepository(Database db) {
    _dbProvider = StockMutationDbProvider(db);
  }

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
      await _dbProvider.deleteStockMutation(id);
    } catch (e) {
      print(e);
    }
  }
}
