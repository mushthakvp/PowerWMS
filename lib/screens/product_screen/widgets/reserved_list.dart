import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';

class ReservedList extends StatefulWidget {
  ReservedList(this.line, {Key? key}) : super(key: key);

  final PicklistLine line;

  @override
  _ReservedListState createState() => _ReservedListState();
}

class _ReservedListState extends State<ReservedList> {
  Future<List<StockMutationItem>>? _future;

  @override
  Widget build(BuildContext context) {
    var line = widget.line;
    if (_future != null) {
      return _futureBuilder();
    } else if (line.pickedAmount > 0) {
      return SliverToBoxAdapter(
        child: ListTile(
          title: ElevatedButton(
            child: Text('${line.pickedAmount} ${line.product.unit} verwerkt'),
            onPressed: () {
              setState(() {
                _future = getStockMutation(line.picklistId, line.product.id)
                    .then((response) =>
                        (response.data!['data'] as List<dynamic>)
                            .map((json) => StockMutationItem.fromJson(json))
                            .toList());
              });
            },
          ),
        ),
      );
    } else {
      return SliverToBoxAdapter();
    }
  }

  _futureBuilder() {
    return FutureBuilder<List<StockMutationItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          if (snapshot.hasData) {
            var items = snapshot.data!.toList();
            return SliverList(
                delegate: SliverChildListDelegate(items
                    .map((item) => Column(
                          children: [
                            _itemTile(item, () {
                              setState(() {
                                _future = Future.sync(() {
                                  final index = items.indexOf(item);
                                  if (index != -1) {
                                    items.replaceRange(index, index + 1, [
                                      StockMutationItem(
                                        productId: item.productId,
                                        amount: item.amount,
                                        batch: item.batch,
                                        productionDate: item.productionDate,
                                        expirationDate: item.expirationDate,
                                        stickerCode: item.stickerCode,
                                        status:
                                            StockMutationItemStatus.Cancelled,
                                      ),
                                    ]);
                                  }
                                  return items;
                                });
                              });
                              cancelStockMutation(item.id!);
                            }),
                            Divider(height: 1),
                          ],
                        ))
                    .toList()));
          }
          return SliverFillRemaining();
        });
  }

  _itemTile(
    StockMutationItem item,
    void Function() onCancel,
  ) {
    return ListTile(
      title: Text(
        '${item.amount} x ${item.batch} | ${item.stickerCode} ${item.createdDate != null ? DateFormat('yy-MM-dd HH:mm').format(item.createdDate!) : ''}',
      ),
      trailing: IconButton(
        icon: Icon(Icons.cancel_outlined, color: Colors.amber),
        onPressed: onCancel,
      ),
    );
  }
}
