import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/stock_mutation_item_repository.dart';
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
      ),
      body: StreamBuilder<List<CancelledStockMutationItem>>(
        stream: context
            .read<StockMutationItemRepository>()
            .getCancelledStockMutationItemsStream(_line.product.id),
        builder: (_, snapshot) {
          return CustomScrollView(
            slivers: <Widget>[
              LineInfo(_line),
              ProductView(_line, snapshot.data ?? []),
              ReservedList(_line, snapshot.data ?? []),
            ],
          );
        },
      ),
    );
  }
}
