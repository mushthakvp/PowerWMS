import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/base_response.dart';
import 'package:scanner/models/cancelled_stock_mutation_item.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/providers/process_product_provider.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:scanner/repository/stock_mutation_item_repository.dart';
import 'package:scanner/repository/stock_mutation_repository.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/line_info.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/product_view.dart';
import 'package:scanner/screens/picklist_product_screen/widgets/reserved_list.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:scanner/util/widget/popup.dart';
import 'package:scanner/widgets/dialogs/custom_snack_bar.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class PicklistProductScreen extends StatefulWidget {
  const PicklistProductScreen(this.line, {Key? key, this.totalStock})
      : super(key: key);

  static const routeName = '/picklist-product';
  final PicklistLine line;
  final double? totalStock;

  @override
  State<PicklistProductScreen> createState() => _PicklistProductScreenState();
}

class _PicklistProductScreenState extends State<PicklistProductScreen> {
  late PicklistLine newLine;

  @override
  void initState() {
    super.initState();
    newLine = widget.line;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        newLine.lineLocationCode ?? '',
        leading: BackButton(),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  FutureBuilder<List<CancelledStockMutationItem>> _buildBody() {
    return FutureBuilder<List<CancelledStockMutationItem>>(
      future: context
          .read<StockMutationItemRepository>()
          .getCancelledStockMutationItems(newLine.product.id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          log(snapshot.error, snapshot.stackTrace);
          return _buildErrorText(snapshot.error, snapshot.stackTrace!);
        }
        if (snapshot.hasData) {
          printV(snapshot.data);
          return _buildCustomScrollView(snapshot.data);
        }
        return _buildSomethingWrongText();
      },
    );
  }

  Widget _buildErrorText(dynamic error, StackTrace stackTrace) {
    return Container(
      child: Text('$error\n$stackTrace'),
    );
  }

  Widget _buildSomethingWrongText() {
    return Container(
      child: Text('Something is wrong.'),
    );
  }

  CustomScrollView _buildCustomScrollView(
      List<CancelledStockMutationItem>? data) {
    return CustomScrollView(
      slivers: <Widget>[
        LineInfo(newLine),
        ProductView(
          newLine,
          data ?? [],
          totalStock: widget.totalStock,
        ),
        ReservedList(newLine, data ?? [], (PicklistLine line) {
          setState(() {
            newLine = line;
          });
        }),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<ProcessProductProvider>(
      builder: (context, provider, _) {
        bool isProcessable = provider.getCanProcess &&
            InternetState.shared.connectivityAvailable();
        return ListTile(
          visualDensity: VisualDensity.compact,
          title: ElevatedButton(
              child: Text(
                  AppLocalizations.of(context)!.productProcess.toUpperCase()),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    isProcessable ? Colors.blue : Colors.grey),
              ),
              onPressed: isProcessable
                  ? () async {
                      if (provider.mutationProvider != null &&
                          InternetState.shared.connectivityAvailable()) {
                        context.read<ProcessProductProvider>().canProcess =
                            false;
                        await _onProcessHandler(
                            provider.mutationProvider!, context);
                        context
                            .read<StockMutationNeedToProcessProvider>()
                            .changePendingMutation(isPending: false);
                      } else {
                        CustomSnackBar.showSnackBar(context,
                            title: "No Internet");
                      }
                    }
                  : null),
        );
      },
    );
  }

  Future<void> _onProcessHandler(
      MutationProvider provider, BuildContext context) async {
    await context
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
}

//
// class PicklistProductScreen extends StatefulWidget {
//   const PicklistProductScreen(this.line, {Key? key, this.totalStock})
//       : super(key: key);
//
//   static const routeName = '/picklist-product';
//   final PicklistLine line;
//   final double? totalStock;
//
//   @override
//   State<PicklistProductScreen> createState() => _PicklistProductScreenState();
// }
//
// class _PicklistProductScreenState extends State<PicklistProductScreen> {
//   late PicklistLine newLine;
//
//   @override
//   void initState() {
//     newLine = widget.line;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: WMSAppBar(
//         newLine.lineLocationCode ?? '',
//         leading: BackButton(),
//       ),
//       body: FutureBuilder<List<CancelledStockMutationItem>>(
//         future: context
//             .read<StockMutationItemRepository>()
//             .getCancelledStockMutationItems(newLine.product.id),
//         builder: (_, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             log(snapshot.error, snapshot.stackTrace);
//             return Container(
//               child: Text('${snapshot.error}\n${snapshot.stackTrace}'),
//             );
//           }
//           if (snapshot.hasData) {
//             return CustomScrollView(
//               slivers: <Widget>[
//                 LineInfo(newLine),
//                 ProductView(
//                   newLine,
//                   snapshot.data ?? [],
//                   totalStock: widget.totalStock,
//                 ),
//                 ReservedList(newLine, snapshot.data ?? [], (PicklistLine line) {
//                   setState(() {
//                     newLine = line;
//                   });
//                 }),
//               ],
//             );
//           }
//           return Container(
//             child: Text('Something is wrong.'),
//           );
//         },
//       ),
//       bottomNavigationBar: Consumer<ProcessProductProvider>(
//         builder: (context, provider, _) {
//           bool isProcessable = provider.getCanProcess &&
//               InternetState.shared.connectivityAvailable();
//           return ListTile(
//             visualDensity: VisualDensity.compact,
//             title: ElevatedButton(
//                 child: Text(
//                     AppLocalizations.of(context)!.productProcess.toUpperCase()),
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       isProcessable ? Colors.blue : Colors.grey),
//                 ),
//                 onPressed: isProcessable
//                     ? () async {
//                   if (provider.mutationProvider != null &&
//                       InternetState.shared.connectivityAvailable()) {
//                     context.read<ProcessProductProvider>().canProcess =
//                     (false);
//                     await _onProcessHandler(
//                       provider.mutationProvider!,
//                       context,
//                     );
//                     print("Picklist_product_screen 105 ********");
//                     context
//                         .read<StockMutationNeedToProcessProvider>()
//                         .changePendingMutation(isPending: false);
//                   } else {
//                     CustomSnackBar.showSnackBar(
//                       context,
//                       title: "No Internet",
//                     );
//                   }
//                 }
//                     : null),
//           );
//         },
//       ),
//     );
//   }
//
//   _onProcessHandler(MutationProvider provider, BuildContext context) async {
//     await context
//         .read<StockMutationRepository>()
//         .saveMutation(provider.getStockMutation())
//         .then((value) {
//       if (value.success) {
//         provider.clear();
//         Navigator.of(context).pop();
//       } else {
//         Future.delayed(const Duration(), () async {
//           await showErrorAlert(message: value.message);
//         });
//       }
//     }, onError: (error) {
//       var response = error as BaseResponse;
//       Future.delayed(const Duration(), () async {
//         await showErrorAlert(message: response.message);
//       });
//     });
//   }
// }
