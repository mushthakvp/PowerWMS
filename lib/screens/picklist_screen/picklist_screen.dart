import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/api.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_item.dart';
import 'package:scanner/screens/picklist_screen/widgets/product_list.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistScreen extends StatelessWidget {
  const PicklistScreen(this._picklist, {Key? key}) : super(key: key);

  final Picklist _picklist;

  @override
  Widget build(BuildContext context) {
    var picklistId = _picklist.id;
    final _future = getPicklistLines(picklistId);
    final settings = Provider.of<ValueNotifier<Settings>>(context).value;
    return Scaffold(
      appBar: WMSAppBar(
        _picklist.uid,
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
            final lines = (snapshot.data!.data!['data'] as List<dynamic>)
                .map((json) => PicklistLine.fromJson(json))
                .toList();
            if (settings.finishedProductsAtBottom) {
              lines.sort((a, b) => a.status - b.status);
            }
            return CustomScrollView(
              slivers: [
                PicklistItem(_picklist),
                ProductList(lines),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
