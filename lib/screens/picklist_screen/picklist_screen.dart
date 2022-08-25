import 'package:flutter/material.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_footer.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_view.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class PicklistScreen extends StatelessWidget {
  static const routeName = '/picklist';

  PicklistScreen(this._picklist, {Key? key}) : super(key: key);

  final Picklist _picklist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        _picklist.uid,
      ),
      body: PicklistView(_picklist),
      bottomNavigationBar: _picklist.isPicked()
          ? PicklistFooter(_picklist)
          : SizedBox(height: 1),
    );
  }
}
