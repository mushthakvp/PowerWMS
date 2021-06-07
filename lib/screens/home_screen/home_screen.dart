import 'package:flutter/material.dart';
import 'package:scanner/screens/home_screen/widgets/grid_item.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

final List<Map<String, dynamic>> items = [
  {
    'title': 'Producten',
    'icon': Icons.inventory_2,
    'route': '/picklists',
  },
  {
    'title': 'Klanten',
    'icon': Icons.inventory_2,
    'route': '/picklists',
  },
  {
    'title': 'Voorraadmutaties',
    'icon': Icons.point_of_sale,
    'route': '/picklists',
  },
  {
    'title': 'Magazijnbonnen',
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
        context: context,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text('Dashboard'),
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
                    item['title'],
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
      drawer: Drawer(),
    );
  }
}
