import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:scanner/l10n/app_localizations.dart';
import 'package:scanner/main.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/screens/home_screen/widgets/grid_item.dart';
import 'package:scanner/screens/log_screen/log_screen.dart';
import 'package:scanner/screens/picklist_home_screen/picklists_home_screen.dart';
import 'package:scanner/screens/products_screen/products_screen.dart';
import 'package:scanner/screens/serial_number_homescreen/seriel_number_home_screen.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  List<Map<String, dynamic>> items = [
    {
      'title': (context) => AppLocalizations.of(context)!.products,
      'icon': Icons.inventory_2,
      'route': ProductsScreen.routeName,
    },
    {
      'title': (context) => AppLocalizations.of(context)!.warehouseReceipts,
      'icon': Icons.list_alt,
      'route': PicklistsScreen.routeName,
    },

    // {
    //   'title': (context) => AppLocalizations.of(context)!.count,
    //   'icon': Icons.leaderboard_rounded,
    //   'route': PicklistsScreen.routeName,
    // }
  ];

  _getSettingInfo() async {
    await Future.wait([
      context.read<SettingProvider>().getApiInfo(),
      context.read<SettingProvider>().getSettingInfo(),
      context.read<SettingProvider>().getWarehouses(),
      context.read<SettingProvider>().getUserInfo(),
    ]);
    if (mounted) {
      context.read<ValueNotifier<Settings>>().value =
          context.read<SettingProvider>().settingsLocal;
      addSerialNumber();
    }
  }

  addSerialNumber() {
    if (items.length < 3 &&
        (context.read<SettingProvider>().apiSettings?.apiSettings?.first.type ??
                2) ==
            1) {
      items.add(
        {
          'title': (context) => AppLocalizations.of(context)!.serial_numbers,
          'icon': Icons.barcode_reader,
          'route': SerialNumberHomeScreen.routeName,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await UserLatestSession.shared.startTimer();
      await _getSettingInfo();
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
    await _getSettingInfo();
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
    return Scaffold(
      appBar: WMSAppBar(
        context.watch<SettingProvider>().userInfo?.firstName ?? '    ',
        leading: IconButton(
          onPressed: () async {
            await Navigator.of(context).pushNamed(SettingsDialog.routeName);
            addSerialNumber();
          },
          icon: Icon(Icons.settings),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(AppLocalizations.of(context)!.dashboard),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2.5,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return GridItem(
                    item['title'](context),
                    item['icon'],
                    onTap: () {
                      Navigator.pushNamed(context, item['route']);
                    },
                  );
                },
                childCount: items.length,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/images/logo_blue.png', height: 34),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            'Version ${snapshot.data?.version}+${snapshot.data?.buildNumber}');
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ),
            ListTile(
              title: Text('Logs'),
              onTap: () {
                Navigator.of(context).pushNamed(LogScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
