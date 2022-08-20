import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/main.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/models/stock_mutation_item.dart';
import 'package:scanner/screens/picklist_product_screen/picklist_product_screen.dart';
import 'package:scanner/widgets/barcode_input.dart';
import 'package:scanner/widgets/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';

filter(String search) => (PicklistLine line) =>
    search == '' || line.product.ean == search || line.product.uid == search;

List<PicklistLine> scanFilter(String search, List<PicklistLine> line) {
  return line
      .where((l) => l.product.ean == search || l.product.uid == search).toList();
}

const blue = Color(0xFF034784);
const white = Colors.white;
final black = Colors.grey[900];

class PicklistBody extends StatefulWidget {
  const PicklistBody(this.lines, {Key? key}) : super(key: key);

  final List<PicklistLine> lines;

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
      setState(() {
      });
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
    setState(() {

    });
    super.didPopNext();
  }

  @override
  void dispose() {
    // Unsubscribe routeAware
    navigationObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              ListTile(
                title: BarcodeInput((value, barcode) {
                  setState(() {
                    final lineList = scanFilter(value, widget.lines);
                    if (lineList.length == 1) {
                      Navigator.of(context).pushNamed(
                          PicklistProductScreen.routeName,
                          arguments: lineList.first);
                    } else {
                      _search = '';
                      if (lineList.isEmpty) {
                        final snackBar = SnackBar(
                          content: Text(AppLocalizations.of(context)!.productNotFound),
                          duration: Duration(seconds: 2),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  });
                }, (String barcode) {}),
              ),
              Divider(),
            ],
          ),
        ),
        Consumer<ValueNotifier<Settings>>(builder: (_, value, __) {
          final lines = widget.lines;
          final settings = value.value;
          if (settings.finishedProductsAtBottom) {
            lines.sort((a, b) {
              print("SORTING: ${a.status}  ${a.location} and $b");
              // return  a.status.name - b.status.name;
              return  a.location == null ? 1:b.location == null ? -1: a.location!.compareTo(b.location!);
            });
          }
          return SliverList(
              delegate: SliverChildListDelegate(
                  lines.where(filter(_search)).map((line) {
                    var key = Key(line.product.id.toString());
                    var bgColor = _getBackgroundColor(line);
                    var fullyPicked = bgColor == blue;
                    if (prefs == null) {
                      return Container();
                    } else {
                      return Column(
                        key: key,
                        children: [
                          ListTile(
                            tileColor: bgColor,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PicklistProductScreen.routeName,
                                  arguments: line);
                            },
                            leading: ProductImage(
                              line.product.id,
                              width: 60,
                              key: key,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (line.location != null)
                                  Text(
                                    line.location!,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                      color: fullyPicked ? white : black,
                                    ),
                                  ),
                                Text(
                                  line.product.uid,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: fullyPicked ? white : black,
                                  ),
                                ),
                                if (line.product.description != null)
                                  Text(
                                    line.product.description!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: fullyPicked ? white : black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                Text(
                                  '${line.pickAmount} (${line.product.unit})',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: fullyPicked ? white : black,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: fullyPicked ? white : black,
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: fullyPicked ? blue : null,
                          ),
                        ],
                      );
                    }
                  }).toList()));
        }),
      ],
    );
  }

  List<StockMutationItem> _getIdleAmount(PicklistLine line) {
    final json = prefs?.getString('${line.id}');
    if (json != null) {
      return (jsonDecode(json) as List<dynamic>)
          .map((json) => StockMutationItem.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  int? getCancelProductAmount(PicklistLine line) {
    final key = '${line.id}_${line.product.id}';
    return prefs?.getInt(key);
  }

  Color? _getBackgroundColor(PicklistLine line) {
    // case 1: the pickAmount == pickedAmount
    if (line.isFullyPicked()) {
      return blue;
    }
    // case 2: pickAmount = the amount of process product
    List<StockMutationItem> idleList = _getIdleAmount(line);
    if (idleList.isNotEmpty) {
      if (line.pickAmount >= 0 && line.pickAmount <= idleList
          .map((e) => e.amount)
          .toList()
          .fold(0, (p, c) => p + c)) {
        return blue;
      }
    }

    int? cancelProductAmount = getCancelProductAmount(line);
    if (cancelProductAmount != null) {
      if (idleList.isNotEmpty) {
        if (cancelProductAmount + line.pickedAmount + (idleList.first.amount ?? 0)
            == line.pickAmount) {
          return Colors.yellow;
        }
      } else {
        if (cancelProductAmount + line.pickedAmount
            == line.pickAmount) {
          return Colors.yellow;
        }
      }
    }
    return null;
  }
}