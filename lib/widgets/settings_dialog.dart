import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/warehouse.dart';
import 'package:scanner/providers/settings_provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingProvider>().getSettingInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Material(
      color: Colors.white,
      child: Consumer<SettingProvider>(
          builder: (context, provider, _) {
            if (provider.settingsRemote == null) {
              return Center(child: CircularProgressIndicator());
            }
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
                                    AppLocalizations.of(context)!.settings,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  width: 32,
                                  height: 32,
                                  child: InkWell(
                                    child: Icon(Icons.close),
                                    onTap: () async {
                                      Navigator.of(context).pop();
                                      await provider.getSettingInfo();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              height: 1,
                              color: Colors.grey,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  right: 16
                              ),
                              child: Text(
                                provider.getUserInfoName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                  color: Colors.blueAccent
                                ),
                              )
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              height: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              AppLocalizations.of(context)!.defaultWarehouse,
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 8,
                                  right: 100
                              ),
                              child: SettingsWareHouses(
                                  warehouses: provider.warehouses ?? [],
                                  currentWarehouse: provider.currentWareHouse),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 24),
                              height: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              AppLocalizations.of(context)!.sortPicklistlinesOn,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 8,
                                  right: 100
                              ),
                              child: SettingsPicklistSorting(
                                  picklistSortType: provider.picklistSortType()
                              ),
                            ),
                            /*
                            SwitchListTile(
                              title: Text('Finished lines at the bottom'),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.finishedProductsAtBottom,
                              onChanged: (value) {
                                provider.setFinishedProductsAtBottom(value);
                              },
                            ),
                             */
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 24),
                              height: 1,
                              color: Colors.grey,
                            ),
                            Text(
                              AppLocalizations.of(context)!.processing,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SwitchListTile(
                              title: Text(AppLocalizations.of(context)!.oneScanPicksAll),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.oneScanPickAll,
                              onChanged: (value) {
                                provider.setOneScanPickAll(value);
                              },
                            ),
                            SwitchListTile(
                              title:
                              Text(AppLocalizations.of(context)!.directMutation),
                              controlAffinity: ListTileControlAffinity.leading,
                              value: provider.directProcessing,
                              onChanged: (value) {
                                provider.setDirectProcessing(value);
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
                  )
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.all(32),
                child: ElevatedButton(
                  child: Text(AppLocalizations.of(context)!.save),
                  onPressed: () async {
                    context.read<ValueNotifier<Settings>>().value = provider.settingsLocal;
                    await provider.saveSettingInfo();
                    await Future.delayed(Duration(milliseconds: 500), () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ),
            );
          }
      ),
    );
  }
}

class SettingsWareHouses extends StatelessWidget {
  const SettingsWareHouses({
    required this.warehouses,
    required this.currentWarehouse,
    Key? key}) : super(key: key);

  final List<Warehouse> warehouses;
  final Warehouse? currentWarehouse;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<Warehouse>(
        value: currentWarehouse,
        alignment: AlignmentDirectional.bottomStart,
        elevation: 8,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        onChanged: (value) {
          if (value != null) {
            context.read<SettingProvider>().setCurrentWarehouse(value);
          }
        },
        items: warehouses
            .map<DropdownMenuItem<Warehouse>>((Warehouse value) {
          return DropdownMenuItem<Warehouse>(
            value: value, child: Text(
            value.name ?? 'Loading', style: TextStyle(fontWeight: FontWeight.w500,
              fontSize: 15)),
          );
        }).toList(),
      ),
    );
  }
}

class SettingsPicklistSorting extends StatelessWidget {
  const SettingsPicklistSorting({
    required this.picklistSortType,
    Key? key}) : super(key: key);

  final PicklistSortType? picklistSortType;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<PicklistSortType>(
        value: picklistSortType,
        alignment: AlignmentDirectional.center,
        elevation: 8,
        style: const TextStyle(color: Colors.black),
        underline: Container(
          height: 0,
          color: Colors.transparent,
        ),
        onChanged: (value) {
          if (value != null) {
            context.read<SettingProvider>().setCurrentPicklistSorting(value);
          }
        },
        items: PicklistSortType.values
            .map<DropdownMenuItem<PicklistSortType>>((PicklistSortType value) {
          return DropdownMenuItem<PicklistSortType>(
            value: value,
            child: Text(value.title(context), style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          );
        }).toList(),
      ),
    );
  }
}