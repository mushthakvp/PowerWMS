import 'package:flutter/material.dart';
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
    return SliverList(
        delegate: SliverChildListDelegate(
      [
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
      ],
    ));
  }

  _address() {
    return [
      ListTile(
        title: Text(widget._picklist.debtor.address ?? ''),
      ),
      Divider(),
    ];
  }

  _onTapHandler() {
    setState(() {
      _open = !_open;
    });
  }
}
