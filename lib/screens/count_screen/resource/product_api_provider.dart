import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/product_price_model.dart';
import 'package:scanner/models/product_stock.dart';
import 'package:scanner/screens/count_screen/model/CountListModel.dart';
import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Product>> parseProduct(Map<String, dynamic> response) async {
  return (response['data'] as List<dynamic>)
      .map((json) => Product.fromJson(json))
      .toList();
}

Future<ProductStock> parseProductStock(Map<String, dynamic> response) async {
  return ProductStock.fromJson(response);
}

Future<ProductPriceModel> parseProductPrice(
    Map<String, dynamic> response) async {
  return ProductPriceModel.fromJson(response);
}

class ProductApiProvider {
  Future<List<CountListModel>?> getOrderCount() async {
    var response = await dio.get('/countstockmutation/count/all');
    print(response.data);
    return ((response.data as List)
        .map((e) => CountListModel.fromJson(e))
        .toList());
  }

  Future<bool> addOrderCount(
      {required int warehouseId,
      required int countId,
      required List<Map> itemList}) async {
    return await dio.post<Map<String, dynamic>>(
      '/countstockmutation/count/add',
      data: {
        "warehouseId": warehouseId,
        "countId": countId,
        "isBook": true,
        "items": itemList,
      },
    ).then((response) {
      if (response.data!['success'])
        return true;
      else
        return false;
    }).onError((DioError error, stackTrace) {
      return false;
    });
  }

  Future<List<Product>> getProducts(String? search) async {
    if (kDebugMode) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('HTTP Headers: ${dio.options.baseUrl}');
      print('Auth Token: ${prefs.getString('token')}');
    }
    return await dio.post<Map<String, dynamic>>(
      '/product/list',
      data: {
        'search': search,
        'skipPaging': true,
      },
    ).then((response) {
      return compute(parseProduct, response.data!);
    }).onError((error, stackTrace) {
      return [];
    });
  }

  Future<List<Product>> getProduct(String search) async {
    if (kDebugMode) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('HTTP Headers: ${dio.options.baseUrl}');
      print('Auth Token: ${prefs.getString('token')}');
    }
    return await dio.post<Map<String, dynamic>>(
      '/product/list',
      data: {
        'search': search,
        'skipPaging': true,
      },
    ).then((response) {
      return compute(parseProduct, response.data!);
    }).onError((error, stackTrace) {
      return [];
    });
  }

  Future<ProductStock> fetchProductStock(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('HTTP Headers: ${dio.options.baseUrl}');
      print('Auth Token: ${prefs.getString('token')}');
    }

    erpDio.options.extra = {"isLoading": false};
    final response = await erpDio.post(
      '/requestProductStock',
      data: {
        "limit": 10,
        "offset": 0,
        "onlyActiveProducts": true,
        "productIdentifiers": [
          {
            "productIdentifier": {"productCode": productCode},
            "unitCode": unitCode
          }
        ]
      },
    );
    if (response.statusCode == 200) {
      print(json.encode(response.data));
      print(response.statusMessage);
      print(response.statusCode);
      return compute(parseProductStock, response.data! as Map<String, dynamic>);
    } else {
      print("sdfkv");
      return ProductStock();
    }
  }

  Future<ProductPriceModel> fetchProductPrice(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('HTTP Headers: ${dio.options.baseUrl}');
      print('Auth Token: ${prefs.getString('token')}');
    }
    erpDio.options.extra = {"isLoading": false};
    final response = await erpDio.get(
      '/productSalesPrices',
      queryParameters: {
        "filter":
            "ProductCode EQ \"$productCode\" and showExpired EQ no and UnitCode EQ \"$unitCode\""
      },
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      print(response.statusMessage);
      print(response.statusCode);
      return compute(
          parseProductPrice, response.data[0]! as Map<String, dynamic>);
    } else {
      print("badd errirr");
      return ProductPriceModel();
    }
  }
}
