import 'package:flutter/material.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/warehouse.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/custom_button.dart';
import 'package:scanner/widgets/dialogs/custom_alert_box.dart';
import 'package:scanner/widgets/text_field_with_title.dart';

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
      child: Consumer<SettingProvider>(builder: (context, provider, _) {
        if (provider.settingsRemote == null) {
          return Center(child: CircularProgressIndicator());
        }
        return WillPopScope(
          onWillPop: () async {
            await provider.getSettingInfo();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(24),
                children: [
                  Text(
                    provider.getUserInfoName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ).primaryColor,
                  ),
                  Gap(12),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Gap(16),
                  Text(
                    AppLocalizations.of(context)!.defaultWarehouse,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SettingsWareHouses(
                      warehouses: provider.warehouses ?? [],
                      currentWarehouse: provider.currentWareHouse),
                  Gap(4),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Gap(16),
                  Text(
                    AppLocalizations.of(context)!.sortPicklistlinesOn,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SettingsPicklistSorting(
                      picklistSortType: provider.picklistSortType()),
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
                  Gap(4),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Gap(16),
                  Text(
                    AppLocalizations.of(context)!.processing,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Gap(8),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.oneScanPicksAll),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: provider.oneScanPickAll,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      provider.setOneScanPickAll(value);
                    },
                  ),
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.directMutation),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: provider.directProcessing,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      provider.setDirectProcessing(value);
                    },
                  ),
                  Gap(4),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Gap(16),
                  AppButton(
                    onPressed: () {
                      WholeSaleSettings wholeSaleSettings = WholeSaleSettings();
                      if (provider.wholeSaleSettings != null)
                        wholeSaleSettings = provider.wholeSaleSettings!;
                      CustomAlertBox.showAlertBox(context,
                          title: "Update Wholesale Api",
                          confirmText: "Update",
                          message: Column(
                            children: [
                              TextFieldWithTitle(
                                initialValue:
                                    provider.wholeSaleSettings?.server,
                                title: "Server",
                                onChanged: (value) {
                                  wholeSaleSettings.server = value;
                                },
                              ),
                              TextFieldWithTitle(
                                initialValue: provider.wholeSaleSettings?.admin,
                                title: "Admin",
                                onChanged: (value) {
                                  wholeSaleSettings.admin = value;
                                },
                              ),
                              TextFieldWithTitle(
                                initialValue:
                                    provider.wholeSaleSettings?.userName,
                                title: "Username",
                                onChanged: (value) {
                                  wholeSaleSettings.userName = value;
                                },
                              ),
                              TextFieldWithTitle(
                                initialValue:
                                    provider.wholeSaleSettings?.password,
                                title: "Password",
                                onChanged: (value) {
                                  wholeSaleSettings.password = value;
                                },
                              )
                            ],
                          ), onConfirm: () async {
                        print("wholeSaleSettings.toJson()");
                        print(wholeSaleSettings.toJson());
                        provider.wholeSaleSettings = wholeSaleSettings;
                        context.read<ValueNotifier<Settings>>().value =
                            provider.settingsLocal;
                        await provider.saveSettingInfo();
                        Navigator.pop(context);
                      });
                    },
                    buttonColor: AppColors.black,
                    title: "Update WholeSale Api",
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: AppButton(
                buttonColor: AppColors.primary,
                title: (AppLocalizations.of(context)!.save),
                onPressed: () async {
                  context.read<ValueNotifier<Settings>>().value =
                      provider.settingsLocal;
                  await provider.saveSettingInfo();
                  await Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class SettingsWareHouses extends StatelessWidget {
  const SettingsWareHouses(
      {required this.warehouses, required this.currentWarehouse, Key? key})
      : super(key: key);

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
        items: warehouses.map<DropdownMenuItem<Warehouse>>((Warehouse value) {
          return DropdownMenuItem<Warehouse>(
            value: value,
            child: Text(value.name ?? 'Loading',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          );
        }).toList(),
      ),
    );
  }
}

class SettingsPicklistSorting extends StatelessWidget {
  const SettingsPicklistSorting({required this.picklistSortType, Key? key})
      : super(key: key);

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
            child: Text(value.title(context),
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          );
        }).toList(),
      ),
    );
  }
}
