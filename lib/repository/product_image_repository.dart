import 'dart:typed_data';

import 'package:scanner/repository/remote_db/product_image_api_cached_provider.dart';

class ProductImageRepository {
  final productImageApiCachedProvider = ProductImageApiCachedProvider();

  Future<Uint8List?> getImageFile(int id) async {
    return await productImageApiCachedProvider.getImageFile(id);
  }
}
