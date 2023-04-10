import 'package:flutter/material.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';

class PicklistHeader extends StatefulWidget {
  final Picklist _picklist;

  const PicklistHeader(this._picklist, {Key? key}) : super(key: key);

  @override
  _PicklistHeaderState createState() => _PicklistHeaderState();
}

class _PicklistHeaderState extends State<PicklistHeader> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final picklist = widget._picklist;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ([
          ListTile(
            // visualDensity: VisualDensity.compact,
            onTap: _onTapHandler,
            title: Text(picklist.debtor?.name ?? ''),
            trailing: IconButton(
              icon: Icon(_open ? Icons.expand_less : Icons.expand_more),
              onPressed: _onTapHandler,
            ),
          ),
          Divider(height: 1,),
          if (_open) ..._address(),
          if (widget._picklist.internalMemo != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14,top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.note,
                    style: Theme.of(context).textTheme.titleMedium?.lightGrey,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    widget._picklist.internalMemo ?? "",
                    style: Theme.of(context).textTheme.titleMedium?.semiBold,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Divider(),
          ],
        ]));
  }

  _address() {
    var orderReference = widget._picklist.orderReference;
    // var internalMemo = widget._picklist.internalMemo;
    return [
      if (widget._picklist.debtor?.address != null) ...[
        ListTile(
          title: Text(widget._picklist.debtor?.address ?? ''),
        ),
      ],
      if (orderReference != null) ...[
        ListTile(
          title: Text(AppLocalizations.of(context)!.reference),
          subtitle: Text(orderReference),
        ),
      ],
      // Divider(),
    ];
  }

  _onTapHandler() {
    setState(() {
      _open = !_open;
    });
  }
}
