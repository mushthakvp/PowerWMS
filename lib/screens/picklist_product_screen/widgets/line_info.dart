import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

class LineInfo extends StatefulWidget {
  final PicklistLine _line;

  const LineInfo(this._line, {Key? key}) : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<LineInfo> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final line = widget._line;
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          // visualDensity: VisualDensity.compact,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap(6),
              Text(line.product.description ?? '-'),
              if (line.descriptionB?.isNotEmpty ?? false) ...[
                Gap(4),
                Text(
                  line.descriptionB ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.semiBold,
                ),
              ],
              if (line.internalMemo?.isNotEmpty ?? false) ...[
                Gap(4),
                Text(
                  line.internalMemo ?? "",
                  style: Theme.of(context).textTheme.titleMedium?.semiBold,
                ),
              ]
            ],
          ),

          trailing: IconButton(
              icon: Icon(
                Icons.qr_code,
                color: AppColors.primary,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          content: Container(
                            color: Colors.white,
                            height: 250,
                            width: 200,
                            alignment: Alignment.center,
                            child: QrImage(
                                padding: EdgeInsets.zero,
                                data: line.product.uid,
                                version: QrVersions.auto),
                          ),
                        ));
              }),
          // trailing: Icon(_open ? Icons.expand_less : Icons.expand_more),
          onTap: () {
            setState(() {
              _open = !_open;
            });
          },
        ),
        Divider(height: 2),
        // if (_open) ..._tiles(line),
      ]),
    );
  }

  _tiles(PicklistLine line) {
    return [
      ListTile(
        visualDensity: VisualDensity.compact,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.productWarehouseStock,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${line.available} x ${line.product.unit}'),
              ],
            ),
          ],
        ),
      ),
      Divider(height: 1),
    ];
  }
}
