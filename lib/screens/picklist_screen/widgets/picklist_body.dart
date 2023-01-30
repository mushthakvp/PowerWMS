import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/main.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/screens/picklist_product_screen/picklist_product_screen.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

filter(String search) => (PicklistLine line) =>
    search == '' || line.product.ean == search || line.product.uid == search;

List<PicklistLine> scanFilter(String search, List<PicklistLine> line) {
  List<PicklistLine> result = [];
  if (search.length == 13) {
    final request = '0$search';
    result = line
        .where((l) => l.product.ean == request || l.product.uid == request)
        .toList();
  }
  if (result.isEmpty) {
    result = line
        .where((l) => l.product.ean == search || l.product.uid == search)
        .toList();
  }
  return result;
}

const blue = Color(0xFF034784);
const white = Colors.white;
final black = Colors.grey[900];

const List<Color?> picklistColors = [
  null,
  Colors.grey,
  Colors.yellow,
  Color(0xFF034784)
];

mixin PicklistStatusDelegate {
  onUpdateStatus(PicklistStatus status);
}

class PicklistBody extends StatefulWidget {
  const PicklistBody(this.lines, this.delegate, {Key? key}) : super(key: key);

  final List<PicklistLine> lines;
  final PicklistStatusDelegate delegate;

  @override
  _PicklistBodyState createState() => _PicklistBodyState();
}

class _PicklistBodyState extends State<PicklistBody> with RouteAware {
  String _search = '';
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      prefs = await SharedPreferences.getInstance();
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Subscribe routeAware
    navigationObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() async {
    setState(() {});
    super.didPopNext();
  }

  @override
  void dispose() {
    // Unsubscribe routeAware
    navigationObserver.unsubscribe(this);
    super.dispose();
  }

  bool isCurrentWarehouse(PicklistLine line) {
    final warehouseId = context.read<SettingProvider>().currentWareHouse?.id;
    final warehouse = context.read<SettingProvider>().currentWareHouse?.name;
    return warehouseId == line.warehouseId || warehouse == line.warehouse;
  }

  _moveToProduct(PicklistLine line, {double? totalStock}) async {
    if (isCurrentWarehouse(line)) {
      {
        await Navigator.of(context).pushNamed(
          PicklistProductScreen.routeName,
          arguments: {
            "line": line,
            "totalStock": totalStock,
          },
        );
      }
    } else {
      final snackBar = SnackBar(
        content: Text(
            AppLocalizations.of(context)!.otherWarehouse(line.warehouse ?? '')),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Column(
          children: [
            ListTile(
              title: BarcodeInput(
                  onParse: (value, barcode) {
                    setState(() {
                      final lineList = scanFilter(value, widget.lines);
                      if (lineList.length == 1) {
                        _moveToProduct(lineList.first);
                      } else {
                        _search = '';
                        if (lineList.isEmpty) {
                          final snackBar = SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.productNotFound),
                            duration: Duration(seconds: 2),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    });
                  },
                  onBarCodeChanged: (String barcode) {},
                  willShowKeyboardButton: false),
            ),
            Divider(),
          ],
        ),
        Consumer<ValueNotifier<Settings>>(builder: (_, value, __) {
          final lines = widget.lines;
          final settings = value.value;
          lines.asMap().forEach((index, line) {
            lines[index].priority =
                line.getPriority(context, prefs, this.isCurrentWarehouse(line));
          });
          if (lines
              .where(
                  (element) => element.priority == 0 || element.priority == 1)
              .toList()
              .isEmpty) {
            widget.delegate.onUpdateStatus(PicklistStatus.picked);
            if (lines.isNotEmpty) {
              context.read<PicklistRepository>().updatePicklistStatus(
                    lines.first.picklistId,
                    PicklistStatus.picked,
                    false,
                  );
            }
          } else {
            widget.delegate.onUpdateStatus(PicklistStatus.added);
            context.read<StockMutationNeedToProcessProvider>().clearStocks();
            if (lines.isNotEmpty) {
              context.read<PicklistRepository>().updatePicklistStatus(
                  lines.first.picklistId, PicklistStatus.added, true);
            }
          }
          switch (settings.picklistSort) {
            case PicklistSortType.warehouseLocation:
              lines.sort((a, b) {
                var aLocation = a.lineLocationCode ?? a.location ?? '';
                var bLocation = b.lineLocationCode ?? b.location ?? '';
                print('====== $aLocation ======= $bLocation');
                var compare = aLocation.compareTo(bLocation);
                // In case warehouse location is similar
                if (compare == 0) {
                  return a.product.uid.compareTo(b.product.uid);
                }
                return compare;
              });
              break;
            case PicklistSortType.productNumber:
              lines.sort((a, b) => a.product.uid.compareTo(b.product.uid));
              break;
            case PicklistSortType.description:
              lines.sort((a, b) => (a.product.description ?? '')
                  .compareTo(b.product.description ?? ''));
              break;
          }
          // Sort on priority
          lines.sort((a, b) => a.priority.compareTo(b.priority));
          Widget getWidget(bool isFinishAtBottom) {
            var children = lines
                .where(
                    (e) => isFinishAtBottom ? e.priority <= 1 : e.priority > 1)
                .where(filter(_search))
                .map((line) {
              // print(line.product.description);
              // print(line.priority);
              // print(line.product.id);
              // print(line.id);
              // print("Pick Amount: " + line.pickAmount.toString());
              // print("Picked Amount: " + line.pickedAmount.toString());
              // print(line.isFullyPicked());
              //
              // print(isFinishAtBottom);
              // print("---------------------");
              // var key = Key(line.product.id.toString());
              var bgColor = picklistColors[line.priority];
              var fullyPicked = bgColor == blue;
              if (prefs == null) {
                return Container();
              } else {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        double totalStock = lines
                            .where((element) =>
                                element.product.id == line.product.id)
                            .toList()
                            .fold(
                                0,
                                (previousValue, element) =>
                                    (previousValue).toDouble() +
                                    element.pickAmount.toDouble());
                        await _moveToProduct(line, totalStock: totalStock);
                      },
                      child: Container(
                          height: 80,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          key: UniqueKey(),
                          color:
                              !isCurrentWarehouse(line) ? Colors.grey : bgColor,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProductImage(
                                line.product.id,
                                width: 60,
                              ),
                              Gap(16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (line.lineLocationCode?.isNotEmpty ??
                                        line.location?.isNotEmpty ??
                                        false)
                                      Text(
                                        line.lineLocationCode ??
                                            line.location ??
                                            '',
                                        style: TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w600,
                                          color: fullyPicked ? white : black,
                                        ),
                                      ),
                                    Text(
                                      line.product.uid,
                                      style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w600,
                                        color: fullyPicked ? white : black,
                                      ),
                                    ),
                                    if (line.product.description != null)
                                      Text(
                                        line.product.description!,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: fullyPicked ? white : black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    Text(
                                      '${line.pickAmount} (${line.product.unit})',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: fullyPicked ? white : black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: fullyPicked ? white : black,
                              ),
                            ],
                          )),
                    ),
                    Divider(
                      height: 0,
                      color: fullyPicked ? blue : Colors.black,
                    ),
                  ],
                );
              }
            }).toList();
            return Column(
              children: <Widget>[
                if (children.isNotEmpty)
                  Container(
                    child: Text(
                      isFinishAtBottom ? 'To Pick' : 'Picked',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: black,
                      ),
                    ),
                    padding:
                        EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                    alignment: Alignment.centerLeft,
                  ),
                ...children
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getWidget(true),
              getWidget(false),
              Gap(36),
            ],
          );
        }),
      ],
    );
  }
}

