import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/providers/process_product_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/resources/stock_mutation_item_repository.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/line_info.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/product_view.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/reserved_list.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class PicklistProductScreen extends StatelessWidget {
  static const routeName = '/picklist-product';

  const PicklistProductScreen(this._line, {Key? key}) : super(key: key);

  final PicklistLine _line;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        _line.lineLocationCode ?? '',
      ),
      body: StreamBuilder<List<CancelledStockMutationItem>>(
        stream: context
            .read<StockMutationItemRepository>()
            .getCancelledStockMutationItemsStream(_line.product.id),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            log(snapshot.error, snapshot.stackTrace);
            return Container(
              child: Text('${snapshot.error}\n${snapshot.stackTrace}'),
            );
          }
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                LineInfo(_line),
                ProductView(_line, snapshot.data ?? []),
                ReservedList(_line, snapshot.data ?? []),
              ],
            );
          }
          return Container(
            child: Text('Something is wrong.'),
          );
        },
      ),
      bottomNavigationBar: Consumer<ProcessProductProvider>(
        builder: (context, provider, _) {
          return ListTile(
            visualDensity: VisualDensity.compact,
            title: ElevatedButton(
                child: Text(AppLocalizations.of(context)!
                    .productProcess
                    .toUpperCase()),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      provider.canProcess ? Colors.blue : Colors.grey
                  ),
                ),
                onPressed: provider.canProcess ? () {
                  if (provider.mutationProvider != null) {
                    _onProcessHandler(provider.mutationProvider!, context);
                  }
                } : null
            ),
          );
        },
      ),
    );
  }

  _onProcessHandler(MutationProvider provider, BuildContext context) {
    context
        .read<StockMutationRepository>()
        .saveMutation(provider.getStockMutation())
        .then((value) {
      provider.clear();
      Navigator.of(context).pop();
    });
  }
}
