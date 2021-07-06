import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
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
      body: FutureBuilder<StockMutation>(
        future: StockMutation.fromMemory(_line),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var mutation = snapshot.data!;
            return ChangeNotifierProvider<StockMutation>.value(
              value: mutation,
              child: CustomScrollView(
                slivers: <Widget>[
                  LineInfo(_line),
                  ProductView(),
                  ReservedList(_line, (item) {
                    mutation.changeLinePickedAmount(-item.amount.abs());
                  }),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
