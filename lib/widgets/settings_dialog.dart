import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/settings.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  PicklistSort? _picklistSort;
  bool? _finishedProductsAtBottom;
  bool? _oneScanPickAll;
  bool? _directlyProcess;

  @override
  void initState() {
    final settings = context.read<ValueNotifier<Settings>>().value;
    _picklistSort = settings.picklistSort;
    _finishedProductsAtBottom = settings.finishedProductsAtBottom;
    _oneScanPickAll = settings.oneScanPickAll;
    _directlyProcess = settings.directlyProcess;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return AlertDialog(
      title: const Text('Settings'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListBody(
            children: <Widget>[
              const Text(
                'Picklist screen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              RadioListTile<PicklistSort>(
                title: const Text('Sort on product number'),
                value: PicklistSort.productNumber,
                groupValue: _picklistSort,
                onChanged: (value) {
                  setState(() {
                    _picklistSort = value;
                  });
                },
              ),
              RadioListTile<PicklistSort>(
                title: const Text('Sort on warehouse location'),
                value: PicklistSort.warehouseLocation,
                groupValue: _picklistSort,
                onChanged: (value) {
                  setState(() {
                    _picklistSort = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Finished products at bottom'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _finishedProductsAtBottom!,
                onChanged: (value) {
                  setState(() {
                    _finishedProductsAtBottom = value;
                  });
                },
              ),
              const Text(
                'Product screen',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: Text('One scan pick all'),
                controlAffinity: ListTileControlAffinity.leading,
                value: _oneScanPickAll!,
                onChanged: (value) {
                  setState(() {
                    _oneScanPickAll = value;
                  });
                },
              ),
              SwitchListTile(
                title:
                    Text(AppLocalizations.of(context)!.settingsDirectlyProcess),
                controlAffinity: ListTileControlAffinity.leading,
                value: _directlyProcess!,
                onChanged: (value) {
                  setState(() {
                    _directlyProcess = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            var settings = Settings(
              picklistSort: _picklistSort ?? PicklistSort.productNumber,
              finishedProductsAtBottom: _finishedProductsAtBottom ?? false,
              oneScanPickAll: _oneScanPickAll ?? true,
              directlyProcess: _directlyProcess ?? false,
            );
            settings.save();
            context.read<ValueNotifier<Settings>>().value = settings;
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
