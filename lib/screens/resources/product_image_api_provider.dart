import 'dart:typed_data';

import 'package:scanner/api.dart';
import 'package:scanner/screens/resources/product_image_repository.dart';

class ProductImageApiProvider implements ProductImageSource {
  Future<Uint8List?> getImageFile(int id) {
    return getProductImage(id).then((value) => value.data);
  }
}