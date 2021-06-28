import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Amount extends StatelessWidget {
  const Amount(this._value, this._onChange, {Key? key}) : super(key: key);

  final int _value;
  final void Function(int value) _onChange;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: '$_value');
    return Row(
      children: [
        ElevatedButton(
          child: Icon(Icons.remove),
          onPressed: () {
            _onChange(max<int>(0, _value - 1));
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              height: 2.0,
            ),
            onChanged: (String value) {
              _onChange(int.tryParse(value) ?? _value);
            },
          ),
        ),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            _onChange(_value + 1);
          },
        ),
      ],
    );
  }
}
