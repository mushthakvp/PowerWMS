import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/providers/add_product_provider.dart';
import 'package:scanner/providers/mutation_provider.dart';
import 'package:scanner/screens/picklist_product_screen/parse_handler_service.dart';
import 'package:scanner/widgets/barcode_input.dart';

final audio = Audio('assets/error.mp3');

class ScanForm extends StatelessWidget {
  const ScanForm({required this.onParse, Key? key}) : super(key: key);

  final void Function(bool proceed) onParse;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MutationProvider?>()!;
    final formKey = GlobalKey<FormState>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: Form(
        key: formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Selector<AddProductProvider, bool>(
              selector: (_, p) => p.canAdd,
              builder: (context, enable, _) {
                return ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.productAdd.toUpperCase(),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        enable ? Colors.blue : Colors.grey),
                  ),
                  onPressed: provider.needToScan() || !enable
                      ? null
                      : () async {
                          // formKey.currentState?.save();

                          String? ean = parseHandler(
                            context,
                            provider,
                            context.read<AddProductProvider>().value ?? '',
                            null,
                            onParse: onParse,
                          );
                          if (ean == null) {
                            ean = '';
                          }
                          if (ean.length == 13) {
                            String request = '0$ean';
                            try {
                              parseHandler(context, provider, request, null,
                                  onParse: onParse, isThrowError: true);
                            } catch (_) {
                              parseHandler(
                                context,
                                provider,
                                ean,
                                null,
                                onParse: onParse,
                              );
                            }
                          } else {
                            parseHandler(
                              context,
                              provider,
                              ean,
                              null,
                              onParse: onParse,
                            );
                          }
                          context.read<AddProductProvider>().canAdd = false;
                        },
                );
              },
            ),
            Gap(12),
            Expanded(
              child: BarcodeInput(
                  onParse: (value, barcode) async {
                    // formKey.currentState?.save();

                    // String? ean = _parseHandler(
                    //   context,
                    //   provider,
                    //   context.read<AddProductProvider>().value ?? '',
                    //   null,
                    // );
                    // if (ean == null) {
                    //   ean = '';
                    // }
                    // if (ean.length == 13) {
                    //   print("1");
                    //   String request = '0$ean';
                    //   try {
                    //     print("2");
                    //     _parseHandler(context, provider, request, null,
                    //         isThrowError: true);
                    //   } catch (_) {
                    //     print("3");
                    //     _parseHandler(context, provider, ean, null);
                    //   }
                    // } else {
                    //   print("4");
                    //   _parseHandler(context, provider, ean, null);
                    // }
                    // context.read<AddProductProvider>().canAdd = false;

                    if (!provider.needToScan() || value.length > 0) {
                      if (value.length == 13 && value.substring(0, 1) != "0") {
                        String request = '0$value';
                        try {
                          await parseHandler(
                              context, provider, request, barcode,
                              onParse: onParse, isThrowError: true);
                        } catch (e) {
                          await parseHandler(context, provider, value, barcode,
                              onParse: onParse);
                        }
                      } else {
                        await parseHandler(context, provider, value, barcode,
                            onParse: onParse);
                      }
                      context.read<AddProductProvider>().canAdd = false;
                    }
                  },
                  onBarCodeChanged: (String barcode) {
                    if (barcode.isEmpty) {
                      context.read<AddProductProvider>().canAdd = false;
                      context.read<AddProductProvider>().value = null;
                      return;
                    }
                    bool enableAddButton =
                        provider.line.product.uid == barcode ||
                            provider.line.product.ean == barcode;
                    context.read<AddProductProvider>().canAdd = enableAddButton;
                    context.read<AddProductProvider>().value = barcode;
                  },
                  willShowKeyboardButton: false),
            ),
          ],
        ),
      ),
    );
  }
}
