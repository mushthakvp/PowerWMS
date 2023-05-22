import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/providers/complete_picklist_provider.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:scanner/repository/stock_mutation_repository.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:scanner/util/widget/popup.dart';
import 'package:scanner/widgets/dialogs/custom_snack_bar.dart';

class PicklistFooter extends StatefulWidget {
  const PicklistFooter(this.picklist, this.onCompleted, {Key? key})
      : super(key: key);

  final Picklist picklist;
  final Function(bool, String, Picklist, List<StockMutation>) onCompleted;

  @override
  State<PicklistFooter> createState() => _PicklistFooterState();
}

class _PicklistFooterState extends State<PicklistFooter> {
  bool isProcessing = false;
  bool isPendingMutation = true;

  @override
  Widget build(BuildContext context) {
    return Consumer2<CompletePicklistProvider,
        StockMutationNeedToProcessProvider>(
      builder: (context, provider, stockProvider, _) {
        stockProvider.addListener(() {
          isPendingMutation = stockProvider.isPendingMutation;
        });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ElevatedButton(
              child: isProcessing
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ))
                  : Text(AppLocalizations.of(context)!.complete.toUpperCase()),
              onPressed: isProcessing
                  ? null
                  : () async {
                      print(isPendingMutation);
                      if (!isPendingMutation) {
                        setState(() {
                          isProcessing = true;
                        });

                        Future<void> doComplete(
                            List<StockMutation> stocksNeedToProcess) async {
                          var response = await provider
                              .completePicklist(widget.picklist.id);
                          if (response?.success == true) {
                            widget.onCompleted(true, response?.message ?? '',
                                widget.picklist, stocksNeedToProcess);
                          } else {
                            widget.onCompleted(false, response?.message ?? '',
                                widget.picklist, stocksNeedToProcess);
                          }
                          Future.delayed(const Duration(seconds: 2), () {
                            if (!mounted) return;
                            setState(() {
                              isProcessing = false;
                            });
                          });
                        }

                        var stocksNeedToProcess = context
                            .read<StockMutationNeedToProcessProvider>()
                            .stocks;

                        if (InternetState.shared.connectivityAvailable()) {
                          if (stocksNeedToProcess.isNotEmpty) {
                            await Future.forEach(
                                    stocksNeedToProcess,
                                    context
                                        .read<StockMutationRepository>()
                                        .saveMutation)
                                .catchError((error) {
                              var response = error as BaseResponse;
                              Future.delayed(const Duration(), () async {
                                await showErrorAlert(message: response.message);
                              });
                            }).then((value) =>
                                    {doComplete(stocksNeedToProcess)});
                          } else {
                            await doComplete(stocksNeedToProcess);
                          }
                        } else {
                          if (stocksNeedToProcess.isNotEmpty) {
                            Future.delayed(const Duration(), () async {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .cannotProcessed),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .ok
                                                    .toUpperCase()),
                                            onPressed: () {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 100), () {
                                                setState(() {
                                                  isProcessing = false;
                                                });
                                                Navigator.of(ctx).pop();
                                              });
                                            },
                                          )
                                        ],
                                      ));
                            });
                          } else {
                            widget.onCompleted(
                                true, '', widget.picklist, stocksNeedToProcess);
                            Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                if (!mounted) return;
                                setState(
                                  () {
                                    isProcessing = false;
                                  },
                                );
                              },
                            );
                          }
                        }
                      } else {
                        CustomSnackBar.showSnackBar(context,
                            title: "Pending Mutation");
                      }
                    }),
        );
      },
    );
  }
}
