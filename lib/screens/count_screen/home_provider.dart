import 'package:flutter/material.dart';
import 'package:scanner/models/count_product_stock/product_stock.dart';
import 'package:scanner/screens/count_screen/model/order/order_request.dart';
import 'package:scanner/screens/count_screen/model/order/order_response.dart';
import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:scanner/screens/count_screen/model/settings_model.dart';
import 'package:scanner/screens/count_screen/resource/product_repository.dart';
import 'package:tuple/tuple.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({
    required this.productRepository,
    /*this.settingBloc*/
  });

  /// Properties region
  ///
  late ProductRepository productRepository;

  // late SettingBloc settingBloc;
  // Setting? setting;

  /// Fetch setting
  ///
  Future<void> fetchSettings() async {
    // setting = await settingBloc.fetchSetting();
    notifyListeners();
  }

  /// Fetch products
  ///
  Future<void> fetchProducts() async {
    // setting = await settingBloc.fetchSetting();
    await productRepository.fetchProducts(null);
    notifyListeners();
  }

  Future<SettingsModel> saveContinueScannerAndReturn(
      {required bool isContinues, required bool isReturn}) async {
    return await productRepository.saveContinueScannerAndReturn(
        isContinues: isContinues, isReturn: isReturn);
  }

  // Future<SettingsModel> getSavedSetting() async {
    // return await productRepository.getSavedSetting();
  // }

  /// Fetch products stock
  ///
  Future<ProductStock?> fetchProductStock(
      {required String productCode, unitCode}) async {
    // setting = await settingBloc.fetchSetting();
    return await productRepository.fetchProductStock(
      productCode: productCode,
      unitCode: unitCode,
    );
  }

  /// Fetch searched products
  ///
  Future<List<Product>> fetchSearchedProducts() async {
    return await productRepository.fetchSearchedProducts();
  }

  /// Save searched products
  ///
  Future<void> saveSearchedProducts({required List<Product> products}) async {
    await productRepository.saveSearchedProducts(products);
  }

  /// Clear searched products
  ///
  Future<void> clearSearchedProducts() async {
    await productRepository.clearSearchedProducts();
  }

  /// Clear searched product
  ///
  Future<void> clearProduct({required int id}) async {
    await productRepository.clearProduct(id: id);
  }

  /// Update searched product
  ///
  Future<void> updateProductMoq({
    required int id,
    required num quantity,
    required num moq,
  }) async {
    await productRepository.updateProductMoq(
      id: id,
      moq: moq,
      quantity: quantity,
    );
  }

  /// Search products
  ///
  Future<List<Product>> searchProducts(String search) async {
    return await productRepository.searchProducts(search);
  }

  /// Order products
  ///
  Future<Tuple2<OrderResponse?, String?>> orderProduct(
      {required OrderRequest request}) async {
    var response = await productRepository.orderProduct(request: request);
    if (response.item1 != null) {
      return Tuple2(response.item1!, null);
    } else {
      return Tuple2(null, response.item2!.message);
    }
  }

  /// Clear products
  ///
  Future<void> clearProductCache() async {
    await productRepository.clearCache();
  }
}
