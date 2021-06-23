import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_item.dart';
import 'package:scanner/screens/picklist_screen/widgets/product_list.dart';
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
    var picklistId = widget._picklist.id;
    final _future = Future.wait([
      getPicklistLines(picklistId),
      getStockMutation(picklistId),
    ]);
    return Scaffold(
      appBar: WMSAppBar(
        widget._picklist.uid,
        context: context,
      ),
      body: FutureBuilder<List<Response<Map<String, dynamic>>>>(
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
            final lines = (snapshot.data![0].data!['data'] as List<dynamic>)
                .map((json) => PicklistLine.fromJson(json))
                .toList();
            final items = (snapshot.data![1].data!['data'] as List<dynamic>)
                .map((json) => StockMutationItem.fromJson(json))
                .toList();
            return CustomScrollView(
              slivers: [
                PicklistItem(picklist),
                ProductList(lines, items),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
