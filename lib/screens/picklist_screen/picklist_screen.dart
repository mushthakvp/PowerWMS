import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_body.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_header.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistScreen extends StatelessWidget {
  const PicklistScreen(this._picklist, {Key? key}) : super(key: key);

  final Picklist _picklist;

  @override
  Widget build(BuildContext context) {
    final repository = context.read<PicklistLineRepository>();
    final future = repository.getPicklistLines(_picklist.id);
    return Scaffold(
      appBar: WMSAppBar(
        _picklist.uid,
        context: context,
      ),
      body: FutureBuilder<List<PicklistLine>>(
        future: future,
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
            return CustomScrollView(
              slivers: [
                PicklistHeader(_picklist),
                PicklistBody(snapshot.data!),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
