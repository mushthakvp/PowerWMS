import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/models/product.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/product_image.dart';

class ProductView extends StatelessWidget {
  const ProductView(this.product, {Key? key}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    print(product.toJson());
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
                  Text(product.ean ?? ''),
                ],
              ),
              Spacer(),
              ProductImage(product.id, width: 120),
            ],
          ),
        ),
        if (product.packagings.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Packaging',
                  style: Theme.of(context).textTheme.subtitle1?.semiBold,
                ),
              ),
            ],
          ),
        ...product.packagings
            .map((packaging) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${packaging.packagingUnitTranslations.where((element) => element.culture == "nl").first.value} - ${packaging.uid}',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                            "${packaging.defaultAmount} x ${product.unit}",
                            style: Theme.of(context).textTheme.subtitle1),
                        Text(
                            "${packaging.weight} ${packaging.weightMeasurementUnitId}",
                            style: Theme.of(context).textTheme.subtitle1),
                      ]),
                ))
            .toList(),
        Divider(height: 1),
        if (product.extra1 != null && product.extra1!.isNotEmpty)
          ListTile(
            dense: true,
            title: Text('Extra 1: ${product.extra1}'),
          ),
        if (product.extra2 != null && product.extra2!.isNotEmpty)
          ListTile(
            dense: true,
            title: Text('Extra 2: ${product.extra2}'),
          ),
        if (product.extra3 != null && product.extra3!.isNotEmpty)
          ListTile(
            dense: true,
            title: Text('Extra 3: ${product.extra3}'),
          ),
        if (product.extra4 != null && product.extra4!.isNotEmpty)
          ListTile(
            dense: true,
            title: Text('Extra 4: ${product.extra4}'),
          ),
        if (product.extra5 != null && product.extra5!.isNotEmpty)
          ListTile(
            dense: true,
            title: Text('Extra 5: ${product.extra5}'),
          ),
      ]),
    );
  }
}
