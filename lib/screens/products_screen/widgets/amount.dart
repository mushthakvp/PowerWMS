import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class Amount extends StatefulWidget {
  final String value;
  final void Function(String value) onChange;

  const Amount(this.value, this.onChange, {Key? key}) : super(key: key);

  @override
  _AmountState createState() => _AmountState();
}

class _AmountState extends State<Amount> {
  final controller = TextEditingController(text: '1');

  @override
  void didChangeDependencies() {
    controller.text = widget.value;
    controller.addListener(() {
      widget.onChange(controller.text);
    });
    super.didChangeDependencies();
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
            controller.text =
                max<int>(0, (int.tryParse(controller.text) ?? 0) - 1)
                    .toString();
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
          ),
        ),
        ElevatedButton(
          child: Icon(Icons.add),
          onPressed: () {
            controller.text =
                ((int.tryParse(controller.text) ?? 0) + 1).toString();
          },
        ),
      ],
    );
  }
}
