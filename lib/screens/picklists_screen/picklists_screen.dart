import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/screens/picklists_screen/widgets/picklist_view.dart';
import 'package:scanner/screens/picklists_screen/widgets/search_field.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class PicklistsScreen extends StatefulWidget {
  const PicklistsScreen({Key? key}) : super(key: key);

  @override
  _PicklistScreenState createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistsScreen> {
  final _refreshController = RefreshController(initialRefresh: false);
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final repository = context.read<PicklistRepository>();
    final lineRepository = context.read<PicklistLineRepository>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: WMSAppBar(
          'Extracom',
          preferredSize: kToolbarHeight + 100,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!
                          .picklistsOpen
                          .toUpperCase(),
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!
                          .picklistsRevise
                          .toUpperCase(),
                    ),
                  ],
                ),
                SearchField(_search, (value) {
                  setState(() {
                    _search = value;
                  });
                }),
              ],
            ),
          ),
        ),
        body: StreamBuilder<List<Picklist>>(
          stream: repository.getPicklistsStream(_search),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final notPicked = snapshot.data!
                  .where((element) => element.isNotPicked())
                  .toList();
              final picked = snapshot.data!
                  .where((element) => element.isPicked())
                  .toList();
              if (notPicked.length == 1) {
                Future.microtask(() {
                  setState(() {
                    _search = '';
                  });
                  Navigator.pushNamed(context, '/picklist',
                      arguments: notPicked.first);
                });
              }
              return TabBarView(
                children: [
                  PicklistView(
                    notPicked,
                    _refreshController,
                    () async {
                      await Future.wait([
                        repository.clear(),
                        lineRepository.clear(),
                      ]);
                      _refreshController.refreshCompleted();
                      setState(() {});
                    },
                  ),
                  PicklistView(
                    picked,
                    _refreshController,
                    () async {
                      await Future.wait([
                        repository.clear(),
                        lineRepository.clear(),
                      ]);
                      _refreshController.refreshCompleted();
                      setState(() {});
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
