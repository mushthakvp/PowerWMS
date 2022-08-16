import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Amount extends StatefulWidget {
  const Amount(this._value, this._onChange, {
    required this.autofocus,
    required this.onCompleteEditing, Key? key
  }) : super(key: key);

  final int _value;
  final void Function(int value) _onChange;
  final void Function(int value) onCompleteEditing;
  final bool? autofocus;

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  final controller = TextEditingController(text: '');

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
            widget._onChange(max<int>(0, widget._value - 1));
          },
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            autofocus: widget.autofocus ?? false,
            onEditingComplete: () {
              widget.onCompleteEditing(widget._value);
            },
            style: TextStyle(
              fontSize: 24,
              height: 2.0,
            ),
          ),
        ),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            widget._onChange(widget._value + 1);
          },
        ),
      ],
    );
  }
}
