import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/product_stock.dart';
import 'package:scanner/screens/count_screen/home_provider.dart';
import 'package:scanner/screens/count_screen/model/product.dart';
import 'package:scanner/util/color_const.dart';

typedef OnConfirmAmount = Function(num amount);

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
    if (kDebugMode) {
      print("========== $amount");
    }
  }

  Future<ProductStock?>? productStock;

  getProductStock() async {
    productStock = _homeProvider.fetchProductStock(
      productCode: widget.product.uid,
      unitCode: widget.product.unit,
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _homeProvider = Provider.of<HomeProvider>(context, listen: false);
      setProductAmount(widget.product.moq?.toInt() ?? 1);
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
          /// Header
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
                  const CloseButton()
                ],
              ),
              FutureBuilder<ProductStock?>(
                  future: productStock,
                  builder: (context, AsyncSnapshot<ProductStock?> snapshot) {
                    print(snapshot.hasError);
                    print(snapshot.error);
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      TextStyle textStyle = const TextStyle(
                          color: Colors.black54,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500);
                      return Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Verkoopprijs:",
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyle,
                                  ),
                                  Text(
                                    "Technische voorraad:",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: textStyle,
                                  ),
                                  Text(
                                    "Vrije voorraad:",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${snapshot.data?.price}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                                Text(
                                  "${snapshot.data?.resultData?.first.actualStock}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                                Text(
                                  "${snapshot.data?.resultData?.first.freeStock}",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Text(
                        "Technische voorraad: Niet beschikbaar\nVrije voorraad: Niet beschikbaar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      );
                    }
                  }),
            ],
          ),
          const SizedBox(height: 24),

          /// Increase/Decrease product amount
          Amount(
            productAmount,
            (amount) {
              setProductAmount(amount);
            },
            moq: widget.product.moq?.toInt() ?? 1,
            autofocus: true,
            onCompleteEditing: (num amount) {
              widget.onConfirmAmount(amount);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),

          /// Confirm button
          SizedBox(
            height: 49,
            width: double.maxFinite,
            child: ElevatedButton(
              child: Text(
                "SAVE",
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                widget.onConfirmAmount(_productAmount!);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Amount extends StatefulWidget {
  const Amount(this._productAmount, this._onChange,
      {required this.autofocus,
      required this.onCompleteEditing,
      Key? key,
      required this.moq})
      : super(key: key);

  final num _productAmount;
  final num moq;
  final void Function(num value) _onChange;
  final void Function(num value) onCompleteEditing;
  final bool? autofocus;

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
                productAmount = int.tryParse(txt) ?? 1;
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
