import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// ignore: implementation_imports
import 'package:flutter_cache_manager/src/storage/file_system/file_system_io.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/screens/resources/product_image_repository.dart';

class ProductImageCacheProvider
    implements ProductImageSource, ProductImageCache {
  static const key = 'productImageCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 100,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileSystem: IOFileSystem(key),
      fileService: HttpFileService(),
    ),
  );

  Future<Uint8List?> getImageFile(int id) {
    return instance.getSingleFile(
      '${dio.options.baseUrl}/product/image/$id',
      headers: {
        'authorization': dio.options.headers['authorization'],
      },
    ).then(
      (value) => value.readAsBytes(),
    );
  }

  Future<File> setImageFile(int id, Uint8List fileBytes) {
    return instance.putFile('/product/image/$id', fileBytes);
  }
}

final productImageCacheProvider = ProductImageCacheProvider();
