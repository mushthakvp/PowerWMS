// import 'package:brouwer/models/ProductPriceModel.dart';
// import 'package:brouwer/models/ProductStock.dart';
// import 'package:brouwer/models/order/order_request.dart';
// import 'package:brouwer/models/order/order_response.dart';
// import 'package:brouwer/models/product.dart';
// import 'package:brouwer/models/settings_model.dart';
// import 'package:brouwer/resource/order_api_provider.dart';
// import 'package:brouwer/resource/product_api_provider.dart';
// import 'package:brouwer/resource/product_db_provider.dart';
// import 'package:brouwer/utils/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:sembast/sembast.dart';
// import 'package:tuple/tuple.dart';
//
// class ProductRepository {
//   ProductRepository(Database db) {
//     _apiProvider = ProductApiProvider();
//     _dbProvider = ProductDbProvider(db);
//     _orderApiProvider = OrderApiProvider();
//   }
//
//   late ProductApiProvider _apiProvider;
//   late OrderApiProvider _orderApiProvider;
//   late ProductDbProvider _dbProvider;
//
//   Future<List<Product>> fetchProducts(String? search) async {
//     List<Product> list;
//     if (kDebugMode) {
//       print('====== Fetch products from API');
//     }
//     list = await _apiProvider.getProducts(search);
//     _dbProvider.saveProducts(list);
//     return list;
//   }
//
//   Future<List<Product>> fetchSearchedProducts() async {
//     if (kDebugMode) {
//       print('====== Fetch searched products from Local');
//     }
//     return await _dbProvider.getSearchedProducts();
//   }
//
//   Future<ProductStock> fetchProductStock(
//       {required String productCode, unitCode}) async {
//     if (kDebugMode) {
//       print('====== Fetch searched products from Local');
//     }
//     ProductPriceModel priceModel = await _apiProvider.fetchProductPrice(
//         productCode: productCode, unitCode: unitCode);
//
//     print("dfvd");
//     print(priceModel.price);
//
//     ProductStock productStock = await _apiProvider.fetchProductStock(
//         productCode: productCode, unitCode: unitCode);
//     return productStock.copyWith(priceValue: priceModel.price?.toDouble());
//   }
//
//   Future<void> saveSearchedProducts(List<Product> products) async {
//     await _dbProvider.saveSearchedProducts(products);
//   }
//
//   Future<SettingsModel> saveContinueScannerAndReturn(
//       {required bool isContinues, required bool isReturn}) async {
//     final response = await _dbProvider.saveContinueScannerAndReturn(
//         isContinues: isContinues, isReturn: isReturn);
//
//     return SettingsModel.fromJson(response);
//   }
//
//   Future<SettingsModel> getSavedSetting() async {
//     final response = await _dbProvider.getSavedSetting();
//     return SettingsModel.fromJson(response);
//   }
//
//   Future<void> clearSearchedProducts() async {
//     await _dbProvider.clearSearchedProducts();
//   }
//
//   Future<void> clearProduct({required int id}) async {
//     await _dbProvider.clearProduct(id: id);
//   }
//
//   Future<void> updateProductMoq({
//     required int id,
//     required num quantity,
//     required num moq,
//   }) async {
//     await _dbProvider.updateProductMoq(
//       id: id,
//       moq: moq,
//       quantity: quantity,
//     );
//   }
//
//   Future<List<Product>> searchProducts(String search) async {
//     if (kDebugMode) {
//       print('====== Search product from local storage');
//     }
//     if (search.length == 13) {
//       final request = '0$search';
//       final res = await _dbProvider.getProducts(request);
//       if (res.isNotEmpty) {
//         return res;
//       }
//     }
//     final res = await _dbProvider.getProducts(search);
//     if (res.isNotEmpty) {
//       return res;
//     } else {
//       final product = await _apiProvider.getProduct(search);
//       return product;
//     }
//   }
//
//   Future<Tuple2<OrderResponse?, Failure?>> orderProduct(
//       {required OrderRequest request}) async {
//     return await _orderApiProvider.orderProduct(request: request);
//   }
//
//   clearCache() async {
//     _dbProvider.clear();
//   }
// }
