import 'package:flutter/material.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import '../../../pick_list_view/model/pick_list_model.dart';

class PickDropDown extends StatefulWidget {
  final PickListNew _picklist;

  const PickDropDown(this._picklist, {Key? key}) : super(key: key);

  @override
  _PickDropDownState createState() => _PickDropDownState();
}

class _PickDropDownState extends State<PickDropDown> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final picklist = widget._picklist;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ([
          ListTile(
            onTap: _onTapHandler,
            title: Text(picklist.debtor?.name ?? ''),
            trailing: IconButton(
              icon: Icon(_open ? Icons.expand_less : Icons.expand_more),
              onPressed: _onTapHandler,
            ),
          ),
          Divider(
            height: 1,
          ),
          if (_open) ..._address(),
          if (widget._picklist.internalMemo != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 8),
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
    return [
      if (widget._picklist.debtor?.addressId != null) ...[
        ListTile(
          title: Text(widget._picklist.debtor?.addressId.toString() ?? ''),
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
