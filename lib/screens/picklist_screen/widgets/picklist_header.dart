import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/models/picklist.dart';

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
        children: ([
      ListTile(
        onTap: _onTapHandler,
        title: Text(picklist.debtor.name),
        trailing: IconButton(
          icon: Icon(_open ? Icons.expand_less : Icons.expand_more),
          onPressed: _onTapHandler,
        ),
      ),
      Divider(),
      if (_open) ..._address(),
    ]));
  }

  _address() {
    var orderReference = widget._picklist.orderReference;
    var internalMemo = widget._picklist.internalMemo;
    return [
      if (widget._picklist.debtor.address != null) ...[
        ListTile(
          title: Text(widget._picklist.debtor.address ?? ''),
        ),
      ],
      if (orderReference != null) ...[
        ListTile(
          title: Text(AppLocalizations.of(context)!.reference),
          subtitle: Text(orderReference),
        ),
      ],
      if (internalMemo != null) ...[
        ListTile(
          title: Text(AppLocalizations.of(context)!.note),
          subtitle: Text(internalMemo),
        ),
      ],
      Divider(),
    ];
  }

  _onTapHandler() {
    setState(() {
      _open = !_open;
    });
  }
}
