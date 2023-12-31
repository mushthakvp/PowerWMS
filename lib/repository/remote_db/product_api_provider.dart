import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/ProductDetailModel.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/models/product_price_model.dart';
import 'package:scanner/models/product_stock.dart';

Future<ProductStock> parseProductStock(Map<String, dynamic> response) async {
  return ProductStock.fromJson(response);
}

Future<ProductPriceModel> parseProductPrice(
    Map<String, dynamic> response) async {
  return ProductPriceModel.fromJson(response);
}

Future<ProductDetailModel> parseProductDetail(
    Map<String, dynamic> response) async {
  return ProductDetailModel.fromJson(response);
}

class ProductApiProvider {
  Future<List<Product>> getProducts(String? search) {
    return dio.post<Map<String, dynamic>>(
      '/product/list',
      data: {
        'search': search,
        'skipPaging': true,
      },
    ).then((response) {
      return (response.data!['data'] as List<dynamic>)
          .map((json) => Product.fromJson(json))
          .toList();
    });
  }

  Future<void> deleteProduct(Product product) {
    return dio
        .delete<Map<String, dynamic>>(
      '/product/${product.id}/units/${product.packagings.first.packagingUnitId}',
    )
        .then((response) {
    });
  }

  Future<ProductStock> fetchProductStock(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      print('HTTP Headers: ${dio.options.baseUrl}');
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
      return compute(parseProductStock, response.data! as Map<String, dynamic>);
    } else {
      return ProductStock();
    }
  }

  Future<ProductPriceModel> fetchProductPrice(
      {required String productCode, unitCode}) async {
    if (kDebugMode) {
      // print('HTTP Headers: ${dio.options.baseUrl}');
      // print('HTTP Headers: ${erpDio.options.baseUrl}');
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
      return compute(
          parseProductPrice, response.data[0]! as Map<String, dynamic>);
    } else {
      return ProductPriceModel();
    }
  }

  Future<ProductDetailModel> fetchProductDetails(
      {required String productCode, unitCode}) async {
    erpDio.options.extra = {"isLoading": false};
    final response = await erpDio.get(
      '/products/$productCode,$unitCode',
    );

    if (response.statusCode == 200) {
      return compute(
          parseProductDetail, response.data as Map<String, dynamic>);
    } else {
      return ProductDetailModel();
    }
  }
}
