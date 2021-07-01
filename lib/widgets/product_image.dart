import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanner/screens/resources/product_image_repository.dart';

final productImageRepository = ProductImageRepository();

class ProductImage extends StatefulWidget {
  final int productId;
  final double? width;

  const ProductImage(this.productId, {Key? key, this.width}) : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  Future<Uint8List?>? _future;

  @override
  void didChangeDependencies() {
    _future = productImageRepository.getImageFile(widget.productId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future!,
      builder: (context, snapshot) {
        var fallback = Container(
          width: widget.width,
          height: widget.width,
          color: Colors.grey[400],
        );
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.memory(
              snapshot.data!,
              width: widget.width ?? double.infinity,
              errorBuilder: (context, error, _) => fallback,
            ),
          );
        }
        return fallback;
      },
    );
  }
}
