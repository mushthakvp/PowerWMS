import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final parser = GS1BarcodeParser.defaultParser();

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  Future<List<Product>>? _future;
  String _result = '';
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    _future = getProducts(null).then((response) {
      return (response.data!['data'] as List<dynamic>)
          .map((json) => Product.fromJson(json))
          .toList();
    }, onError: (_) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
        Navigator.pushReplacementNamed(context, '/');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        'Producten',
        context: context,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: _parse,
                    autofocus: true,
                    focusNode: focusNode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Barcode'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera_rounded),
                  onPressed: () async {
                    String value = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666",
                      "Cancel",
                      false,
                      ScanMode.DEFAULT,
                    );
                    _parse(value);
                  },
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: FutureBuilder<List<Product>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  if (_result == '') {
                    return Text('Scan a barcode to search for a product.');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    try {
                      final product = snapshot.data!
                          .firstWhere((product) => product.ean == _result);
                      var headline6 = Theme.of(context).textTheme.headline6;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.description,
                            style: headline6,
                          ),
                          Text(
                            '${product.ean} | ${product.uid}',
                            style: headline6,
                          ),
                          ProductImage(product.id),
                          Amount(),
                          Divider(height: 1),
                        ],
                      );
                    } catch (e) {
                      return Text('Product is not found');
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          FutureBuilder<List<Product>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              try {
                final product = snapshot.data!
                    .firstWhere((product) => product.ean == _result);
                var headline5 = Theme
                    .of(context)
                    .textTheme
                    .headline5;
                return FutureBuilder<Response<Map<String, dynamic>>>(
                  future: getProducts(product.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final products = (snapshot.data!.data!['data']
                      as List<dynamic>)
                          .where((element) =>
                      element['ean'] != product.ean).toList();
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final product = products[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    product['unit'],
                                    textAlign: TextAlign.center,
                                    style: headline5,
                                  ),
                                  subtitle: Row(
                                    children: [
                                      ProductImage(
                                        product['id'],
                                        width: 60,
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child: Amount()),
                                    ],
                                  ),
                                ),
                                Divider(height: 1),
                              ],
                            );
                          },
                          childCount: products.length,
                        ),
                      );
                    }

                    return SliverFillRemaining();
                  },
                );
              } catch(e) {
                print(e);
              }
            }

            return SliverFillRemaining();
          }),
        ],
      ),
    );
  }

  _parse(String value) {
    setState(() {
      try {
        var barcode = parser.parse(value);
        if (barcode.hasAI('01')) {
          _result = barcode.getAIData('01');
        } else {
          _result = '';
        }
      } catch (e) {
        _result = value;
      }
    });
    focusNode.requestFocus();
  }
}
