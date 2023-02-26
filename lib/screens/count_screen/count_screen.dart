// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:scanner/gen/assets.gen.dart';
// import 'package:scanner/l10n/app_localizations.dart';
// import 'package:scanner/models/product.dart';
// import 'package:scanner/screens/count_screen/home_provider.dart';
// import 'package:scanner/util/color_const.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tuple/tuple.dart';
//
// import '../../generated/l10n.dart';
//
// final formatCurrency = NumberFormat.simpleCurrency(
//   locale: Platform.localeName,
//   name: 'EUR',
//   decimalDigits: 2,
// );
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   HomeScreenState createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> with RouteAware {
//   Map<String, Tuple2<bool, Product?>> _products = {};
//
//   late HomeProvider _homeProvider;
//   bool? isContinuousScan = false;
//   bool? goodsReturn = false;
//
//   int get isReturnValue => (goodsReturn! ? -1 : 1);
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (!mounted) return;
//
//       _homeProvider = Provider.of<HomeProvider>(context, listen: false);
//       _homeProvider.getSavedSetting().then((value) {
//         isContinuousScan = value.isContinues;
//         goodsReturn = value.isReturn;
//       });
//       final searchedProducts = await _homeProvider.fetchSearchedProducts();
//       if (searchedProducts.isNotEmpty) {
//         setState(() {
//           for (var product in searchedProducts) {
//             if (product.ean?.length == 13) {
//               _products.putIfAbsent(
//                   ("0${product.ean}"), () => Tuple2(false, product));
//             } else {
//               _products.putIfAbsent(
//                   (product.ean ?? product.uid), () => Tuple2(false, product));
//             }
//           }
//         });
//       }
//       await _homeProvider.fetchProducts();
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Subscribe routeAware
//     // routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }
//
//   @override
//   void didPopNext() async {
//     await _homeProvider.fetchSettings();
//     super.didPopNext();
//   }
//
//   @override
//   void dispose() {
//     // Unsubscribe routeAware
//     // routeObserver.unsubscribe(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final intl = S.of(context);
//     final entryList = _products.entries.toList();
//     return GestureDetector(
//       onTap: () {
//         SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: AppColors.white,
//           title: SizedBox(
//             width: MediaQuery.of(context).size.width * 0.35,
//             child: Assets.images.logoBlue.image(),
//           ),
//           centerTitle: true,
//           // leading: IconButton(
//           //   onPressed: () {
//           //     if (!mounted) return;
//           //     Navigator.of(context).pushNamed(SettingScreen.routeName);
//           //   },
//           //   icon: const Icon(
//           //     Icons.settings,
//           //     color: AppColors.black87,
//           //   ),
//           // ),
//           actions: [
//             IconButton(
//               onPressed: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 await prefs.remove('token');
//                 await _homeProvider.clearProductCache();
//                 if (!mounted) return;
//                 Navigator.of(context).pushReplacementNamed('/');
//               },
//               icon: const Icon(
//                 Icons.exit_to_app,
//                 color: AppColors.black87,
//               ),
//             )
//           ],
//         ),
//         body: CustomScrollView(
//           slivers: [
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: BarcodeInput(
//                         onCameraPressed: () async {
//                           await _startParse(
//                             intl,
//                             isContinueScan: isContinuousScan!,
//                             isReturn: goodsReturn!,
//                           );
//                         },
//                         onBarCodeChanged: (String value) {},
//                         onParse: (String value) {
//                           _onSubmit(value);
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: _products.isNotEmpty
//                           ? () {
//                               setState(() {
//                                 _products = {};
//                               });
//                             }
//                           : null,
//                       icon: const Icon(Icons.delete),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SliverToBoxAdapter(
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: CheckboxListTile(
//                       value: isContinuousScan,
//                       onChanged: (value) {
//                         isContinuousScan = value;
//                         _homeProvider.saveContinueScannerAndReturn(
//                           isContinues: isContinuousScan!,
//                           isReturn: goodsReturn!,
//                         );
//                         setState(() {});
//                       },
//                       title: Text(
//                         "Continu scanner",
//                         style: Theme.of(context).textTheme.caption,
//                       ),
//                       visualDensity:
//                           const VisualDensity(horizontal: -4.0, vertical: -1),
//                       dense: true,
//                       checkboxShape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(4))),
//                       side: BorderSide(
//                         color: AppColors.grey,
//                         width: 2,
//                       ),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       contentPadding: const EdgeInsets.only(left: 6),
//                     ),
//                   ),
//                   Expanded(
//                     child: CheckboxListTile(
//                       value: goodsReturn,
//                       onChanged: (value) {
//                         goodsReturn = value;
//                         _homeProvider.saveContinueScannerAndReturn(
//                           isContinues: isContinuousScan!,
//                           isReturn: goodsReturn!,
//                         );
//                         setState(() {});
//                       },
//                       title: Text(
//                         "Retouren",
//                         style: Theme.of(context).textTheme.caption,
//                       ),
//                       visualDensity:
//                           const VisualDensity(horizontal: -4.0, vertical: -1),
//                       dense: true,
//                       checkboxShape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(4))),
//                       side: BorderSide(
//                         color: AppColors.grey,
//                         width: 2,
//                       ),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       contentPadding: const EdgeInsets.only(left: 6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (_, i) {
//                   final entry = entryList[i];
//                   final ean = entry.key;
//                   final tuple = entry.value;
//                   final loading = tuple.item1;
//                   final product = tuple.item2;
//                   final Widget child;
//                   if (loading) {
//                     child = ListTile(
//                       title: Text(ean),
//                       leading: const CircularProgressIndicator.adaptive(),
//                     );
//                   } else if (product == null) {
//                     child = ListTile(
//                       title: Text(ean),
//                       subtitle: Text(AppLocalizations.of(context)!.unavailable),
//                       leading: const AmountWidget(0),
//                     );
//                   } else {
//                     final String? status;
//                     switch (product.status) {
//                       case 2:
//                         status = AppLocalizations.of(context)!.statusDescending;
//                         break;
//                       case 3:
//                         status = AppLocalizations.of(context)!.statusDiscontinued;
//                         break;
//                       default:
//                         status = null;
//                     }
//                     child = ListTile(
//                       onTap: () async {
//                         await showProductAdjustmentPopup(
//                             context: context,
//                             product: product,
//                             onConfirmAmount: (num amount) async {
//                               product.stock = amount;
//                               await _homeProvider.updateProductMoq(
//                                 id: product.id,
//                                 moq: product.moq ?? 1,
//                                 quantity: amount,
//                               );
//                               setState(() {
//                                 _products.update(
//                                     ean, (_) => Tuple2(false, product));
//                               });
//                             });
//                       },
//                       title: Container(
//                         margin: const EdgeInsets.only(top: 8),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SizedBox(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   if (product.generalSalePriceIncluding !=
//                                       null) ...[
//                                     Container(
//                                       margin: const EdgeInsets.only(right: 10),
//                                       child: Text(
//                                         formatCurrency.format(
//                                             product.generalSalePriceIncluding),
//                                         style:
//                                             theme.textTheme.bodyText1?.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ]
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(product.description ?? '-',
//                                   style: theme.textTheme.titleMedium
//                                       ?.copyWith(fontWeight: FontWeight.bold)),
//                             ),
//                           ],
//                         ),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 8),
//                           Text('${product.uid} | ${product.unit}',
//                               style: const TextStyle(color: AppColors.black)),
//                           const SizedBox(height: 8),
//                           if (status != null) ...[
//                             Text(status),
//                             const SizedBox(height: 8),
//                           ],
//                           Text('${product.ean}',
//                               style: const TextStyle(color: AppColors.black)),
//                         ],
//                       ),
//                       leading: AmountWidget(product.stock?.toInt() ?? 1),
//                     );
//                   }
//                   return Dismissible(
//                     key: Key(ean),
//                     onDismissed: (_) async {
//                       await _homeProvider.clearProduct(id: product!.id);
//                       setState(() {
//                         _products.remove(ean);
//                       });
//                     },
//                     background: Container(
//                       color: AppColors.primary,
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.all(16),
//                       child: const Icon(
//                         Icons.delete,
//                         color: AppColors.white,
//                       ),
//                     ),
//                     child: Column(
//                       children: [
//                         child,
//                         const Divider(),
//                       ],
//                     ),
//                   );
//                 },
//                 childCount: _products.length,
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: SafeArea(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             child: ElevatedButton(
//               onPressed: context.watch<HomeProvider>().setting == null
//                   ? null
//                   : () async {
//                       await showOrderPopup(
//                           context: context, onSubmitOrder: _orderProduct);
//                     },
//               child: const Text('ORDER', style: TextStyle(fontSize: 16)),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _onSubmit(String barcodeStr) async {
//     String barcode = barcodeStr;
//     if (barcode.length == 13) {
//       barcode = '0$barcode';
//     }
//     if (_products.containsKey(barcode)) {
//       final products = await _homeProvider.searchProducts(barcodeStr);
//       final product = products.first;
//       if (goodsReturn!) {
//         product.moq = (product.moq ?? 1) * -1;
//       }
//       final moq =
//           ((_products[barcode]!.item2!.stock ?? 1) + (product.moq ?? 1));
//       final currentProduct =
//           _products[barcode]!.item2?.copyWith(moq: product.moq, stock: moq);
//       if (moq < 1000 && moq > -999) {
//         await _homeProvider.updateProductMoq(
//           id: product.id,
//           moq: product.moq ?? 1,
//           quantity: moq,
//         );
//         setState(() {
//           _products.update(barcode, (_) => Tuple2(false, currentProduct));
//         });
//       }
//       return;
//     } else {
//       setState(() {
//         _products.putIfAbsent(barcode, () => const Tuple2(true, null));
//       });
//     }
//
//     final messenger = ScaffoldMessenger.of(context);
//     try {
//       final list = await _homeProvider.searchProducts(barcodeStr);
//       Product? product;
//       if (list.isEmpty) {
//         if (!mounted) return;
//         product = null;
//         // final snackBar = SnackBar(content: Text(S.of(context).productNotFound));
//         // messenger.showSnackBar(snackBar);
//         throw S.of(context).productNotFound;
//       } else {
//         product = list.first;
//         product = product.copyWith(
//             stock: (list.first.moq ?? 1) * (goodsReturn! ? -1 : 1));
//       }
//       setState(() {
//         _products.update(barcode, (_) => Tuple2(false, product));
//       });
//       final p = _products.values
//           .where((e) => e.item2 != null)
//           .map((e) => e.item2!)
//           .toList();
//       await _homeProvider.saveSearchedProducts(products: p);
//     } catch (e) {
//       final snackBar = SnackBar(content: Text(e.toString()));
//       messenger.showSnackBar(snackBar);
//       setState(() {
//         _products.remove(barcode);
//       });
//       rethrow;
//     }
//   }
//
//   _orderProduct(String orderTypeCode, String customerCode) async {
//     final List<OrderLine> lines = [];
//     _products.values.toList().map((e) => e.item2).toList().forEach((product) {
//       if (product != null) {
//         lines.add(OrderLine(
//             unitCode: product.unit,
//             qtyOrdered: product.moq?.toInt() ?? 0,
//             productIdentifier: ProductIdentifier(productCode: product.uid)));
//       }
//     });
//     var orderRequest = OrderRequest(
//         orderTypeCode: orderTypeCode,
//         customerCode: customerCode,
//         lastChangedByUser: _homeProvider.setting!.userName,
//         lines: lines,
//         propertiesToInclude: '*');
//     if (lines.isNotEmpty) {
//       final response = await _homeProvider.orderProduct(request: orderRequest);
//
//       if (response.item2 != null) {
//         await showErrorPopup(message: response.item2!);
//       } else {
//         await showOrderSuccessPopup();
//         await _homeProvider.clearSearchedProducts();
//         setState(
//           () {
//             _products.clear();
//           },
//         );
//       }
//     }
//     if (kDebugMode) {
//       print('===== orderRequest ${orderRequest.toJson()}');
//     }
//   }
//
//   Future<void> _startParse(S intl,
//       {required bool isContinueScan, required bool isReturn}) async {
//     String barcode;
//     final Map<String, Tuple2<bool, Product?>> listOfProducts =
//         await Navigator.of(context).push(MaterialPageRoute(
//             builder: (context) => ScanCustomCard(
//                   pointAmount: 100,
//                   isReturn: isReturn,
//                   isContinueScan: isContinueScan,
//                   oldProducts: _products,
//                 )));
//     if (listOfProducts.isNotEmpty) {
//       _products.clear();
//       _products.addAll(listOfProducts);
//     }
//     // FlutterBarcodeScanner.getBarcodeStreamReceiver(
//     //   "#ff6666",
//     //   intl.complete,
//     //   true,
//     //   ScanMode.DEFAULT,
//     // )?.listen((event) {
//     //   if (event != '-1') {
//     //     try {
//     //       _onSubmit(event.toString());
//     //       if (!mounted) return;
//     //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//     //         content: Text("Success"),
//     //       ));
//     //       // await Navigator.of(context)
//     //       //     .push(MaterialPageRoute(builder: (context) {
//     //       //   Future.delayed(
//     //       //     const Duration(seconds: 2),
//     //       //     () => Navigator.of(context).pop(),
//     //       //   );
//     //       //   return const SuccessScreen();
//     //       // }));
//     //     } catch (e) {
//     //       // ignore: avoid_print
//     //       print('ERROR: $e');
//     //     }
//     //   }
//     // });
//     // if (!isContinuousScan!) {
//     //   barcode = "-1";
//     // }
//   }
// }
//
// class SuccessScreen extends StatelessWidget {
//   const SuccessScreen({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.green,
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.close),
//         ),
//         elevation: 0,
//         backgroundColor: AppColors.green,
//       ),
//       body: const Center(
//         child: Icon(
//           Icons.check,
//           size: 200,
//         ),
//       ),
//     );
//   }
// }
