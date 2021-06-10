import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:gs1_barcode_parser/gs1_barcode_parser.dart';

final parser = GS1BarcodeParser.defaultParser();

class BarcodeInput extends StatefulWidget {
  final void Function(String value, GS1Barcode? barcode) onParse;

  const BarcodeInput(this.onParse, {Key? key}) : super(key: key);

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
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: _parse,
            autofocus: true,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Barcode'),
          ),
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
            setState(() {
              controller.text = value;
            });
            _parse(value);
          },
        ),
      ],
    );
  }

  _parse(String value) {
    try {
      var barcode = parser.parse(value);
      if (barcode.hasAI('01')) {
        widget.onParse(barcode.getAIData('01'), barcode);
      }
    } catch (e) {
      widget.onParse(value, null);
    }
    focusNode.requestFocus();
  }
}
