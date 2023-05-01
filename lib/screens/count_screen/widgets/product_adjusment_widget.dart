import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/count_product_stock/product_stock.dart';
import 'package:scanner/screens/count_screen/home_provider.dart';
import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

typedef OnConfirmAmount = Function(
    {num amount, int countDifferenceAmount, String warehouseLocation});

Future<void> showProductAdjustmentPopup(
    {required BuildContext context,
    required Product product,
    required OnConfirmAmount onConfirmAmount}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
            margin: const EdgeInsets.all(16),
            child: ProductAdjustmentWidget(
              onConfirmAmount: onConfirmAmount,
              product: product,
            )),
      );
    },
  );
}

class ProductAdjustmentWidget extends StatefulWidget {
  const ProductAdjustmentWidget(
      {required this.onConfirmAmount, required this.product, Key? key})
      : super(key: key);

  final OnConfirmAmount onConfirmAmount;
  final Product product;

  @override
  State<ProductAdjustmentWidget> createState() =>
      _ProductAdjustmentWidgetState();
}

class _ProductAdjustmentWidgetState extends State<ProductAdjustmentWidget> {
  late HomeProvider _homeProvider;

  String? selectedLocationCode;

  void onLocationSelected(String locationCode) {
    setState(() {
      selectedLocationCode = locationCode;
    });
  }

  String get headerTitle {
    return widget.product.unit;
  }

  num get productAmount {
    return widget.product.stock?.toInt() ?? 1;
  }

  num? _productAmount = 1;

  setProductAmount(num amount) {
    setState(() {
      _productAmount = amount;
    });
  }

  Future<ProductStock?>? productStock;
  Map<String, int> locationStockMap = {};

