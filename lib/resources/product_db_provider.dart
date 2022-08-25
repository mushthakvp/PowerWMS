import 'package:scanner/models/product.dart';
import 'package:sembast/sembast.dart';

class ProductDbProvider {
  ProductDbProvider(this.db);

  final _store = intMapStoreFactory.store('products');
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

  Future<int> count() {
    return _store.count(db);
  }

  Future<dynamic> clear() {
    return _store.drop(db);
  }
}