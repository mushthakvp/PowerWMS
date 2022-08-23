import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/resources/stock_mutation_item_repository.dart';

class ReservedList extends StatefulWidget {
  ReservedList(this.line, this.cancelledItems, {Key? key}) : super(key: key);

  final PicklistLine line;
  final List<CancelledStockMutationItem> cancelledItems;

  @override
  _ReservedListState createState() => _ReservedListState();
}

class _ReservedListState extends State<ReservedList> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    var line = widget.line;
    final repository = context.read<StockMutationItemRepository>();
    return StreamBuilder<List<StockMutationItem>>(
        stream: _active
            ? repository.getStockMutationItemsStream(
                line.picklistId,
                line.id,
                line.product.id
              )
            : null,
        builder: (context, snapshot) {
          List<Widget> list = [];
          if (snapshot.connectionState == ConnectionState.none &&
              line.pickedAmount > 0) {
            list = [
              Center(
                child: ElevatedButton(
                  child: Text(
                    '${line.pickedAmount} ${line.product.unit} verwerkt',
                  ),
                  onPressed: () {
                    setState(() {
                      _active = true;
                    });
                  },
                ),
              ),
            ];
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            list = [
              Center(child: CircularProgressIndicator()),
            ];
          }
          if (snapshot.hasError) {
            log(snapshot.error, snapshot.stackTrace);
            list = [Text('Something is wrong.')];
          }
          if (snapshot.hasData) {
            var items = snapshot.data!.toList();
            list = items
                .map((item) => Column(
                      children: [
                        _itemTile(item, () {
                          repository.tryCancelItem(item);
                        }),
                        Divider(height: 1),
                      ],
                    ))
                .toList();
          }
          return SliverList(delegate: SliverChildListDelegate(list));
        });
  }

  _itemTile(StockMutationItem item, void Function() onCancel) {
    return ListTile(
      title: Text(
        '${item.amount} x ${item.batch} | ${item.stickerCode}       ${item.createdDate != null ? DateFormat('yy-MM-dd HH:mm').format(item.createdDate!) : ''}',
      ),
      trailing: item.isReserved() &&
              !widget.cancelledItems.any((cancelled) => cancelled.id == item.id)
          ? IconButton(
              icon: Icon(Icons.cancel_outlined, color: Colors.amber),
              onPressed: onCancel,
            )
          : null,
    );
  }
}
