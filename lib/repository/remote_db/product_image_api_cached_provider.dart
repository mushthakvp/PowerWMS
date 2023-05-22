import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_cache_manager/src/storage/file_system/file_system_io.dart';
import 'package:scanner/dio.dart';

class ProductImageApiCachedProvider {
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
    ).then((value) => value.readAsBytes());
  }
}
