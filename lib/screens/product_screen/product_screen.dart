import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/ProductDetailModel.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/models/product_stock.dart';
import 'package:scanner/resources/product_repository.dart';
import 'package:scanner/screens/product_screen/widgets/line_info.dart';
import 'package:scanner/screens/product_screen/widgets/product_view.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';

  const ProductScreen(this._product, {Key? key}) : super(key: key);

  final Product _product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<ProductStock?>? productStock;
  Future<ProductDetailModel?>? productDetails;

  getProductStock() async {
    final _productProvider = context.read<ProductRepository>();
    productStock = _productProvider.fetchProductStock(
      productCode: widget._product.uid,
      unitCode: widget._product.unit,
    );
    print(productStock);
  }

  getProductDetail() async {
    final _productProvider = context.read<ProductRepository>();
    productDetails = _productProvider.fetchProductDetails(
      productCode: widget._product.uid,
      unitCode: widget._product.unit,
    );
    print(productDetails);
  }

  @override
  void initState() {
    getProductStock();
    getProductDetail();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar('', leading: BackButton()),
      body: CustomScrollView(
        slivers: <Widget>[
          LineInfo(widget._product),
          SliverToBoxAdapter(
            child: FutureBuilder<ProductStock?>(
                future: productStock,
                builder: (context, AsyncSnapshot<ProductStock?> snapshot) {
                  print(snapshot.hasError);
                  print(snapshot.error);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    TextStyle textStyle = const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Verkoopprijs:",
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyle,
                                ),
                                Gap(4),
                                Text(
                                  "Technische voorraad:",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                                Gap(4),
                                Text(
                                  "Vrije voorraad:",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${snapshot.data?.price}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                              Gap(4),
                              Text(
                                "${snapshot.data?.resultData?.first.actualStock}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                              Gap(4),
                              Text(
                                "${snapshot.data?.resultData?.first.freeStock}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<ProductDetailModel?>(
                future: productDetails,
                builder:
                    (context, AsyncSnapshot<ProductDetailModel?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    TextStyle textStyle = const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Voorraad locatie:",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                                Gap(4),
                                Text(
                                  "Magazijn locatie:",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  style: textStyle,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${snapshot.data?.locationCode}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                              Gap(4),
                              Text(
                                "${snapshot.data?.warehouseCode}",
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: textStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
          ProductView(widget._product),
        ],
      ),
    );
  }
}
