import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/add_product_provider.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/repository/picklist_line_repository.dart';
import 'package:scanner/repository/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/picklist_services.dart';
import 'package:scanner/screens/picklist_detail_screen/widgets/picklist_body.dart';
import 'package:scanner/screens/picklist_detail_screen/widgets/picklist_header.dart';
import 'package:scanner/widgets/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistView extends StatefulWidget {
  final Picklist picklist;
  final PicklistStatusDelegate delegate;

  const PicklistView({
    Key? key,
    required this.picklist,
    required this.delegate,
  }) : super(key: key);

  @override
  _PicklistViewState createState() => _PicklistViewState();
}

class _PicklistViewState extends State<PicklistView>
    with PicklistStatusDelegate {
  final _refreshController = RefreshController(initialRefresh: false);
  late Future<List<PicklistLine>> _picklistLinesFuture;

  @override
  void initState() {
    _fetchPicklistLines();
    super.initState();
  }

  void _fetchPicklistLines() {
    final repository = context.read<PicklistLineRepository>();
    _picklistLinesFuture = repository.getPicklistLines(widget.picklist.id);
  }

  @override
  onUpdateStatus(PicklistStatus status) {
    widget.delegate.onUpdateStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PicklistLine>>(
      future: _picklistLinesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        } else if (snapshot.hasError) {
          return _buildError(snapshot.error, context);
        } else if (snapshot.hasData) {
          return _buildDataView(snapshot.data!, context);
        } else {
          return _buildUnknownError();
        }
      },
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());

  Widget _buildError(error, BuildContext context) {
    if (error is NoConnection) {
      return CustomErrorWidget(
        message: AppLocalizations.of(context)!.load_picklist_error,
      );
    } else if (error is Failure) {
      return CustomErrorWidget(message: (error).message);
    } else {
      return _buildUnknownError();
    }
  }

  Widget _buildDataView(List<PicklistLine> data, BuildContext context) {
    final repository = context.read<PicklistLineRepository>();
    var mutationRepository = context.read<StockMutationRepository>();

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      header: MaterialClassicHeader(),
      onRefresh: () async {
        await repository.clear(picklistId: widget.picklist.id);
        _refreshController.refreshCompleted();
        setState(() {});
      },
      child: ListView(
        children: [
          PicklistHeader(widget.picklist),
          MultiProvider(
            providers: [
              ChangeNotifierProvider<AddProductProvider>(
                create: (_) => AddProductProvider(),
              ),
              ChangeNotifierProvider<MutationProvider>(
                create: (_) => MutationProvider.create(data.first, [], [], []),
              ),
              StreamProvider<Map<int, StockMutation>?>(
                create: (_) => mutationRepository
                    .getStockMutationsStream(data.first.picklistId),
                initialData: null,
                catchError: (_, err) {
                  return null;
                },
              ),
              FutureProvider<List<StockMutationItem>?>(
                create: (_) async {
                  final prefs = await SharedPreferences.getInstance();
                  final json = prefs.getString('${data.first.id}');
                  if (json != null) {
                    final res = (jsonDecode(json) as List<dynamic>)
                        .map((json) => StockMutationItem.fromJson(json))
                        .toList();
                    return res;
                  } else {
                    return [];
                  }
                },
                initialData: null,
                catchError: (_, err) {
                  return null;
                },
              ),
              ListenableProxyProvider2<List<StockMutationItem>?,
                  Map<int, StockMutation>?, MutationProvider?>(
                update: (context, idleItems, queuedMutations, _) {
                  if (idleItems == null || queuedMutations == null) {
                    return null;
                  }
                  return MutationProvider.create(
                    data.first,
                    idleItems,
                    [],
                    queuedMutations.values.toList(),
                  );
                },
              ),
            ],
            child: PicklistBody(data, this),
          )
        ],
      ),
    );
  }

  Widget _buildUnknownError() => Container(child: Text('Something is wrong.'));
}
