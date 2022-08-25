import 'package:scanner/models/product.dart';
import 'package:scanner/resources/product_api_provider.dart';
import 'package:scanner/resources/product_db_provider.dart';
import 'package:sembast/sembast.dart';

class ProductRepository {
  ProductRepository(Database db) {
    _apiProvider = ProductApiProvider();
    _dbProvider = ProductDbProvider(db);
  }

  late ProductApiProvider _apiProvider;
  late ProductDbProvider _dbProvider;

  Future<List<Product>> getProducts(String? search) async {
    List<Product> list;

    if (await _dbProvider.count() == 0) {
      list = await _apiProvider.getProducts(search);
      _dbProvider.saveProducts(list);
    } else {
      print("from DB");

      list = await _dbProvider.getProducts(search);
      print("list form db: ${list.length}");
    }
    return list;
  }

  clearCache() async {
    _dbProvider.clear();
  }
}