import 'package:flutter/material.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/screens/product_screen/widgets/line_info.dart';
import 'package:scanner/screens/product_screen/widgets/product_view.dart';
import 'package:scanner/screens/product_screen/widgets/reserved_list.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(this.line, {Key? key}) : super(key: key);

  final PicklistLine line;

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<StockMutation>? _mutationFuture;

  @override
  void initState() {
    _mutationFuture = StockMutation.fromMemory(widget.line);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        widget.line.location ?? '',
        context: context,
      ),
      body: FutureBuilder<StockMutation>(
        future: _mutationFuture!,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('${snapshot.error}\n${snapshot.stackTrace}');
            return Container();
          }
          if (!snapshot.hasData) {
            return Container();
          }
          final mutation = snapshot.data!;
          return CustomScrollView(
            slivers: <Widget>[
              LineInfo(widget.line),
              ProductView(mutation),
              ReservedList(widget.line),
            ],
          );
        },
      ),
    );
  }
}
