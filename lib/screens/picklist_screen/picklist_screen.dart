import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_item.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistScreen extends StatefulWidget {
  final Picklist _picklist;

  const PicklistScreen(this._picklist, {Key? key}) : super(key: key);

  @override
  _PicklistScreenState createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistScreen> {
  @override
  Widget build(BuildContext context) {
    final _future = getPicklistLines(widget._picklist.id);
    return Scaffold(
      appBar: WMSAppBar(
        widget._picklist.uid,
        context: context,
      ),
      body: FutureBuilder<Response<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/');
            });
          }
          if (snapshot.hasData) {
            final picklist = widget._picklist;
            final lines = (snapshot.data!.data!['data'] as List<dynamic>)
                .map((json) => PicklistLine.fromJson(json))
                .toList();
            return CustomScrollView(
              slivers: [
                PicklistItem(picklist),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final line = lines[index];
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed('/product', arguments: line);
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
                                return Center(child: Text(line.product.uid.substring(0, 1)));
                              },
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(line.product.uid, style: TextStyle(fontSize: 13)),
                              Text(line.product.description, style: TextStyle(fontSize: 16), overflow: TextOverflow.ellipsis,),
                              Text('${line.pickAmount} x ${line.product.unit}'),
                              Text('Floor 2 - Row 14', style: TextStyle(fontSize: 13, color: Colors.grey[400],)),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right),
                        ),
                        Divider(height: 5),
                      ],
                    );
                  },
                  childCount: lines.length,
                )),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
