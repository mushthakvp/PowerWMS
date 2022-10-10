import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/resources/product_repository.dart';
import 'package:scanner/screens/product_screen/product_screen.dart';
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
  TextEditingController _searchTermController = TextEditingController();

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
                    controller: _searchTermController,
                    onSubmitted: _parse,
                    autofocus: true,
                    focusNode: focusNode,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText:
                      AppLocalizations.of(context)!.productScreenSearch,
                    ),
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
          FutureBuilder<List<Product>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData && _result.isNotEmpty) {
                final repository = context.read<ProductRepository>();
                try {
                  return FutureBuilder<List<Product>>(
                    future: repository.getProducts(_result),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print('${snapshot.error}\n${snapshot.stackTrace}');
                      }
                      if (_result == '') {
                        return SliverPadding(
                          padding: const EdgeInsets.all(20),
                          sliver: SliverToBoxAdapter(
                            child:
                            Text(AppLocalizations.of(context)!.barcodeHelp),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SliverPadding(
                          padding: const EdgeInsets.all(10),
                          sliver: SliverToBoxAdapter(
                              child:
                              Center(child: CircularProgressIndicator())),
                        );
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data!.length == 0) {
                          return SliverPadding(
                            padding: const EdgeInsets.all(20),
                            sliver: SliverToBoxAdapter(
                                child: Text(
                                  AppLocalizations.of(context)!.productNotFound,
                                )),
                          );
                        }

                        final products = snapshot.data!;

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final product = products[index];

                              if (products.length == 0) {
                                return Text(
                                  AppLocalizations.of(context)!.productNotFound,
                                );
                              }

                              if (products.length == 1) {
                                final product = products.first;
                                return _buildProductDisplay(product);
                              }
                              return Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductScreen(product),
                                        ),
                                      );
                                    },
                                    leading: ProductImage(
                                      product.id,
                                      width: 60,
                                      key: widget.key,
                                    ),
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.uid,
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  product.description ?? '',
                                                  overflow:
                                                  TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: Icon(Icons.chevron_right),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
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

  Widget _buildProductDisplay(Product product) {
    Locale mylocale = Localizations.localeOf(context);
    return Column(
      children: [
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(product.description ?? '-'),
        ),
        Divider(height: 1),
        ListTile(
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.productProductNumber}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(product.uid),
                  SizedBox(height: 10),
                  const Text(
                    'GTIN / EAN:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(product.ean ?? ''),
                ],
              ),
              Spacer(),
              ProductImage(product.id, width: 120),
            ],
          ),
        ),
        Divider(height: 1),
        ListTile(
          dense: true,
          title: Text('Packaging'),
        ),
        ...product.packagings.map((packaging) => Column(
          children: [
            ListTile(
              dense: true,
              title: Text(
                  '${mylocale.languageCode == "en" ? packaging.packagingUnitTranslations.first.value : packaging.packagingUnitTranslations.last.value} (${packaging.defaultAmount})'),
            ),
            // ...packaging.packagingUnitTranslations
            //     .map((translation) => ListTile(
            //           dense: true,
            //           title: Text('${translation.value}'),
            //         )),
          ],
        )),
        Divider(height: 1),
        if (product.extra1 != null)
          ListTile(
            dense: true,
            title: Text('Extra 1: ${product.extra1}'),
          ),
        if (product.extra2 != null)
          ListTile(
            dense: true,
            title: Text('Extra 2: ${product.extra2}'),
          ),
        if (product.extra3 != null)
          ListTile(
            dense: true,
            title: Text('Extra 3: ${product.extra3}'),
          ),
        if (product.extra4 != null)
          ListTile(
            dense: true,
            title: Text('Extra 4: ${product.extra4}'),
          ),
        if (product.extra5 != null)
          ListTile(
            dense: true,
            title: Text('Extra 5: ${product.extra5}'),
          ),
      ],
    );
  }

  _parse(String value) {
    setState(() {
      try {
        var barcode = parser.parse(value.trim());
        if (barcode.hasAI('01')) {
          _result = barcode.getAIData('01');
        } else {
          _result = '';
        }
      } catch (e) {
        _result = value.trim();
      }
    });
    focusNode.requestFocus();
  }
}