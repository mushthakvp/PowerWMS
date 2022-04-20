import 'package:flutter/material.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/screens/product_screen/widgets/line_info.dart';
import 'package:scanner/screens/product_screen/widgets/product_view.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';

  const ProductScreen(this._product, {Key? key}) : super(key: key);

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(''),
      body: CustomScrollView(
        slivers: <Widget>[
          LineInfo(_product),
          ProductView(_product),
        ],
      ),
    );
  }
}
