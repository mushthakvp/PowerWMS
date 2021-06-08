import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/product.dart';
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
    _future = getProducts().then((response) {
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
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<Response<Uint8List>>(
                            future: getProductImage(product.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                              }
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image.memory(
                                    snapshot.data!.data!,
                                    width: double.infinity,
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                          Text(product.uid),
                          Text(product.name),
                          Text(product.description),
                          Text(product.ean),
                          Text(product.productGroupName),
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
        ],
      ),
    );
  }

  _parse(String value) {
    setState(() {
      print(value);
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
