import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanner/main.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/reversed_provider.dart';

class ReservedList extends StatefulWidget {
  ReservedList(this.line, this.cancelledItems, {Key? key}) : super(key: key);

  final PicklistLine line;
  final List<CancelledStockMutationItem> cancelledItems;

  @override
  _ReservedListState createState() => _ReservedListState();
}

class _ReservedListState extends State<ReservedList> with RouteAware {

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe routeAware
    navigationObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPop() {
    context.read<ReservedListProvider>().reset();
    super.didPop();
  }

  @override
  void dispose() {
    // Unsubscribe routeAware
    navigationObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var line = widget.line;
    return Consumer<ReservedListProvider>(
        builder: (context, provider, _) {
          List<Widget> list = [];
          if (provider.stocks == null &&
              line.pickedAmount > 0) {
            list = [
              Center(
                child: ElevatedButton(
                  child: Text(
                    '${line.pickedAmount} ${line.product.unit} verwerkt',
                  ),
                  onPressed: () async {
                    await provider.getMutationList(
                        line.picklistId,
                        line.id
                    );
                  },
                ),
              ),
            ];
          }
          if (provider.stocks == null && provider.isLoading) {
            list = [
              Center(child: CircularProgressIndicator()),
            ];
          }
          if (provider.stocks?.length == 0 && !provider.isLoading) {
            return SliverList(delegate: SliverChildListDelegate([
              Container(
                  padding: EdgeInsets.all(16),
              child: Text('Data is empty.'))]
            ));
          }
          if (provider.stocks != null && provider.stocks!.isNotEmpty && !provider.isLoading) {
            var items = provider.stocks!;
            list = items.map((stock) => Column(
              children: [
                _itemTile(stock, () async {
                  await provider.cancelledMutation(stock.id!, line);
                }),
                Divider(height: 1),
              ],
            )).toList();
          }
          return SliverList(delegate: SliverChildListDelegate(list));
    });
  }

  _itemTile(StockMutationItem item, void Function() onCancel) {
    return ListTile(
      title: Text(
        '${item.amount} x ${item.batch} | ${item.stickerCode}       ${item.createdDate != null ? DateFormat('yy-MM-dd HH:mm').format(item.createdDate!) : ''}',
      ),
      trailing: item.isReserved() ? IconButton(
              icon: Icon(Icons.cancel_outlined, color: Colors.amber),
              onPressed: onCancel,
            )
          : null,
    );
  }
}
