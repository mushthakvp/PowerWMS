import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_body.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_header.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PicklistView extends StatefulWidget {
  const PicklistView(this.picklist, this.delegate, {Key? key}) : super(key: key);

  final Picklist picklist;
  final PicklistStatusDelegate delegate;

  @override
  _PicklistViewState createState() => _PicklistViewState();
}

class _PicklistViewState extends State<PicklistView> with PicklistStatusDelegate {
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  onUpdateStatus(PicklistStatus status) {
    widget.delegate.onUpdateStatus(status);
  }

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
          if (snapshot.error is NoConnection) {
            return errorWidget(mgs: AppLocalizations.of(context)!.load_picklist_error);
          } else if (snapshot.error is Failure) {
            return errorWidget(mgs: (snapshot.error as Failure).message);
          } else {
            return Container(
              child: Text('Something is wrong.'),
            );
          }
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
            child: ListView(
              children: [
                PicklistHeader(picklist),
                PicklistBody(snapshot.data!, this),
              ],
            ),
          );
        }
        return Container(
          child: Text('Something is wrong.'),
        );
      },
    );
  }

  Widget errorWidget({required String mgs}) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Text(mgs),
    );
  }
}