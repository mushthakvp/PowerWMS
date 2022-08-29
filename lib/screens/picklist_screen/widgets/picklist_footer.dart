import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/providers/complete_picklist_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                var response = await provider.completePicklist(widget.picklist.id);
                if (response?.success == true) {
                  showDialog(
                    context: context,
                    builder: (ctx) => successAlert(
                      ctx,
                      response?.message ?? '',
                      widget.picklist.uid,
                      onPop: () {
                        Navigator.of(context).pop();
                      }
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('An Error Occurred!'),
                      content: Text(response?.message ?? ''),
                      actions: <Widget>[
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
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

  AlertDialog successAlert(
      BuildContext context,
      String mgs,
      String picklistNumber,
      {required VoidCallback onPop}
  ) {
    Widget qrWidget() {
      return Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: QrImage(
              padding: EdgeInsets.zero,
              data: picklistNumber,
              version: QrVersions.auto
          )
      );
    }
    return AlertDialog(
      title: Text(mgs),
      content: qrWidget(),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.ok.toUpperCase()),
          onPressed: () {
            Navigator.of(context).pop();
            onPop();
          },
        )
      ],
    );
  }
}