  getProductStock() async {
    productStock = _homeProvider.fetchProductStock(
      productCode: widget.product.uid,
      unitCode: widget.product.unit,
    );
    ProductStock? fetchedProductStock = await productStock;
    if (fetchedProductStock?.resultData?.isNotEmpty ?? false) {
      fetchedProductStock?.resultData?.first.locationStock?.forEach((e) {
        if (locationStockMap.containsKey(e.locationCode)) {
          locationStockMap[e.locationCode!] =
              (locationStockMap[e.locationCode] ?? 0) +
                  e.physicalStock!.toInt();
        } else {
          locationStockMap[e.locationCode!] = e.physicalStock!.toInt();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _homeProvider = Provider.of<HomeProvider>(context, listen: false);
      setProductAmount(widget.product.moq?.toInt() ?? productAmount);
      await getProductStock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseButton(
                    color: Colors.white,
                    onPressed: () {},
                  ),
                  Text(
                    headerTitle,
                    style: const TextStyle(
                        color: AppColors.black87,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold),
                  ),
                  CloseButton(
                    onPressed: () {
                      SystemChannels.textInput
                          .invokeMethod<void>('TextInput.hide');
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              FutureBuilder<ProductStock?>(
                  future: productStock,
                  builder: (context, AsyncSnapshot<ProductStock?> snapshot) {
                    TextStyle textStyle = const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      Map<String, int> locationStockMap = {};
                      if (snapshot.data?.resultData?.isNotEmpty ?? false)
                        snapshot.data?.resultData?.first.locationStock
                            ?.forEach((e) {
                          if (locationStockMap.containsKey(e.locationCode)) {
                            locationStockMap[e.locationCode!] =
                                (locationStockMap[e.locationCode] ?? 0) +
                                    e.physicalStock!.toInt();
                          } else {
                            locationStockMap[e.locationCode!] =
                                e.physicalStock!.toInt();
                          }
                        });
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snapshot.data?.resultData?.isNotEmpty ?? false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Locatie",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyle.black,
                                  ),
                                ),
                                Gap(12),
                                Expanded(
                                  child: Text(
                                    " Partij",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: textStyle.black,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Aantal",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    maxLines: 1,
                                    style: textStyle.black,
                                  ),
                                ),
                              ],
                            ),
                            if (snapshot.data?.resultData?.isNotEmpty ?? false)
                              ...?snapshot.data?.resultData!.first.locationStock
                                  ?.map((e) => Card(
                                        elevation: 2,
                                        margin: EdgeInsets.only(top: 8),
                                        child: InkWell(
                                          onTap: () => onLocationSelected(
                                              e.locationCode!),
                                          child: Container(
                                            color: selectedLocationCode ==
                                                    e.locationCode
                                                ? Colors.grey.withOpacity(0.3)
                                                : Colors.transparent,
                                            padding: const EdgeInsets.all(3),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${e.locationCode}",
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    style: textStyle.s15,
                                                  ),
                                                ),
                                                Gap(12),
                                                Expanded(
                                                  child: Text(
                                                    "${e.batchCode}",
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    style: textStyle.s15,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${e.physicalStock?.toInt()}",
                                                    textAlign: TextAlign.end,
                                                    maxLines: 1,
                                                    style: textStyle.s15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            if (snapshot.data?.resultData?.isNotEmpty ?? false)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.info,
                                      color: AppColors.grey,
                                      size: 13,
                                    ),
                                    Gap(4),
                                    Expanded(
                                      child: Text(
                                        "Tik op een locatie om het totaal te bekijken",
                                        style: textStyle.black60.s12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (selectedLocationCode != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12.0, right: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${_productAmount!.toInt()} van ${locationStockMap[selectedLocationCode]} : ",
                                        style: textStyle.black.s15,
                                      ),
                                    ),
                                    Text(
                                      "${(_productAmount?.toInt() ?? 0) - (locationStockMap[selectedLocationCode] ?? 0)}",
                                      style: textStyle.s15,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Locatie",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textStyle,
                              ),
                              Text(
                                "Partij",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                              Text(
                                "Aantal",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                style: textStyle,
                              ),
                            ],
                          ),
                          Gap(16),
                          Text(
                            "Niet beschikbaar",
                            style: textStyle,
                          )
                        ],
                      );
                    }
                  }),
            ],
          ),
          const SizedBox(height: 24),
          Amount(
            productAmount,
            (amount) {
              setProductAmount(amount);
            },
            locationStockMap: locationStockMap,
            // Pass locationStockMap to Amount widget
            selectedLocationCode: selectedLocationCode,
            // Pass selectedLocationCode to Amount widget
            moq: widget.product.moq?.toInt() ?? 1,
            autofocus: true,
            onCompleteEditing: (num amount) {
              widget.onConfirmAmount(
                amount: amount,
                warehouseLocation: selectedLocationCode ?? "",
                countDifferenceAmount: ((_productAmount?.toInt() ?? 0) -
                        (locationStockMap[selectedLocationCode] ?? 0))
                    .toInt(),
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 49,
            width: double.maxFinite,
            child: ElevatedButton(
              child: Text(
                AppLocalizations.of(context)!.save,
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                widget.onConfirmAmount(
                    amount: _productAmount!,
                    warehouseLocation: selectedLocationCode ?? "",
                    countDifferenceAmount: ((_productAmount?.toInt() ?? 0) -
                        (locationStockMap[selectedLocationCode] ?? 0))
                        .toInt());
                SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Amount extends StatefulWidget {
  const Amount(
    this._productAmount,
    this._onChange, {
    required this.autofocus,
    required this.onCompleteEditing,
    Key? key,
    required this.moq,
    required this.locationStockMap,
    required this.selectedLocationCode,
  }) : super(key: key);

  final num _productAmount;
  final num moq;
  final void Function(num value) _onChange;
  final void Function(num value) onCompleteEditing;
  final bool? autofocus;
  final Map<String, int> locationStockMap;
  final String? selectedLocationCode;

  @override
  AmountState createState() => AmountState();
}

class AmountState extends State<Amount> {
  final controller = TextEditingController(text: '');
  num productAmount = 0;

  @override
  void initState() {
    super.initState();
    productAmount = widget._productAmount;
    controller.text = productAmount.toString();
  }

  _updateProductCount({required bool isIncrease}) {
    _updateTextField() {
      controller.text = productAmount.toString();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }

    if (!isIncrease) {
      productAmount = productAmount - widget.moq;
      _updateTextField();
    }
    if (isIncrease) {
      productAmount += widget.moq;
      _updateTextField();
    }
    widget._onChange(productAmount);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Access locationStockMap and selectedLocationCode using widget.locationStockMap and widget.selectedLocationCode
    // Add your logic based on the available data

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Icon(Icons.remove),
          onPressed: () {
            _updateProductCount(isIncrease: false);
          },
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: widget.autofocus ?? false,
            onEditingComplete: () {
              widget.onCompleteEditing(productAmount);
            },
            style: const TextStyle(
              fontSize: 24,
            ),
            onChanged: (String txt) {
              if (txt != '') {
                productAmount = int.tryParse(txt) ?? 22;
              } else {
                productAmount = 0;
              }
              widget._onChange(productAmount);
            },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        ElevatedButton(
          child: const Icon(Icons.add),
          onPressed: () {
            _updateProductCount(isIncrease: true);
          },
        ),
      ],
    );
  }
}
