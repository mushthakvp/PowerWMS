import 'package:flutter/foundation.dart';
import 'package:scanner/models/ProductDetailModel.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/models/product_price_model.dart';
import 'package:scanner/models/product_stock.dart';
import 'package:scanner/repository/remote_db/product_api_provider.dart';
import 'package:scanner/repository/local_db/product_db_provider.dart';
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

      list = await _dbProvider.getProducts(search);
    }
    return list;
  }

  Future<void> deleteProduct(Product product) async {
    await _apiProvider.deleteProduct(product);
  }

  Future<ProductStock> fetchProductStock(
      {required String productCode, unitCode}) async {
    ProductPriceModel priceModel = await _apiProvider.fetchProductPrice(
        productCode: productCode, unitCode: unitCode);


    ProductStock productStock = await _apiProvider.fetchProductStock(
        productCode: productCode, unitCode: unitCode);
    return productStock.copyWith(priceValue: priceModel.price?.toDouble());
  }

  Future<ProductDetailModel> fetchProductDetails(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      print('====== Fetch searched products from Local');
    }
    ProductDetailModel productDetailModel =
        await _apiProvider.fetchProductDetails(
      productCode: productCode,
      unitCode: unitCode,
    );
    return productDetailModel;
  }

  clearCache() async {
    _dbProvider.clear();
  }
}
