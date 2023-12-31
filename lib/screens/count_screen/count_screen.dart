import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/screens/count_screen/home_provider.dart';
import 'package:scanner/screens/count_screen/model/CountListModel.dart';
import 'package:scanner/screens/count_screen/model/order/order_request.dart';
import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:scanner/screens/count_screen/resource/product_api_provider.dart';
import 'package:scanner/screens/count_screen/widgets/amount_widget.dart';
import 'package:scanner/screens/count_screen/widgets/product_adjusment_widget.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/custom_button.dart';
import 'package:tuple/tuple.dart';

final routeObserver = RouteObserver<ModalRoute<void>>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final formatCurrency = NumberFormat.simpleCurrency(
  locale: Platform.localeName,
  name: 'EUR',
  decimalDigits: 2,
);

class CountHomeScreen extends StatefulWidget {
  const CountHomeScreen({Key? key}) : super(key: key);

  static const routeName = '/countHome';

  @override
  CountHomeScreenState createState() => CountHomeScreenState();
}

class CountHomeScreenState extends State<CountHomeScreen> with RouteAware {
  LinkedHashMap<String, Tuple2<bool, Product?>> _products =
      LinkedHashMap<String, Tuple2<bool, Product?>>();

  ProductApiProvider productApiProvider = ProductApiProvider();

  late HomeProvider _homeProvider;
  bool? isContinuousScan = false;
  bool? goodsReturn = false;
  CountListModel? countListModel;
  Future<List<CountListModel>?>? countListFuture;

