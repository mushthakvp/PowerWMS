import 'package:flutter/material.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/screens/products_screen/widgets/amount.dart';

typedef OnConfirmAmount = Function(int amount, bool isCancel);

class ProductAdjustmentWidget extends StatefulWidget {
  const ProductAdjustmentWidget({required this.onConfirmAmount, Key? key})
      : super(key: key);

  final OnConfirmAmount onConfirmAmount;

  @override
  State<ProductAdjustmentWidget> createState() =>
      _ProductAdjustmentWidgetState();
}

class _ProductAdjustmentWidgetState extends State<ProductAdjustmentWidget> {
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
              child: Text(
                '$_productAmount',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
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
        Amount(
          _productAmount,
          (value) {},
          autofocus: true,
          onCompleteEditing: (onCompleteEditing) {},
        ),

        /// Increase/Decrease product amount

        /// Check box
        Container(
          child: Row(
            children: [
              Checkbox(
                  value: _isCancelRestProduct,
                  onChanged: (bool? value) {
                    setCancelRestProduct();
                  }),
              Text(AppLocalizations.of(context)!.productCancelRestAmount)
            ],
          ),
        ),

        /// Confirm button
        Container(
          height: 49,
          width: double.maxFinite,
          child: ElevatedButton(
            child: Text(
              AppLocalizations.of(context)!.productConfirm,
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
}
