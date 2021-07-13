import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/screens/home_screen/widgets/grid_item.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

final List<Map<String, dynamic>> items = [
  {
    'title': (context) => AppLocalizations.of(context)!.products,
    'icon': Icons.inventory_2,
    'route': '/products',
  },
  {
    'title': (context) => AppLocalizations.of(context)!.warehouseReceipts,
    'icon': Icons.list_alt,
    'route': '/picklists',
  },
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WMSAppBar(
        'Extracom',
        context: context,
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
            ListTile(
              title: Text('Logs'),
              onTap: () {
                Navigator.of(context).pushNamed('/logs');
              },
            ),
          ],
        ),
      ),
    );
  }
}
