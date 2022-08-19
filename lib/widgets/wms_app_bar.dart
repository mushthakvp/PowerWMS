import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/resources/stock_mutation_item_repository.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

Timer? timer;

class WMSAppBar extends StatelessWidget implements PreferredSizeWidget {
  WMSAppBar(
    this.title, {
    Key? key,
    this.bottom,
    double? preferredSize,
  })  : _preferredSize = Size.fromHeight(preferredSize ?? kToolbarHeight),
        super(key: key);

  final String title;
  final PreferredSizeWidget? bottom;
  late final Size _preferredSize;

  @override
  Size get preferredSize => _preferredSize;

  @override
  Widget build(BuildContext context) {
    return Consumer3<StockMutationRepository, StockMutationItemRepository,
        ConnectivityResult?>(
      builder: (context, mutationRepository, itemRepository, result, _) {
        if (result != ConnectivityResult.none) {
          const duration = Duration(milliseconds: 700);
          if (timer != null) {
            timer!.cancel();
          }
          timer = new Timer(duration, () {
            mutationRepository.processQueue();
            itemRepository.processQueue();
          });
        }
        return AppBar(
          key: key,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/logo_blue.png', height: 24),
              Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
            ],
          ),
          bottom: bottom,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                  SettingsDialog.routeName);
            },
            icon: Icon(Icons.settings),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.getKeys().forEach((key) {
                  if (key != 'server') {
                    prefs.remove(key);
                  }
                });
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        );
      },
    );
  }
}
