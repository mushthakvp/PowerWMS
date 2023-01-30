import 'package:flutter/material.dart';
import 'package:scanner/models/product.dart';

class LineInfo extends StatelessWidget {
  const LineInfo(this._product, {Key? key}) : super(key: key);

  final Product _product;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w400);
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: EdgeInsets.only(left: 14,top: 12,bottom: 4),
          child: Text(
            _product.description ?? '-',
            style: textStyle,
          ),
        )
      ]),
    );
  }
}
