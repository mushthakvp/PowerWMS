import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner/barcode_parser/barcode_parser.dart';

final parser = GS1BarcodeParser.defaultParser();
typedef OnBarCodeChanged = Function(String);

class BarcodeInput extends StatefulWidget {
  final void Function(String value, GS1Barcode? barcode) onParse;
  final OnBarCodeChanged? onBarCodeChanged;

  const BarcodeInput(this.onParse, this.onBarCodeChanged,
      {Key? key}) : super(key: key);

  @override
  _BarcodeInputState createState() => _BarcodeInputState();
}

class _BarcodeInputState extends State<BarcodeInput> {
  FocusNode focusNode = FocusNode();
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent &&
            (event.logicalKey.keyLabel == 'Enter')) {
          _parse(controller.text);
        }
      },
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              onFieldSubmitted: _parse,
              onSaved: _parse,
              autofocus: true,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Barcode'),
              onChanged: widget.onBarCodeChanged,
            ),
          ),
          IconButton(
            onPressed: () {
              controller.clear();
              _parse('');
            },
            icon: Icon(Icons.clear),
          ),
          IconButton(
            icon: Icon(Icons.photo_camera_rounded),
            onPressed: () async {
              String value = await FlutterBarcodeScanner.scanBarcode(
                "#ff6666",
                "Cancel",
                false,
                ScanMode.DEFAULT,
              );
              if (value != '-1') {
                setState(() {
                  controller.text = value;
                });
                _parse(value);
              }
            },
          ),
        ],
      ),
    );
  }

  void _parse(String? value) {
    if (value != null && value.isNotEmpty) {
      try {
        var barcode = parser.parse(value);
        if (barcode.hasAI('01')) {
          widget.onParse(barcode.getAIData('01'), barcode);
        }
      } catch (e) {
        widget.onParse(value, null);
      }
      setState(() {
        controller.text = '';
        focusNode.requestFocus();
      });
    }
  }
}
