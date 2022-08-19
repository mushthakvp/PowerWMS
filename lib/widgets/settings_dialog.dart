import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);
  static const routeName = '/settings';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingProvider>().getSettingInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.all(24),
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Settings',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 16),
                    height: 1,
                    color: Colors.grey,
                  ),
                  Text(
                    'Default warehouse',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Consumer<SettingProvider>(
                      builder: (context, provider, _) {
                        return Container(
                          margin: EdgeInsets.only(top: 16, bottom: 8, left: 16),
                          child: Text(
                            provider.settingsRemote == null
                                ? 'Loading'
                                : '${provider.settingsRemote!.warehouseId!}',
                            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                        );
                      }
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 24),
                    height: 1,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Picklist screen',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 24),
                    height: 1,
                    color: Colors.grey,
                  ),
                  const Text(
                    'Product screen',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                  Container(
                    margin: EdgeInsets.only(top: 16, bottom: 32),
                    height: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(32),
        child: ElevatedButton(
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
      ),
    );
  }
}
