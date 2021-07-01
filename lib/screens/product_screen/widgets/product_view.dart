import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/product_screen/widgets/scan_form.dart';
import 'package:scanner/widgets/product_image.dart';

class ProductView extends StatefulWidget {
  const ProductView(this.mutation, {Key? key}) : super(key: key);

  final StockMutation mutation;

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  int _amount = 0;

  @override
  void initState() {
    _amount = widget.mutation.toPickAmount;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mutation = widget.mutation;
    final line = mutation.line;
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
              ProductImage(line.product.id, width: 120),
            ],
          ),
        ),
        Divider(height: 1),
        _pickTile(mutation),
        Divider(height: 1),
        ScanForm(
          mutation,
          (process) {
            setState(() {});
            if (process) {
              _onProcessHandler(mutation);
            }
          },
          _amount,
          (int amount) {
            setState(() {
              _amount = amount;
            });
          },
        ),
        ListTile(
          visualDensity: VisualDensity.compact,
          trailing: ElevatedButton(
            child: Text(
                AppLocalizations.of(context)!.productProcess.toUpperCase()),
            onPressed: mutation.items.length > 0
                ? () {
                    _onProcessHandler(mutation);
                  }
                : null,
          ),
        ),
        Divider(height: 1),
        ..._itemsBuilder(
          mutation.items,
          (item) => mutation.removeItem(item),
        ),
      ]),
    );
  }

  _pickTile(StockMutation mutation) {
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

  _onProcessHandler(StockMutation mutation) {
    addStockMutation(mutation).then((response) {
      if (response.data != null) {
        final snackBar = SnackBar(
          backgroundColor:
              response.data!['success'] as bool ? Colors.green : Colors.red,
          content: Text(response.data!['message']),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        if (response.data!['success']) {
          widget.mutation.line.pickedAmount += mutation.totalAmount;
          mutation.clear();
          Navigator.of(context).pop();
        }
      }
    });
  }

  _itemsBuilder(
    List<StockMutationItem> items,
    void Function(StockMutationItem item) onRemove,
  ) {
    return items.map((item) {
      return Dismissible(
        key: Key(item.batch),
        onDismissed: (direction) {
          setState(() {
            onRemove(item);
            _amount = widget.mutation.toPickAmount;
          });
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
