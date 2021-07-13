import 'package:f_logs/f_logs.dart';
import 'package:flutter/material.dart';

class LogTile extends StatefulWidget {
  const LogTile(this.log, {Key? key}) : super(key: key);

  final Log log;

  @override
  _LogTileState createState() => _LogTileState();
}

class _LogTileState extends State<LogTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    return Column(
      children: [
        ListTile(
          title: Text(log.exception ?? '-'),
          subtitle: Text(log.text ?? '-'),
          trailing: IconButton(
            icon: Icon(_open ? Icons.expand_less : Icons.expand_more),
            onPressed: () {
              setState(() {
                _open = !_open;
              });
            },
          ),
        ),
        if (_open)
          ListTile(
            title: Text(log.stacktrace ?? ''),
          ),
      ],
    );
  }
}
