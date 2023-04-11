import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/product_price_model.dart';
import 'package:scanner/models/product_stock.dart';
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
  Future<bool> addOrderCount(List<Map> itemList) async {
    if (kDebugMode) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print('HTTP Headeers: ${dio.options.baseUrl}');
      log('Auth Token: ${prefs.getString('token')}');
    }
    return await dio.post<Map<String, dynamic>>(
      '/countstockmutation/count/add',
      data: {
        "warehouseId": 10,
        "countId": 2,
        "isBook": true,
        "items": itemList,
      },
    ).then((response) {
      print(response.data.toString());
      return true;
    }).onError((error, stackTrace) {
      print(error.toString());
      return false;
    });
    try {
      print('Base url: ${dio.options.baseUrl}');
      Response response = await dio.post('', data: {
        "warehouseId": 10,
        "countId": 2,
        "isBook": true,
        "items": [
          {"amount": 99, "productId": 285016}
        ],
      });
      print("svfdv");
      print(response.statusCode);
      print(response.statusMessage);
      print(response.toString());
      print("response.toString()");
    } catch (e) {
      print((e as DioError).requestOptions.data);
      print((e as DioError).requestOptions.uri.path);
      print((e as DioError).requestOptions.path);
    }
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