  int get isReturnValue => (goodsReturn! ? -1 : 1);

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    countListFuture = productApiProvider.getOrderCount();
    countListFuture?.then((value) {
      countListModel = value!.first;
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      _homeProvider = Provider.of<HomeProvider>(context, listen: false);
      // _homeProvider.getSavedSetting().then((value) {
      //   isContinuousScan = value.isContinues;
      //   goodsReturn = value.isReturn;
      // });
      final searchedProducts = await _homeProvider.fetchSearchedProducts();
      if (searchedProducts.isNotEmpty) {
        setState(() {
          for (var product in searchedProducts) {
            if (product.ean?.length == 13) {
              _products.putIfAbsent(
                  ("0${product.ean}"), () => Tuple2(false, product));
              print("_products.keys");
              print(_products.keys);
            } else {
              _products.putIfAbsent(
                  (product.ean ?? product.uid), () => Tuple2(false, product));
              print("_products.keys 2");
              print(_products.keys);
            }
          }
        });
      }
      await _homeProvider.fetchProducts();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe routeAware
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() async {
    await _homeProvider.fetchSettings();
    super.didPopNext();
  }

  @override
  void dispose() {
    // Unsubscribe routeAware
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entryList = _products.entries.toList();
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.count),
          backgroundColor: AppColors.white,
          centerTitle: true,
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: FutureBuilder<List<CountListModel>?>(
                  future: countListFuture,
                  builder:
                      (context, AsyncSnapshot<List<CountListModel>?> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      // Navigator.pop(context);
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 16, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.primary.withOpacity(0.2),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButton<CountListModel>(
                                value: countListModel ?? snapshot.data?.first,
                                isExpanded: true,
                                underline: SizedBox(),
                                items: snapshot.data
                                    ?.map(
                                      (e) => DropdownMenuItem<CountListModel>(
                                        child: Text(
                                            "${e.reference} | ${e.plannedDate}"),
                                        onTap: () {
                                          countListModel = e;
                                          setState(() {});
                                        },
                                        value: e,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  _focusNode.requestFocus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                countListModel?.warehouse ?? "",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  }),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 4, left: 20, right: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: BarcodeInput(
                        // onCameraPressed: () async {
                        //   await _startParse(
                        //     intl,
                        //     isContinueScan: isContinuousScan!,
                        //     isReturn: goodsReturn!,
                        //   );
                        // },
                        focusNodeArg: _focusNode,
                        keyBoardType: TextInputType.text,
                        onBarCodeChanged: (String value) {},
                        onParse: (String value, __) {
                          _onSubmit(value);
                        },
                        willShowKeyboardButton: false,
                      ),
                    ),
                    IconButton(
                      onPressed: _products.isNotEmpty
                          ? () async {
                              await _homeProvider.clearSearchedProducts();
                              setState(() {
                                _products.clear();
                              });
                            }
                          : null,
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Row(
                children: [
                  Gap(2),
                  Expanded(
                    child: CheckboxListTile(
                      value: isContinuousScan,
                      onChanged: (value) {
                        isContinuousScan = value;
                        _homeProvider.saveContinueScannerAndReturn(
                          isContinues: isContinuousScan!,
                          isReturn: goodsReturn!,
                        );
                        setState(() {});
                      },
                      title: Text(
                        "Continu scanner",
                        style: Theme.of(context).textTheme.caption,
                      ),
                      visualDensity:
                          const VisualDensity(horizontal: -4.0, vertical: -1),
                      dense: true,
                      checkboxShape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      side: BorderSide(
                        color: AppColors.grey,
                        width: 2,
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.only(left: 6),
                    ),
                  ),
                  // Expanded(
                  //   child: CheckboxListTile(
                  //     value: goodsReturn,
                  //     onChanged: (value) {
                  //       goodsReturn = value;
                  //       _homeProvider.saveContinueScannerAndReturn(
                  //         isContinues: isContinuousScan!,
                  //         isReturn: goodsReturn!,
                  //       );
                  //       setState(() {});
                  //     },
                  //     title: Text(
                  //       "Retouren",
                  //       style: Theme.of(context).textTheme.caption,
                  //     ),
                  //     visualDensity:
                  //         const VisualDensity(horizontal: -4.0, vertical: -1),
                  //     dense: true,
                  //     checkboxShape: const RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(4))),
                  //     side: BorderSide(
                  //       color: AppColors.grey,
                  //       width: 2,
                  //     ),
                  //     controlAffinity: ListTileControlAffinity.leading,
                  //     contentPadding: const EdgeInsets.only(left: 6),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final entry = entryList[i];
                  final ean = entry.key;
                  final tuple = entry.value;
                  final loading = tuple.item1;
                  final product = tuple.item2;
                  final Widget child;
                  if (loading) {
                    child = ListTile(
                      title: Text(ean),
                      leading: const CircularProgressIndicator.adaptive(),
                    );
                  } else if (product == null) {
                    child = ListTile(
                      title: Text(ean),
                      subtitle: Text("Not Found"),
                      leading: const AmountWidget(0),
                    );
                  } else {
                    final String? status;
                    switch (product.status) {
                      case 2:
                        status = "intl.statusDescending";
                        break;
                      case 3:
                        status = "intl.statusDiscontinued";
                        break;
                      default:
                        status = null;
                    }
                    child = ListTile(
                      onTap: () async {
                        await showProductAdjustmentPopup(
                            context: context,
                            product: product,
                            onConfirmAmount: (
                                {num? amount,
                                int? countDifferenceAmount,
                                String? warehouseLocation}) async {
                              product.stock = amount;
                              product.countDifferenceAmount =
                                  countDifferenceAmount;
                              product.warehouseLocation = warehouseLocation ?? "";
                              await _homeProvider.updateProductMoq(
                                id: product.id,
                                moq: product.moq ?? 1,
                                quantity: amount!,
                              );
                              setState(() {
                                _products.update(
                                    ean, (_) => Tuple2(false, product));
                              });
                            });
                        _focusNode.requestFocus();
                      },
                      title: Container(
                        margin: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (product.generalSalePriceIncluding !=
                                      null) ...[
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        formatCurrency.format(
                                            product.generalSalePriceIncluding),
                                        style:
                                            theme.textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(product.description ?? '-',
                                  style: theme.textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('${product.uid} | ${product.unit}',
                              style: const TextStyle(color: AppColors.black)),
                          const SizedBox(height: 8),
                          if (status != null) ...[
                            Text(status),
                            const SizedBox(height: 8),
                          ],
                          Text('${product.ean}',
                              style: const TextStyle(color: AppColors.black)),
                        ],
                      ),
                      leading: AmountWidget(product.stock?.toInt() ?? 1),
                    );
                  }
                  return Dismissible(
                    key: Key(ean),
                    onDismissed: (_) async {
                      await _homeProvider.clearProduct(id: product!.id);
                      setState(() {
                        _products.remove(ean);
                      });
                    },
                    background: Container(
                      color: AppColors.primary,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.delete,
                        color: AppColors.white,
                      ),
                    ),
                    child: Column(
                      children: [
                        child,
                        const Divider(),
                      ],
                    ),
                  );
                },
                childCount: _products.length,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: AppButton(
              buttonColor: _products.isNotEmpty && countListModel != null
                  ? AppColors.primary
                  : AppColors.grey,
              onPressed: _products.isNotEmpty && countListModel != null
                  ? () async {
                      // await showOrderPopup(
                      //   context: context,
                      //   onSubmitOrder: _orderProduct,
                      // );

                      bool success = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: CountWidget(
                                      countListModel: countListModel!,
                                      products: _products,
                                      callBack: () async {
                                        await _homeProvider
                                            .clearSearchedProducts();
                                        setState(
                                          () {
                                            _products.clear();
                                          },
                                        );
                                      }),
                                );
                              }) ??
                          false;
                      if (!success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Something went wrong")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Count stock mutation has been saved successfully")));
                      }
                    }
                  : null,
              child: Text('Toevoegen aan telling',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.semiBold
                      .s16
                      .white),
            ),
          ),
        ),
      ),
    );
  }

  _onSubmit(String barcodeStr) async {
    String barcode = barcodeStr;
    if (barcode.length == 13) {
      barcode = '0$barcode';
    }
    final productsList = await _homeProvider.searchProducts(barcodeStr);
    barcode = productsList.first.ean!;
    if (_products.containsKey(barcode)) {
      final product = productsList.first;
      if (goodsReturn!) {
        product.moq = (product.moq ?? 1) * -1;
      }
      final moq =
          ((_products[barcode]!.item2!.stock ?? 1) + (product.moq ?? 1));
      final currentProduct =
          _products[barcode]!.item2?.copyWith(moq: product.moq, stock: moq);
      if (moq < 1000 && moq > -999) {
        await _homeProvider.updateProductMoq(
          id: product.id,
          moq: product.moq ?? 1,
          quantity: moq,
        );
        setState(() {
          print("barcode: $barcode");
          _products.update(barcode, (_) => Tuple2(false, currentProduct));
        });
      }
      return;
    } else {
      setState(() {
        if (!_products.containsValue(barcode)) {
          LinkedHashMap<String, Tuple2<bool, Product?>> newProducts =
              LinkedHashMap<String, Tuple2<bool, Product?>>();
          newProducts
              .addAll({productsList.first.ean!: const Tuple2(true, null)});
          newProducts.addAll(_products);
          _products = newProducts;
          // _products.addAll({barcode: const Tuple2(true, null)});
        }
        print("barcode2: $barcode");
        print("_products: ${_products.keys}");
        print("_products: ${_products.entries}");
      });
    }

    final messenger = ScaffoldMessenger.of(context);
    try {
      // final list = await _homeProvider.searchProducts(barcodeStr);
      Product? product;
      if (productsList.isEmpty) {
        if (!mounted) return;
        product = null;
        // final snackBar = SnackBar(content: Text(S.of(context).productNotFound));
        // messenger.showSnackBar(snackBar);
        throw "Product Not Found";
      } else {
        product = productsList.first;
        product = product.copyWith(
            stock: (productsList.first.moq ?? 1) * (goodsReturn! ? -1 : 1));
        print("productsList.first.moq");
        print(productsList.first.moq);
      }
      setState(() {
        // if (!_products.containsValue(barcode)) {
        //   LinkedHashMap<String, Tuple2<bool, Product?>> newProducts =
        //       LinkedHashMap<String, Tuple2<bool, Product?>>();
        //   newProducts.addAll({barcode: const Tuple2(true, null)});
        //   // newProducts.addAll(_products);
        //   _products = newProducts;
        //   // _products.addAll({barcode: const Tuple2(true, null)});
        // }
        print("()()()()()()(");
        print(productsList.first.ean!);
        print(_products.entries);
        _products.update(
            productsList.first.ean!, (_) => Tuple2(false, product));
      });
      final p = _products.values
          .where((e) => e.item2 != null)
          .map((e) => e.item2!)
          .toList();
      await _homeProvider.saveSearchedProducts(products: p);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      messenger.showSnackBar(snackBar);
      setState(() {
        _products.remove(barcode);
      });
      rethrow;
    }
  }

  _orderProduct(String orderTypeCode, String customerCode) async {
    final List<OrderLine> lines = [];
    _products.values.toList().map((e) => e.item2).toList().forEach((product) {
      if (product != null) {
        lines.add(OrderLine(
            unitCode: product.unit,
            qtyOrdered: product.moq?.toInt() ?? 0,
            productIdentifier: ProductIdentifier(productCode: product.uid)));
      }
    });
    var orderRequest = OrderRequest(
        orderTypeCode: orderTypeCode,
        customerCode: customerCode,
        // lastChangedByUser: _homeProvider.setting!.userName,
        lines: lines,
        propertiesToInclude: '*');
    if (lines.isNotEmpty) {
      final response = await _homeProvider.orderProduct(request: orderRequest);

      if (response.item2 != null) {
        // await showErrorPopup(message: response.item2!);
      } else {
        // await showOrderSuccessPopup();
        await _homeProvider.clearSearchedProducts();
        setState(
          () {
            _products.clear();
          },
        );
      }
    }
    if (kDebugMode) {
      print('===== orderRequest ${orderRequest.toJson()}');
    }
  }
}

