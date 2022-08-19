import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:scanner/main.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/screens/home_screen/widgets/grid_item.dart';
import 'package:scanner/screens/log_screen/log_screen.dart';
import 'package:scanner/screens/picklists_screen/picklists_screen.dart';
import 'package:scanner/screens/products_screen/products_screen.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

final List<Map<String, dynamic>> items = [
  {
    'title': (context) => AppLocalizations.of(context)!.products,
    'icon': Icons.inventory_2,
    'route': ProductsScreen.routeName,
  },
  {
    'title': (context) => AppLocalizations.of(context)!.warehouseReceipts,
    'icon': Icons.list_alt,
    'route': PicklistsScreen.routeName,
  }
];
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {

  _getSettingInfo() async {
    await context.read<SettingProvider>().getSettingInfo();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
        'Extracom',
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