import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/providers/complete_picklist_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/util/widget/popup.dart';

class PicklistFooter extends StatefulWidget {
  const PicklistFooter(this.picklist, this.onCompleted, {Key? key})
      : super(key: key);

  final Picklist picklist;
  final Function(bool, String, Picklist, List<StockMutation>) onCompleted;

  @override
  State<PicklistFooter> createState() => _PicklistFooterState();
}

class _PicklistFooterState extends State<PicklistFooter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletePicklistProvider>(
      builder: (context, provider, _) {
        return ListTile(
          visualDensity: VisualDensity.compact,
          title: ElevatedButton(
              child: Text(AppLocalizations.of(context)!.complete.toUpperCase()),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                Future<void> doComplete(
                    List<StockMutation> stocksNeedToProcess) async {
                  var response =
                      await provider.completePicklist(widget.picklist.id);
                  if (response?.success == true) {
                    widget.onCompleted(true, response?.message ?? '',
                        widget.picklist, stocksNeedToProcess);
                  } else {
                    widget.onCompleted(false, response?.message ?? '',
                        widget.picklist, stocksNeedToProcess);
                  }
                }

                var stocksNeedToProcess =
                    context.read<StockMutationNeedToProcessProvider>().stocks;
                if (stocksNeedToProcess.isNotEmpty) {
                  await Future.forEach(stocksNeedToProcess,
                      context.read<StockMutationRepository>().saveMutation).catchError((error) {
                        var response = error as BaseResponse;
                        Future.delayed(const Duration(), () async {
                          await showErrorAlert(message: response.message);
                        });
                  }).then((value) => {
                    doComplete(stocksNeedToProcess)
                  });
                } else {
                  await doComplete(stocksNeedToProcess);
                }
              }),
        );
      },
    );
  }
}
