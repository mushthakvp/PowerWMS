import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanner/api.dart';

class ProductImage extends StatelessWidget {
  final int productId;
  final double? width;

  const ProductImage(this.productId, {Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<Uint8List>>(
      future: getProductImage(productId),
      builder: (context, snapshot) {
        var fallback = Container(width: width, height: width, color: Colors.grey[400]);
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.memory(
              snapshot.data!.data!,
              width: width ?? double.infinity,
              errorBuilder: (context, error, _) => fallback,
            ),
          );
        }
        return fallback;
      },
    );
  }
}
