import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:scanner/gs1_barcode_parser/src/barcode_parser.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _result = '';
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final parser = GS1BarcodeParser.defaultParser();
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onSubmitted: (String value) {
                        setState(() {
                          print(value);
                          try {
                            _result = parser.parse(value).toString();
                          } catch (e) {
                            _result = 'Invalid matrix for $value';
                            print(e);
                          }
                        });
                        focusNode.requestFocus();
                      },
                      autofocus: true,
                      focusNode: focusNode,
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
                        try {
                          _result = parser.parse(value).toString();
                        } catch (e) {
                          _result = 'Invalid matrix for $value';
                          print(e);
                        }
                      });
                      focusNode.requestFocus();
                    },
                  ),
                ],
              ),
              Text(
                _result.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
