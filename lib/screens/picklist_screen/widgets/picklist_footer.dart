import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/providers/complete_picklist_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PicklistFooter extends StatefulWidget {
  const PicklistFooter(this.picklist, {Key? key}) : super(key: key);

  final Picklist picklist;

  @override
  State<PicklistFooter> createState() => _PicklistFooterState();
}

class _PicklistFooterState extends State<PicklistFooter> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletePicklistProvider>(
      builder: (context, provider, _) {
        return ListTile(
          visualDensity: VisualDensity.compact,
          title: ElevatedButton(
              child: Text(AppLocalizations.of(context)!
                  .complete
                  .toUpperCase()),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue
                ),
              ),
              onPressed: () async {
                var error = await provider.completePicklist(widget.picklist.id);
                if (error == null) {
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('An Error Occurred!'),
                      content: Text(error),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                        )
                      ],
                    ),
                  );
                }
              }
          ),
        );
      },
    );
  }
}
