import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/repository/serial_number_repository.dart';
import 'package:scanner/util/color_const.dart';
import 'package:scanner/util/extensions/text_style_ext.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/custom_button.dart';
import 'package:scanner/widgets/dialogs/custom_alert_box.dart';
import 'package:scanner/widgets/dialogs/custom_snack_bar.dart';
import 'package:scanner/widgets/text_field_outlined.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class SerialNumberHomeScreen extends StatefulWidget {
  static const routeName = '/serial_number_home';

  const SerialNumberHomeScreen({Key? key}) : super(key: key);

  @override
  State<SerialNumberHomeScreen> createState() => _SerialNumberHomeScreenState();
}

class _SerialNumberHomeScreenState extends State<SerialNumberHomeScreen> {
  bool isContinuousScan = false;
  List<String> serialNumberList = [];
  late SerialNumberRepository serialNumberRepository;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    serialNumberRepository = context.read<SerialNumberRepository>();
    serialNumberRepository.getSerialNumberList().then((value) {
      serialNumberList.addAll(value);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WMSAppBar(
        AppLocalizations.of(context)!.add_serial_numbers,
        elevation: 1,
        leading: BackButton(),
        isShowLogo: false,
      ),
      bottomNavigationBar: serialNumberList.length != 0
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppButton(
                buttonColor: AppColors.primary,
                onPressed: () async {
                  var linNumber;
                  var receiptCode;
                  bool isComplete = await CustomAlertBox.showStateFulAlertBox(
                    context,
                    onConfirm: (value) async {
                      if (_formKey.currentState!.validate()) {
                        value.changeLoading();
                        bool? isComplete = await context
                            .read<SettingProvider>()
                            .postSerialNumbers(
                              serialNumberList: serialNumberList,
                              receiptCode: receiptCode,
                              lineNumber: linNumber,
                            );
                        Navigator.pop(context, isComplete);
                      }
                    },
                    message: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            label:
                                Text(AppLocalizations.of(context)!.receiptCode),
                            color: AppColors.grey50,
                            initialValue: "",
                            maxLines: 1,
                            isFilled: true,
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'required'),
                            ]),
                            onChanged: (value) {
                              receiptCode = (value);
                            },
                          ),
                          Gap(12),
                          CustomTextField(
                            color: AppColors.grey50,
                            maxLines: 1,
                            label: Text(AppLocalizations.of(context)!
                                .receiptLineNumber),
                            initialValue: "1",
                            validator: MultiValidator([
                              RequiredValidator(errorText: 'required'),
                            ]),
                            isFilled: true,
                            onChanged: (value) {
                              linNumber = int.tryParse(value) ?? 1;
                            },
                          ),
                        ],
                      ),
                    ),
                    title: AppLocalizations.of(context)!.whole_sale_data,
                  );
                  if (isComplete) {
                    CustomSnackBar.showSnackBar(context, title: "Success");
                    serialNumberList.clear();
                    serialNumberRepository.clearCache();
                    setState(() {});
                  } else {
                    CustomSnackBar.showSnackBar(context,
                        title: "Something went wrong!");
                  }
                },
                title: "Toevoegen aan ontvangst",
                radius: 8,
              ),
            )
          : SizedBox(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: AppColors.grey.withOpacity(0.3),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 9))
            ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 8),
                  child: BarcodeInput(
                    onParse: (value, barcode) {
                      serialNumberList.insert(0, value);
                      serialNumberRepository
                          .addSerialNumberList(serialNumberList);
                      setState(() {});
                    },
                    onBarCodeChanged: (String barcode) {},
                    willShowKeyboardButton: false,
                  ),
                ),
                CheckboxListTile(
                  value: isContinuousScan,
                  onChanged: (value) {
                    isContinuousScan = value!;
                    // _homeProvider.saveContinueScannerAndReturn(
                    //   isContinues: isContinuousScan!,
                    //   isReturn: goodsReturn!,
                    // );
                    setState(() {});
                  },
                  title: Text(
                    "Continu scanner",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  visualDensity:
                      const VisualDensity(horizontal: -4.0, vertical: -1),
                  dense: true,
                  checkboxShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 2,
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: const EdgeInsets.only(
                    left: 6,
                  ),
                ),
              ],
            ),
          ),
          if (serialNumberList.length != 0)
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 14, bottom: 12),
              child: Text(
                "${AppLocalizations.of(context)!.total_scanned_serial_numbers} : ${serialNumberList.length}",
                style: Theme.of(context).textTheme.bodyLarge?.semiBold.s16,
              ),
            ),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                      height: 1,
                    ),
                itemCount: serialNumberList.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (value) {
                      serialNumberRepository.deleteProduct(
                          serialNumber: serialNumberList[index]);
                      serialNumberList.remove(serialNumberList[index]);
                      setState(() {});
                    },
                    background: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text((index + 1).toString() + "."),
                      ),
                      title: Text(
                        serialNumberList[index],
                        style:
                            Theme.of(context).textTheme.bodyLarge?.normal.s18,
                      ),
                      tileColor: AppColors.grey.withOpacity(0.3),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
