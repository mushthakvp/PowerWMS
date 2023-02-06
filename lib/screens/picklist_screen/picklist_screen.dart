import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/providers/complete_stockmutation_provider.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_body.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_footer.dart';
import 'package:scanner/screens/picklist_screen/widgets/picklist_view.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      completeStockMutationProvider =
          Provider.of<CompleteStockMutationProvider>(context, listen: false);
      completeStockMutationProvider.status = widget._picklist.status;
      prefs = await SharedPreferences.getInstance();
    });
    super.initState();
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
      bottomNavigationBar: Consumer<CompleteStockMutationProvider>(
        builder: (context, provider, _) {
          return provider.status == PicklistStatus.picked && widget._picklist.lines != 0
              ? PicklistFooter(widget._picklist, (isProcessSuccess, message,
                  picklist, stocksNeedToProcess) async {
                  if (isProcessSuccess) {
                    if (InternetState.shared.connectivityAvailable()) {
                      Future.delayed(const Duration(), () async {
                        bool isBackorderRemain(StockMutation line) {
                          final bKey =
                              '${line.lineId}_${line.items.first.productId}_backorder';
                          int? bAmount = prefs?.getInt(bKey);
                          return bAmount != null;
                        }

                        bool isCancelledRemain(StockMutation line) {
                          final cKey =
                              '${line.lineId}_${line.items.first.productId}';
                          int? cAmount = prefs?.getInt(cKey);
                          return cAmount != null;
                        }

                        Future<void> processCancelBackorder(
                            StockMutation item) async {
                          if (isBackorderRemain(item)) {
                            await context
                                .read<StockMutationRepository>()
                                .doBackorderRemain(item);
                          }
                          if (isCancelledRemain(item)) {
                            await context
                                .read<StockMutationRepository>()
                                .doCancelledRemain(item);
                          }
                        }

                        if (stocksNeedToProcess.isNotEmpty) {
                          await Future.forEach(
                              stocksNeedToProcess, processCancelBackorder);
                          await context
                              .read<PicklistRepository>()
                              .updatePicklistStatus(
                                  stocksNeedToProcess.first.picklistId,
                                  PicklistStatus.completed,
                                  false);
                        }
                        await showDialog(
                          context: context,
                          builder: (ctx) => successAlert(
                              ctx, message, picklist.uid, onPop: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 100), () async {
                              Navigator.of(ctx).pop();
                            });
                          }),
                        );
                      });
                    } else {
                      await showDialog(
                        context: context,
                        builder: (ctx) => successAlert(
                            ctx, message, picklist.uid, onPop: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 100), () async {
                            Navigator.of(ctx).pop();
                          });
                        }),
                      );
                    }
                  } else {
                    Future.delayed(const Duration(milliseconds: 300), () async {
                      await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text('An Error Occurred!'),
                                content: Text(message),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(AppLocalizations.of(context)!
                                        .ok
                                        .toUpperCase()),
                                    onPressed: () {
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        Navigator.of(ctx).pop();
                                      });
                                    },
                                  )
                                ],
                              ));
                    });
                  }
                  // Clear cache
                  Future<void> clearCache(int lineId) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('$lineId');
                  }

                  await Future.forEach(
                      stocksNeedToProcess.map((e) => e.lineId).toList(),
                      clearCache);
                })
              : SizedBox(height: 1);
        },
      ),
    );
  }

  AlertDialog successAlert(
      BuildContext context, String mgs, String picklistNumber,
      {required VoidCallback onPop}) {
    Widget qrWidget() {
      return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: QrImage(
              padding: EdgeInsets.zero,
              data: picklistNumber,
              version: QrVersions.auto));
    }

    return AlertDialog(
      title: Text(mgs),
      content: qrWidget(),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
            onPop();
          },
        )
      ],
    );
  }
}
