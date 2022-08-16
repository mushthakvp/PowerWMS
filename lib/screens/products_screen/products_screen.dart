import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/resources/product_repository.dart';
import 'package:scanner/screens/product_screen/product_screen.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

final parser = GS1BarcodeParser.defaultParser();

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

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
    final repository = context.read<ProductRepository>();
    _future = repository.getProducts(null).catchError((_) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.getKeys().forEach((key) {
          if (key != 'server') {
            prefs.remove(key);
          }
        });
        Navigator.pushReplacementNamed(context, '/');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        AppLocalizations.of(context)!.products,
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
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.barcode),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.photo_camera_rounded),
                  onPressed: () async {
                    String value = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666",
                      AppLocalizations.of(context)!.cancel,
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
                    print('${snapshot.error}\n${snapshot.stackTrace}');
                  }
                  if (_result == '') {
                    return Text(AppLocalizations.of(context)!.barcodeHelp);
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    try {
                      final product = snapshot.data!.firstWhere((product) =>
                          product.ean == _result || product.uid == _result);
                      var headline6 = Theme.of(context).textTheme.headline6;
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(product),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (product.description != null)
                              Text(
                                product.description!,
                                style: headline6,
                              ),
                            Text(
                              '${product.ean} | ${product.uid}',
                              style: headline6,
                            ),
                            ProductImage(product.id),
                            Amount(1, (value) {}, autofocus: false),
                            Divider(height: 1),
                          ],
                        ),
                      );
                    } catch (e) {
                      return Text(
                        AppLocalizations.of(context)!.productNotFound,
                      );
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
                final repository = context.read<ProductRepository>();
                try {
                  final product = snapshot.data!
                      .firstWhere((product) => product.ean == _result);
                  var headline5 = Theme.of(context).textTheme.headline5;
                  return FutureBuilder<List<Product>>(
                    future: repository.getProducts(product.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final products = snapshot.data!
                            .where((element) => element.ean != product.ean)
                            .toList();
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final product = products[index];
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      product.unit,
                                      textAlign: TextAlign.center,
                                      style: headline5,
                                    ),
                                    subtitle: Row(
                                      children: [
                                        ProductImage(
                                          product.id,
                                          width: 60,
                                        ),
                                        SizedBox(width: 20),
                                        Expanded(
                                          child: Amount(1, (value) {}, autofocus: false),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductScreen(product),
                                        ),
                                      );
                                    },
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
                } catch (e, stack) {
                  print('$e\n$stack');
                }
              }

              return SliverFillRemaining();
            },
          ),
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
