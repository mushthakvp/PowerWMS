import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';

typedef OnConfirmAmount = Function(int amount, bool isCancel);

Future<void> showProductAdjustmentPopup({
    required BuildContext context,
    required MutationProvider mutationProvider,
    required OnConfirmAmount onConfirmAmount
  }) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Container(
          margin: EdgeInsets.all(16),
          child: ProductAdjustmentWidget(
            mutationProvider: mutationProvider,
            onConfirmAmount: onConfirmAmount,
          )
        ),
      );
    },
  );
}

class ProductAdjustmentWidget extends StatefulWidget {
  const ProductAdjustmentWidget({
    required this.mutationProvider,
    required this.onConfirmAmount,
  Key? key}) : super(key: key);

  final MutationProvider mutationProvider;
  final OnConfirmAmount onConfirmAmount;

  @override
  State<ProductAdjustmentWidget> createState() => _ProductAdjustmentWidgetState();
}

class _ProductAdjustmentWidgetState extends State<ProductAdjustmentWidget> {

  String get headerTitle {
    return widget.mutationProvider.line.product.unit;
  }

  String get productAmount {
    return '${widget.mutationProvider.showToPickAmount}';
  }

  int _productAmount = 0;

  setProductAmount(int amount) {
    setState(() {
      _productAmount = amount;
    });
    print("========== $amount");
  }

  bool _isCancelRestProduct = false;

  setCancelRestProduct() {
    setState(() {
      _isCancelRestProduct = !_isCancelRestProduct;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setProductAmount(widget.mutationProvider.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// Header
        Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text('$productAmount $headerTitle',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold
                ),),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: Icon(Icons.clear),
              ),
            )
          ],
        ),
        SizedBox(height: 16),
        /// Increase/Decrease product amount
        Container(
          child: Column(
            children: _amountInput(context, widget.mutationProvider),
          ),
        ),
        SizedBox(height: 16),
        /// Check box
        Container(
          child: Row(
            children: [
              Checkbox(
                  value: _isCancelRestProduct,
                  onChanged: (bool? value) {
                    setCancelRestProduct();
                  }
              ),
              Text(AppLocalizations.of(context)!.productCancelRestAmount)
            ],
          ),
        ),
        SizedBox(height: 16),
        /// Confirm button
        Container(
          height: 49,
          width: double.maxFinite,
          child: ElevatedButton(
            child: Text(AppLocalizations.of(context)!.productConfirm,
            style: TextStyle(
              fontSize: 20.0,
              ),
            ),
            onPressed: () {
              widget.onConfirmAmount(_productAmount, _isCancelRestProduct);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  _amountInput(BuildContext context, MutationProvider mutation) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Column(
          children: [
            Amount(
              _productAmount,
              (amount) {
                setProductAmount(amount);
              },
              autofocus: true,
              onCompleteEditing: (int amount) {
                widget.onConfirmAmount(amount, _isCancelRestProduct);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    ];
  }
}

