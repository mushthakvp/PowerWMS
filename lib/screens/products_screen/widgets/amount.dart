import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Amount extends StatefulWidget {
  const Amount(this._productAmount, this._onChange, {
    required this.autofocus,
    required this.onCompleteEditing, Key? key
  }) : super(key: key);

  final int _productAmount;
  final void Function(int value) _onChange;
  final void Function(int value) onCompleteEditing;
  final bool? autofocus;

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  final controller = TextEditingController(text: '');
  int productAmount = 0;

  @override
  void initState() {
    super.initState();
    productAmount = widget._productAmount;
  }

  _updateProductCount({required bool isIncrease}) {
    _updateTextField() {
      controller.text = productAmount.toString();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
    if (!isIncrease) {
      productAmount = max<int>(0, productAmount - 1);
      _updateTextField();
    }
    if (isIncrease) {
      if (productAmount < 0) {
        productAmount = 0;
      }
      productAmount += 1;
      _updateTextField();
    }
    widget._onChange(productAmount);
  }

  /*
  @override
  void didChangeDependencies() {
    controller.text = widget._value.toString();
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
    controller.addListener(() {
      if (controller.text != widget._value.toString()) {
        Future.microtask(() {
          var value = int.tryParse(controller.text);
          print(value);
          if (value != null) {
            widget._onChange(value);
          }
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant Amount oldWidget) {
    if (widget._value != int.tryParse(controller.text)) {
      controller.text = widget._value.toString();
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
    super.didUpdateWidget(oldWidget);
  }
   */

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          child: Icon(Icons.remove),
          onPressed: () {
            _updateProductCount(isIncrease: false);
          },
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
            style: TextStyle(
              fontSize: 24,
              height: 2.0,
            ),
            onChanged: (String txt) {
              if (txt != '') {
                productAmount = int.parse(txt);
              } else {
                productAmount = 0;
              }
              widget._onChange(productAmount);
            },
          ),
        ),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            _updateProductCount(isIncrease: true);
          },
        ),
      ],
    );
  }
}
