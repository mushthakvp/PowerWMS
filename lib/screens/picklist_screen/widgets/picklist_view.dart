import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_body.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistView extends StatefulWidget {
  const PicklistView(this.picklist, {Key? key}) : super(key: key);

  final Picklist picklist;

  @override
  _PicklistViewState createState() => _PicklistViewState();
}

class _PicklistViewState extends State<PicklistView> {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final picklist = widget.picklist;
    final repository = context.read<PicklistLineRepository>();
    return StreamBuilder<List<PicklistLine>>(
      stream: _refreshController.isRefresh
          ? null
          : repository.getPicklistLinesStream(picklist.id),
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
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            header: MaterialClassicHeader(),
            onRefresh: () async {
              await repository.clear(picklistId: picklist.id);
              _refreshController.refreshCompleted();
              setState(() {});
            },
            child: CustomScrollView(
              slivers: [
                PicklistHeader(picklist),
                PicklistBody(snapshot.data!),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
