import 'package:flutter/foundation.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/models/product_price_model.dart';
import 'package:scanner/models/product_stock.dart';
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
      print("from REMOTE");
      list = await _apiProvider.getProducts(search);
      _dbProvider.saveProducts(list);
    } else {
      print("from DB");

      list = await _dbProvider.getProducts(search);
      print("list form db: ${list.length}");
    }
    return list;
  }

  Future<void> deleteProduct(Product product) async {
    await _apiProvider.deleteProduct(product);
  }

  Future<ProductStock> fetchProductStock(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      print('====== Fetch searched products from Local');
    }
    ProductPriceModel priceModel = await _apiProvider.fetchProductPrice(
        productCode: productCode, unitCode: unitCode);

    print("dfvd");
    print(priceModel.price);

    ProductStock productStock = await _apiProvider.fetchProductStock(
        productCode: productCode, unitCode: unitCode);
    return productStock.copyWith(priceValue: priceModel.price?.toDouble());
  }

  clearCache() async {
    _dbProvider.clear();
  }
}
