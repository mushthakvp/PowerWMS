import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/widgets/barcode_input.dart';

filter(String search) => (PicklistLine line) =>
    search == '' || line.product.ean == search || line.product.uid == search;

const blue = Color(0xFF034784);
const white = Colors.white;
final black = Colors.grey[900];

class ProductList extends StatefulWidget {
  const ProductList(this.lines, {Key? key}) : super(key: key);

  final List<PicklistLine> lines;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
              Column(
                children: [
                  ListTile(
                    title: BarcodeInput((value, barcode) {
                      setState(() {
                        final lines = widget.lines.where(filter(value));
                        if (lines.length == 1) {
                          Navigator.of(context)
                              .pushNamed('/product', arguments: lines.first)
                              .then((value) {
                            setState(() {});
                          });
                        } else {
                          _search = value;
                        }
                      });
                    }),
                  ),
                  Divider(),
                ],
              ),
            ].toList() +
            widget.lines.where(filter(_search)).map((line) {
              var fullyPicked = line.isFullyPicked();
              return Column(
                children: [
                  ListTile(
                    tileColor: fullyPicked ? blue : null,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('/product', arguments: line)
                          .then((value) {
                        setState(() {});
                      });
                    },
                    leading: Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: FutureBuilder<Response<Uint8List>>(
                        future: getProductImage(line.product.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Image.memory(snapshot.data!.data!);
                          }
                          return Center(
                              child: Text(line.product.uid.substring(0, 1)));
                        },
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.product.uid,
                          style: TextStyle(
                            fontSize: 13,
                            color: fullyPicked ? white : black,
                          ),
                        ),
                        if (line.product.description != null)
                          Text(
                            line.product.description!,
                            style: TextStyle(
                              fontSize: 16,
                              color: fullyPicked ? white : black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          '${line.pickAmount} (${line.product.unit})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: fullyPicked ? white : black,
                          ),
                        ),
                      ],
                    ),
                    subtitle: line.location != null
                        ? Text(
                            line.location!,
                            style: TextStyle(
                              fontSize: 13,
                              color: fullyPicked ? white : Colors.grey[400],
                            ),
                          )
                        : null,
                    trailing: Icon(
                      Icons.chevron_right,
                      color: fullyPicked ? white : black,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: fullyPicked ? blue : null,
                  ),
                ],
              );
            }).toList()));
  }
}