extension PicklistLineColor on PicklistLine {
  List<StockMutationItem> _getIdleAmount(
      SharedPreferences? prefs, PicklistLine line) {
    final json = prefs?.getString('${line.id}');
    if (json != null) {
      final res = (jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList();
      return res;
    } else {
      return [];
    }
  }

  int? getBackorderCancelProductAmount(
      SharedPreferences? prefs, PicklistLine line) {
    final cKey = '${line.id}_${line.product.id}';
    int? cAmount = prefs?.getInt(cKey);
    final bKey = '${line.id}_${line.product.id}_backorder';
    int? bAmount = prefs?.getInt(bKey);
    return cAmount ?? bAmount;
  }

  // 0 - none background
  // 1 - grey
  // 2 - yellow
  // 3 - blue
  int getPriority(
    BuildContext context,
    SharedPreferences? prefs,
    bool isCurrentWarehouse,
  ) {
    // if (!isCurrentWarehouse) {
    //   return 1;
    // }

    // case 2: pickAmount = the amount of process product
    List<StockMutationItem> idleList = _getIdleAmount(prefs, this);
    print("**********");
    print(idleList.length);
    if (idleList.length > 0) {
      context
          .read<StockMutationNeedToProcessProvider>()
          .changePendingMutation(isPending: true);
      print(idleList.first.warehouse);
      print(idleList.first.status.toString());
    }
    print("**********");

    // case 1: the pickAmount == pickedAmount
    if (this.isFullyPicked()) {
      return 3;
    }
    if (idleList.isNotEmpty) {
      if (this.pickAmount >= 0 &&
          this.pickAmount <=
              idleList.map((e) => e.amount).toList().fold(0, (p, c) => p + c)) {
        return 3;
      }
    }
    if (idleList.isNotEmpty) {
      context
          .read<StockMutationNeedToProcessProvider>()
          .addStock(StockMutation(warehouseId, picklistId, id, true, idleList));
    }
    // case 3: pickAmount = the amount of process product + picked amount + cancelled amount
    int? cancelBackorderProductAmount =
        getBackorderCancelProductAmount(prefs, this);
    if (cancelBackorderProductAmount != null) {
      if (idleList.isNotEmpty) {
        if (cancelBackorderProductAmount +
                this.pickedAmount +
                (idleList
                    .map((e) => e.amount)
                    .toList()
                    .fold(0, (p, c) => p + c)) ==
            this.pickAmount) {
          return 2;
        }
      } else {
        if (cancelBackorderProductAmount + this.pickedAmount ==
            this.pickAmount) {
          return 2;
        }
      }
    }
    return 0;
  }
}
