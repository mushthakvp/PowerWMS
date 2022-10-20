import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/add_product_provider.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/providers/process_product_provider.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/product_adjustment.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/scan_form.dart';
import 'package:scanner/util/widget/popup.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductView extends StatelessWidget {
  const ProductView(this.line, this.cancelledItems, {Key? key})
      : super(key: key);

  final PicklistLine line;
  final List<CancelledStockMutationItem> cancelledItems;

  @override
  Widget build(BuildContext context) {
    var mutationRepository = context.read<StockMutationRepository>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddProductProvider>(
            create: (_) => AddProductProvider()
        ),
        StreamProvider<Map<int, StockMutation>?>(
          create: (_) =>
              mutationRepository.getStockMutationsStream(line.picklistId),
          initialData: null,
          catchError: (_, err) {
            log(err, null);
            return null;
          },
        ),
        FutureProvider<List<StockMutationItem>?>(
          create: (_) async {
            final prefs = await SharedPreferences.getInstance();
            final json = prefs.getString('${line.id}');
            if (json != null) {
              return (jsonDecode(json) as List<dynamic>)
                  .map((json) => StockMutationItem.fromJson(json))
                  .toList();
            } else {
              return [];
            }
          },
          initialData: null,
          catchError: (_, err) {
            log(err, null);
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
              line,
              idleItems,
              cancelledItems,
              queuedMutations.values.toList(),
            );
          },
        ),
      ],
      child: Consumer<MutationProvider?>(
        builder: (context, provider, _) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (provider != null) {
              context.read<ProcessProductProvider>()
                  .canProcess = provider.idleItems.length > 0;
              context.read<ProcessProductProvider>()
                  .mutationProvider = provider;
            }
          });
          if (provider == null) {
            return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return SliverList(
            delegate: SliverChildListDelegate([
              ListTile(
                title: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${AppLocalizations.of(context)!.productProductNumber}:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(line.product.uid),
                        SizedBox(height: 8),
                        const Text(
                          'GTIN / EAN:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(line.product.ean ?? ''),
                        if (line.batchSuggestion != null && line.batchSuggestion!.isNotEmpty) ...[
                          SizedBox(height: 8),
                          const Text(
                            'Batch',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(line.batchSuggestion!),
                        ]
                      ],
                    ),
                    Spacer(),
                    ProductImage(line.product.id, width: 120),
                  ],
                ),
              ),
              Divider(height: 1),
              _pickTile(provider, context),
              SizedBox(height: 8),
              Divider(height: 1),
              /// Cancel rest product amount
              _cancelProductAmount(provider, context),
              /// Barcode
              ScanForm(
                (process) {
                  if (process) {
                    _onProcessHandler(provider, context);
                  }
                },
              ),
              SizedBox(height: 8),
              Divider(height: 1),
              ..._itemsBuilder(provider, context),
            ]),
          );
        },
      ),
    );
  }

  _pickTile(MutationProvider provider, BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Amount to asked
              Text(
                AppLocalizations.of(context)!
                    .productAmountAsked(provider.line.product.unit),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '${provider.askedAmount}',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black54,
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!
                    .productAmountBoxes(provider.askedPackagingAmount)
                    .toUpperCase(),
              ),
            ],
          ),
          Spacer(),
          /// Amount to pick
          InkWell(
            onTap: () {
              if (provider.shallAllowScan) {
                showProductAdjustmentPopup(
                    context: context,
                    mutationProvider: provider,
                    onConfirmAmount: (int amount, bool isCancel) {
                      provider.changeAmount(amount, isCancel);
                      // handle local storage
                      provider.handleProductCancelAmount(
                          isCancel ? CacheProductStatus.set : CacheProductStatus.remove
                      );
                    });
              } else {
                final snackBar = SnackBar(
                  content: Text(AppLocalizations.of(context)!.productCannotScan),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!
                      .productAmountToPick(provider.line.product.unit),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '${provider.showToPickAmount}',
                    style: TextStyle(
                      fontSize: 50,
                      color:
                          provider.toPickAmount < 0 ? Colors.red : Colors.black54,
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!
                      .productAmountBoxes(provider.toPickPackagingAmount)
                      .toUpperCase(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _cancelProductAmount(MutationProvider provider, BuildContext context) {
    return provider.showCancelRestProductAmount ? Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          alignment: Alignment.center,
          child: Text('${provider.cancelRestProductAmount} ${AppLocalizations.of(context)!.productWillBeCancel.toUpperCase()}',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 24.0
              )
          ),
        ),
        SizedBox(height: 4),
        Divider(height: 1),
      ],
    ) : SizedBox();
  }

  _onProcessHandler(MutationProvider provider, BuildContext context) {
    context
        .read<StockMutationRepository>()
        .saveMutation(provider.getStockMutation())
        .then((value) {
      if (value.success) {
        provider.clear();
        Navigator.of(context).pop();
      } else {
        Future.delayed(const Duration(), () async {
          await showErrorAlert(message: value.message);
        });
      }
    }, onError: (error) {
      var response = error as BaseResponse;
      Future.delayed(const Duration(), () async {
        await showErrorAlert(message: response.message);
      });
    });
  }

  _itemsBuilder(MutationProvider mutation, BuildContext context) {
    return mutation.idleItems.map((item) {
      var expirationDate = item.expirationDate != null ? '| ${item.expirationDate!}' : '';
      return Dismissible(
        key: item.stickerCode == null ? UniqueKey() : Key(item.stickerCode!),
        onDismissed: (direction) {
          mutation.removeItem(item);
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '${mutation.askedAmount < 0 && item.amount > 0 ? '-' : ''}${item.amount} x ${item.batch} | ${item.stickerCode} $expirationDate',
              ),
            ),
            Divider(height: 1),
          ],
        ),
      );
    });
  }
}