class CountWidget extends StatefulWidget {
  const CountWidget(
      {required this.products,
      required this.callBack,
      required this.countListModel});

  final Map<String, Tuple2<bool, Product?>> products;
  final VoidCallback callBack;
  final CountListModel countListModel;

  @override
  State<CountWidget> createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  ProductApiProvider productApiProvider = ProductApiProvider();
  Future? future;

  @override
  void initState() {
    future = productApiProvider.addOrderCount(
        countId: widget.countListModel.id,
        warehouseId: widget.countListModel.warehouseId,
        itemList: widget.products.entries
            .map((e) => {
                  "amount": e.value.item2?.stock,
                  "productId": e.value.item2?.id,
                  "warehouseLocation": e.value.item2?.warehouseLocation,
                  "countDifferenceAmount": e.value.item2?.countDifferenceAmount,
                })
            .toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                Navigator.pop(context, true);
                widget.callBack();
              } else if (snapshot.hasData && snapshot.data == false) {
                Navigator.pop(context, false);
              }
              return const CircularProgressIndicator();
            }),
      ],
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close),
        ),
        elevation: 0,
        backgroundColor: AppColors.green,
      ),
      body: const Center(
        child: Icon(
          Icons.check,
          size: 200,
        ),
      ),
    );
  }
}
