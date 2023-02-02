import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:scanner/resources/product_image_repository.dart';

final productImageRepository = ProductImageRepository();

class ProductImage extends StatefulWidget {
  final int productId;
  final double? width;

  const ProductImage(this.productId, {Key? key, this.width}) : super(key: key);

  @override
  _ProductImageState createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  Future<Uint8List?>? _future;

  @override
  void didChangeDependencies() {
    _future = productImageRepository.getImageFile(widget.productId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future!,
      builder: (context, snapshot) {
        var fallback = Container(
          width: widget.width,
          height: widget.width,
          color: Colors.grey[400],
          child: Text(
            "Image Not Found",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 8),
          ),
          alignment: Alignment.center,
        );
        if (snapshot.hasError) {
          print(snapshot.error);
        }
        if (snapshot.hasData) {
          return InkWell(
            onTap: () {
              OptionPage().showOption(context, snapshot.data!);
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: widget.width ?? double.infinity,
                  minWidth: widget.width ?? double.infinity,
                  maxHeight: 150),
              child: Image.memory(
                snapshot.data!,
                width: widget.width ?? double.infinity,
                fit: BoxFit.fill,
                errorBuilder: (context, error, _) => fallback,
              ),
            ),
          );
        }
        return fallback;
      },
    );
  }
}

class OptionPage {
  /// Show Option
  Future<void> showOption(BuildContext context, Uint8List data) async {
    showDialog<dynamic>(
        context: context,
        barrierColor: Colors.black.withOpacity(.4),
        barrierDismissible: true,
        builder: (BuildContext context) {
          _dialogContext = context;
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 32),
            elevation: 8,
            child: Container(
              color: Colors.white,
              height: 0.6 * MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image.memory(
                      data,
                      fit: BoxFit.fitWidth,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /// BuildContext
  BuildContext? _dialogContext;

  void hideOption() {
    if (_dialogContext != null) {
      if (Navigator.canPop(_dialogContext!)) {
        Navigator.pop(_dialogContext!);
      }
      _dialogContext = null;
    }
  }
}
