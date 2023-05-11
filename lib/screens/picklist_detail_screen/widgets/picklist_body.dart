import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/main.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/providers/stockmutation_needto_process_provider.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/picklist_color_extension.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/picklist_colors.dart';
import 'package:scanner/screens/picklist_detail_screen/picklist_utilities/picklist_services.dart';
import 'package:scanner/screens/picklist_product_screen/picklist_product_screen.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        Consumer<ValueNotifier<Settings>>(builder: (_, settingsValue, __) {
          final lines = widget.lines;
          final settings = settingsValue.value;

          _updateLinesPriority(lines, prefs, this.isCurrentWarehouse);
          _sortLinesBasedOnPriority(lines);
          _sortLinesBasedOnSettings(lines, settings.picklistSort);

          PicklistStatus status;
          if (_isPicklistStatusPicked(lines)) {
            status = PicklistStatus.picked;
          } else {
            status = PicklistStatus.added;
            context.read<StockMutationNeedToProcessProvider>().clearStocks();
          }
          widget.delegate.onUpdateStatus(status);
          if (lines.isNotEmpty) {
            context.read<PicklistRepository>().updatePicklistStatus(
                lines.first.picklistId, status, status == PicklistStatus.added);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              PicklistWidget(true, lines, _search, prefs, _moveToProduct,
                  isCurrentWarehouse),
              PicklistWidget(false, lines, _search, prefs, _moveToProduct,
                  isCurrentWarehouse),
              Gap(36),
            ],
          );
        }),
      ],
    );
  }

  void _updateLinesPriority(List<PicklistLine> lines, SharedPreferences? prefs,
      Function isCurrentWarehouse) {
    lines.asMap().forEach((index, line) {
      lines[index].priority =
          line.getPriority(context, prefs, isCurrentWarehouse(line));
    });
  }

  void _sortLinesBasedOnPriority(List<PicklistLine> lines) {
    lines.sort((a, b) => a.priority.compareTo(b.priority));
  }

  void _sortLinesBasedOnSettings(
      List<PicklistLine> lines, PicklistSortType sortType) {
    switch (sortType) {
      case PicklistSortType.warehouseLocation:
        lines.sort((a, b) {
          var aLocation = a.lineLocationCode ?? a.location ?? '';
          var bLocation = b.lineLocationCode ?? b.location ?? '';
          var compare = aLocation.compareTo(bLocation);
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
  }

  bool _isPicklistStatusPicked(List<PicklistLine> lines) {
    return lines
        .where((element) => element.priority == 0 || element.priority == 1)
        .isEmpty;
  }
}

class PicklistWidget extends StatelessWidget {
  final bool isFinishAtBottom;
  final List<PicklistLine> lines;
  final String search;
  final SharedPreferences? prefs;
  final Function moveToProduct;
  final Function isCurrentWarehouse;

  PicklistWidget(this.isFinishAtBottom, this.lines, this.search, this.prefs,
      this.moveToProduct, this.isCurrentWarehouse);

  @override
  Widget build(BuildContext context) {
    var filteredLines = lines
        .where((e) => isFinishAtBottom ? e.priority <= 1 : e.priority > 1)
        .where(filter(search));

    var children = filteredLines.map((line) {
      return _buildLineWidget(line);
    }).toList();

    return Column(
      children: [
        if (!isFinishAtBottom)
          Divider(
            thickness: 1,
            height: 32,
          ),
        Container(
          margin: const EdgeInsets.all(8  ),
          decoration: BoxDecoration(
            border: Border.all(),
            color: isFinishAtBottom ? blue.withOpacity(0.1) : Colors.grey,
          ),
          child: Column(
            children: <Widget>[
              if (children.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    color:
                        isFinishAtBottom ? blue.withOpacity(0.2) : Colors.grey,
                  ),
                  child: Text(
                    isFinishAtBottom
                        ? 'To Pick (${filteredLines.length}/${lines.length})'
                        : 'Picked (${filteredLines.length}/${lines.length})',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: black,
                    ),
                  ),
                  padding:
                      EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
                  alignment: Alignment.centerLeft,
                ),
              ...children
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineWidget(PicklistLine line) {
    var bgColor = picklistColors[line.priority];
    var fullyPicked = bgColor == blue;

    if (prefs == null) {
      return Container();
    } else {
      log(line.toJson().toString());
      return Column(
        children: [
          InkWell(
            onTap: () async {
              double totalStock = lines
                  .where((element) => element.product.id == line.product.id)
                  .toList()
                  .fold(
                      0,
                      (previousValue, element) =>
                          (previousValue).toDouble() +
                          element.pickAmount.toDouble());
              await moveToProduct(line, totalStock: totalStock);
            },
            child: _buildLineContent(line, bgColor, fullyPicked),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: !fullyPicked ? blue : Colors.black,
            child: _buildLineFooter(line),
          ),
          Divider(
            height: 0,
            color: fullyPicked ? blue : Colors.black,
          ),
        ],
      );
    }
  }

  Widget _buildLineContent(
      PicklistLine line, Color? bgColor, bool fullyPicked) {
    return Container(
        height: 100,
        padding: EdgeInsets.symmetric(horizontal: 16),
        key: UniqueKey(),
        color: !isCurrentWarehouse(line) ? Colors.grey : bgColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    line.lineLocationCode ?? line.location ?? '',
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w600,
                      color: white,
                    ),
                  ),
                ),
                Text(
                  '${line.pickAmount} (${line.product.unit})',
                  style: TextStyle(
                    fontSize: 13,
                    color: fullyPicked ? white : black,
                  ),
                ),
                Text(
                  '${line.pickedAmount}',
                  style: TextStyle(
                    fontSize: 13,
                    color: fullyPicked ? white : black,
                  ),
                ),
              ],
            )),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      line.product.description ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        color: fullyPicked ? white : black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      line.product.uid,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: fullyPicked ? white : black,
                      ),
                    ),
                    Text(
                      line.product.ean ?? "-",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: fullyPicked ? white : black,
                      ),
                    ),
                    Text(
                      line.product.batchField?.toString() ?? "-",
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.bold,
                        color: fullyPicked ? white : black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(16),
            ProductImage(
              line.product.id,
              width: 60,
            ),
            Icon(
              Icons.chevron_right,
              color: fullyPicked ? white : black,
            ),
          ],
        ));
  }

  Widget _buildLineFooter(PicklistLine line) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text(
              line.pickedAmount.toString(),
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: white,
              ),
            ),
            Text(
              " (STK)",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: white,
              ),
            ),
          ],
        ),
        Text(
          "|",
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        Text(
          line.product.batchField.toString(),
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        Text(
          "|",
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        Text(
          line.product.id.toString(),
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
      ],
    );
  }
}
