import 'package:flutter/material.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/screens/product_screen/widgets/line_info.dart';
import 'package:scanner/screens/product_screen/widgets/product_view.dart';
import 'package:scanner/screens/product_screen/widgets/reserved_list.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this._line, {Key? key}) : super(key: key);

  final PicklistLine _line;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        _line.location ?? '',
        context: context,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          LineInfo(_line),
          ProductView(_line),
          ReservedList(_line),
        ],
      ),
    );
  }
}
