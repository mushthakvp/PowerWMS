import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/models/picklist_line.dart';

class LineInfo extends StatefulWidget {
  final PicklistLine _line;

  const LineInfo(this._line, {Key? key}) : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<LineInfo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final line = widget._line;
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          visualDensity: VisualDensity.compact,
          title: Text(line.product.description),
          trailing: Icon(_open ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _open = !_open;
            });
          },
        ),
        Divider(height: 1),
        if (_open) ..._tiles(line),
      ]),
    );
  }

  _tiles(PicklistLine line) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('GTIN'),
                Text(line.product.ean),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Product number'),
                Text(line.product.uid),
              ],
            ),
          ],
        ),
      ),
      Divider(height: 1),
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Available'),
                Text('${line.available} x ${line.product.unit}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Amount orderline'),
                Text('${line.pickAmount} x ${line.product.unit}'),
              ],
            ),
          ],
        ),
      ),
      Divider(height: 1),
    ];
  }
}
