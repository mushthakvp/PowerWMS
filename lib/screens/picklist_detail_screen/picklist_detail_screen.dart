import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/providers/complete_stockmutation_provider.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/picklist_services.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/success_alert.dart';
import 'package:scanner/screens/picklist_detail_screen/widgets/picklist_footer.dart';
import 'package:scanner/screens/picklist_detail_screen/widgets/picklist_view.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistScreen extends StatefulWidget {
  static const routeName = '/picklist';

  PicklistScreen(this._picklist, {Key? key}) : super(key: key);

  final Picklist _picklist;

  @override
  State<PicklistScreen> createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistScreen>
    with PicklistStatusDelegate {
  late CompleteStockMutationProvider completeStockMutationProvider;
  SharedPreferences? prefs;

  Picklist get _picklist => widget._picklist;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initStateAsync());
  }

  Future _initStateAsync() async {
    completeStockMutationProvider =
        Provider.of<CompleteStockMutationProvider>(context, listen: false);
    completeStockMutationProvider.status = _picklist.status;
    prefs = await SharedPreferences.getInstance();
  }

  @override
  onUpdateStatus(PicklistStatus status) {
    if (status != completeStockMutationProvider.status) {
      Future.delayed(const Duration(), () {
        completeStockMutationProvider.status = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        widget._picklist.uid,
        leading: BackButton(),
        action: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsDialog.routeName);
          },
          icon: Icon(Icons.settings),
        ),
      ),
      body: PicklistView(widget._picklist, this),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<CompleteStockMutationProvider>(
      builder: (context, provider, _) {
        if (provider.status == PicklistStatus.picked && _picklist.lines != 0) {
          return _buildPicklistFooter(provider);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildPicklistFooter(CompleteStockMutationProvider provider) {
    return PicklistFooter(_picklist,
        (isProcessSuccess, message, picklist, stocksNeedToProcess) async {
      if (isProcessSuccess) {
        await _processSuccess(message, picklist, stocksNeedToProcess);
      } else {
        _showErrorDialog(message);
      }
      await _clearCache(stocksNeedToProcess.map((e) => e.lineId).toList());
    });
  }

  Future<void> _processSuccess(String message, Picklist picklist,
      List<StockMutation> stocksNeedToProcess) async {
    if (InternetState.shared.connectivityAvailable()) {
      await _processStocks(stocksNeedToProcess);
    }
    await _showSuccessDialog(message, picklist);
  }

  Future<void> _processStocks(List<StockMutation> stocksNeedToProcess) async {
    await Future.forEach(stocksNeedToProcess, (StockMutation item) async {
      if (_isBackorderRemain(item) || _isCancelledRemain(item)) {
        await context.read<StockMutationRepository>().doBackorderRemain(item);
      }
    });
    if (stocksNeedToProcess.isNotEmpty) {
      await context.read<PicklistRepository>().updatePicklistStatus(
            stocksNeedToProcess.first.picklistId,
            PicklistStatus.completed,
            false,
          );
    }
  }

  Future<void> _showSuccessDialog(String message, Picklist picklist) async {
    await showDialog(
      context: context,
      builder: (ctx) => successAlert(ctx,
          msg: message,
          countryCode: picklist.countryCode,
          internalMemo: picklist.internalMemo,
          picklistNumber: picklist.uid, onPop: () async {
        await Future.delayed(const Duration(milliseconds: 100), () async {
          Navigator.of(ctx).pop();
        });
      }),
    );
  }

  void _showErrorDialog(String message) {
    Future.delayed(const Duration(milliseconds: 300), () async {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
              onPressed: () {
                Future.delayed(const Duration(milliseconds: 100), () {
                  Navigator.of(ctx).pop();
                });
              },
            )
          ],
        ),
      );
    });
  }

  Future<void> _clearCache(List<int> lineIds) async {
    await Future.forEach(lineIds, (id) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$id');
    });
  }

  bool _isBackorderRemain(StockMutation line) {
    final bKey = '${line.lineId}_${line.items.first.productId}_backorder';
    int? bAmount = prefs?.getInt(bKey);
    return bAmount != null;
  }

  bool _isCancelledRemain(StockMutation line) {
    final cKey = '${line.lineId}_${line.items.first.productId}';
    int? cAmount = prefs?.getInt(cKey);
    return cAmount != null;
  }
}
