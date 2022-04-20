import 'package:flutter/material.dart';
import 'package:scanner/models/product.dart';

class LineInfo extends StatelessWidget {
  const LineInfo(this._product, {Key? key}) : super(key: key);

  final Product _product;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(_product.description ?? '-'),
        ),
        Divider(height: 1),
      ]),
    );
  }
}
