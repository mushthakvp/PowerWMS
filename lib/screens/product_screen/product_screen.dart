import 'package:flutter/material.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/product_screen/widgets/line_info.dart';
import 'package:scanner/screens/product_screen/widgets/product_view.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class ProductScreen extends StatelessWidget {
  final PicklistLine _line;
  final List<StockMutationItem> _items;

  const ProductScreen(this._line, this._items, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        _line.warehouse,
        context: context,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          LineInfo(_line),
          ProductView(_line, _items),
        ],
      ),
    );
  }
}
