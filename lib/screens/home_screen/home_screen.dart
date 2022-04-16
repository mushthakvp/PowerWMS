import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info/package_info.dart';
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
  },
  {
    'title': (context) => AppLocalizations.of(context)!.warehouseReceipts,
    'icon': Icons.countertops,
    'route': PicklistsScreen.routeName,
  },
];

class HomeScreen extends StatelessWidget {
  static const routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

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
