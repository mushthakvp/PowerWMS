import 'dart:io';
import 'dart:typed_data';

import 'package:scanner/screens/resources/product_image_api_provider.dart';
import 'package:scanner/screens/resources/product_image_cache_provider.dart';

abstract class ProductImageSource {
  Future<Uint8List?> getImageFile(int id);
}

abstract class ProductImageCache {
  Future<File> setImageFile(int id, Uint8List fileBytes);
}

class ProductImageRepository {
  List<ProductImageSource> sources = <ProductImageSource>[
    productImageCacheProvider,
    // ProductImageApiProvider(),
  ];

  List<ProductImageCache> caches = <ProductImageCache>[
    productImageCacheProvider,
  ];

  Future<Uint8List?> getImageFile(int id) async {
    Uint8List? bytes;
    ProductImageSource? source;

    for (source in sources) {
      bytes = await source.getImageFile(id);
      if (bytes != null) {
        break;
      }
    }

    // for (ProductImageCache cache in caches) {
    //   if (bytes != null) {
    //     cache.setImageFile(id, bytes);
    //   }
    // }

    return bytes;
  }
}