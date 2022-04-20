import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/widgets/product_image.dart';

class ProductView extends StatelessWidget {
  const ProductView(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.productProductNumber}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(product.uid),
                  SizedBox(height: 10),
                  const Text(
                    'GTIN / EAN:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(product.ean),
                ],
              ),
              Spacer(),
              ProductImage(product.id, width: 120),
            ],
          ),
        ),
        Divider(height: 1),
        ListTile(
          dense: true,
          title: Text('Packaging'),
        ),
        ...product.packagings.map((packaging) => ListTile(
              dense: true,
              title: Text('${packaging.uid} ${packaging.defaultAmount}'),
            )),
        Divider(height: 1),
        if (product.extra1 != null)
          ListTile(
            dense: true,
            title: Text('Extra 1: ${product.extra1}'),
          ),
        if (product.extra2 != null)
          ListTile(
            dense: true,
            title: Text('Extra 2: ${product.extra2}'),
          ),
        if (product.extra3 != null)
          ListTile(
            dense: true,
            title: Text('Extra 3: ${product.extra3}'),
          ),
        if (product.extra4 != null)
          ListTile(
            dense: true,
            title: Text('Extra 4: ${product.extra4}'),
          ),
        if (product.extra5 != null)
          ListTile(
            dense: true,
            title: Text('Extra 5: ${product.extra5}'),
          ),
      ]),
    );
  }
}
