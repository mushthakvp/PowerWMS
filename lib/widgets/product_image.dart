import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanner/screens/resources/product_image_repository.dart';

final productImageRepository = ProductImageRepository();

class ProductImage extends StatelessWidget {
  final int productId;
  final double? width;

  const ProductImage(this.productId, {Key? key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: productImageRepository.getImageFile(productId),
      builder: (context, snapshot) {
        var fallback = Container(width: width, height: width, color: Colors.grey[400]);
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.memory(
              snapshot.data!,
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
