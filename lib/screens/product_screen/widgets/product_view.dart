import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/screens/product_screen/widgets/scan_form.dart';
import 'package:scanner/widgets/product_image.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StockMutation>(
      builder: (context, mutation, _) {
        return SliverList(
          delegate: SliverChildListDelegate([
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
                      Text(mutation.line.product.uid),
                      SizedBox(height: 10),
                      const Text(
                        'GTIN / EAN:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(mutation.line.product.ean),
                    ],
                  ),
                  Spacer(),
                  // SizedBox(width: 20),
                  ProductImage(mutation.line.product.id, width: 120),
                ],
              ),
            ),
            Divider(height: 1),
            _pickTile(mutation, context),
            Divider(height: 1),
            ScanForm(
              (process) {
                if (process) {
                  _onProcessHandler(mutation, context);
                }
              },
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              trailing: ElevatedButton(
                child: Text(
                    AppLocalizations.of(context)!.productProcess.toUpperCase()),
                onPressed: mutation.items.length > 0
                    ? () {
                        _onProcessHandler(mutation, context);
                      }
                    : null,
              ),
            ),
            Divider(height: 1),
            ..._itemsBuilder(mutation),
          ]),
        );
      },
    );
  }

  _pickTile(StockMutation mutation, BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .productAmountAsked(mutation.line.product.unit),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '${mutation.askedAmount}',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!
                    .productAmountBoxes(mutation.askedPackagingAmount)
                    .toUpperCase(),
              ),
            ],
          ),
          SizedBox(width: 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!
                    .productAmountToPick(mutation.line.product.unit),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '${mutation.toPickAmount}',
                  style: TextStyle(
                    fontSize: 50,
                    color:
                        mutation.toPickAmount < 0 ? Colors.red : Colors.black54,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!
                    .productAmountBoxes(mutation.toPickPackagingAmount)
                    .toUpperCase(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _onProcessHandler(StockMutation mutation, BuildContext context) {
    addStockMutation(mutation).then((response) {
      if (response.data != null) {
        final snackBar = SnackBar(
          backgroundColor:
              response.data!['success'] as bool ? Colors.green : Colors.red,
          content: Text(response.data!['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (response.data!['success']) {
          final repository = context.read<PicklistLineRepository>();
          repository
              .refreshPicklistLine(mutation.line.picklistId, mutation.line.id)
              .then((_) {
            mutation.clear();
            Navigator.of(context).pop();
          });
        }
      }
    });
  }

  _itemsBuilder(StockMutation mutation) {
    return mutation.items.map((item) {
      return Dismissible(
        key: Key(item.batch),
        onDismissed: (direction) {
          mutation.removeItem(item);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${item.amount} x ${item.batch} | ${item.stickerCode}',
              ),
            ),
            Divider(height: 1),
          ],
        ),
      );
    });
  }
}
