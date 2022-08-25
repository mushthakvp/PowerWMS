import 'dart:async';

import 'package:scanner/dio.dart';
import 'package:scanner/models/product.dart';

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
}