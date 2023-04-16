import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/src/api/record_ref.dart';

class ProductDbProvider {
  ProductDbProvider(this.db);

  final _store = intMapStoreFactory.store('products');
  final _generalSettings = StoreRef.main();

  final _searchedStore = intMapStoreFactory.store('searched_products');
  final Database db;

  Future<List<Product>> getProducts(String? search) {
    var finder = Finder(
        filter: search == null
            ? null
            : Filter.or([
                Filter.equals('uid', search),
                Filter.equals('name', search),
                Filter.equals('ean', search),
                // Filter.custom((record) {
                //   final value = record['ean'] as String;
                //   return value.toLowerCase().contains(search);
                // }),
                Filter.custom((record) {
                  final value = record['description'] as String;
                  return value.toLowerCase().contains(search);
                })
              ]));

    return _store.find(db, finder: finder).then((records) =>
        records.map((snapshot) => Product.fromJson(snapshot.value)).toList());
  }

  Future<dynamic> saveProducts(List<Product> products) {
    return _store
        .records(products.map<int>((product) => product.id))
        .put(db, products.map((product) => product.toJson()).toList());
  }

  Future<List<Product>> getSearchedProducts() async {
    return await _searchedStore.find(db, finder: null).then((records) =>
        records.map((snapshot) => Product.fromJson(snapshot.value)).toList());
  }

  Future<void> saveSearchedProducts(List<Product> products) async {
    await _searchedStore
        .records(products.map<int>((product) => product.id))
        .put(db, products.map((product) => product.toJson()).toList());
  }

  Future<void> clearProduct({required int id}) async {
    await _searchedStore.record(id).delete(db);
  }

  Future<void> clearSearchedProducts() async {
    await _searchedStore.drop(db);
  }

  Future<void> updateProductMoq({
    required int id,
    required num moq,
    required num quantity,
  }) async {
    await _searchedStore.record(id).update(db, {
      // 'moq': moq,
      "stock": quantity,
    });
  }

  Future<Value?> saveContinueScannerAndReturn(
      {required bool isContinues, required bool isReturn}) async {
    return await _generalSettings.record("settings").put(db, {
      'is_continues': isContinues,
      'is_return': isReturn,
    });
  }

  // Future<Map> getSavedSetting() async {
    // var settings = await _generalSettings.record('settings').get(db) as Map;
    // return settings;
  // }

  Future<int> count() {
    return _store.count(db);
  }

  Future<dynamic> clear() {
    return _store.drop(db);
  }
}
