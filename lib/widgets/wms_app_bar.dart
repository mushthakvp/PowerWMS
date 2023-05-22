import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner/db.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/repository/stock_mutation_item_repository.dart';
import 'package:scanner/repository/stock_mutation_repository.dart';
import 'package:scanner/util/internet_state.dart';
import 'package:scanner/util/user_latest_session.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WMSAppBar extends StatefulWidget implements PreferredSizeWidget {
  WMSAppBar(
    this.title, {
    Key? key,
    this.leading,
    this.isShowLogo = true,
    this.action,
    this.elevation,
    this.bottom,
    double? preferredSize,
  })  : _preferredSize = Size.fromHeight(preferredSize ?? kToolbarHeight),
        super(key: key);

  final String title;
  final double? elevation;
  final Widget? leading;
  final Widget? action;
  final bool? isShowLogo;
  final PreferredSizeWidget? bottom;
  final Size _preferredSize;

  @override
  Size get preferredSize => _preferredSize;

  State<WMSAppBar> createState() => _WMSAppBarState();
}

class _WMSAppBarState extends State<WMSAppBar> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Consumer3<StockMutationRepository, StockMutationItemRepository,
        ConnectivityResult?>(
      builder: (context, mutationRepository, itemRepository, result, _) {
        bool isAvailableInternet = InternetState.shared.connectivityAvailable();
        const duration = Duration(milliseconds: 700);
        if (timer != null) {
          timer!.cancel();
        }
        timer = new Timer(duration, () {
          Future.delayed(const Duration(), () async {
            isAvailableInternet =
                await InternetState.shared.isConnectivityAvailable();
            if (!mounted) return;
            setState(() {});
          });
        });
        return AppBar(
          key: widget.key,
          elevation: widget.elevation,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isAvailableInternet)
                if (widget.isShowLogo!)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/images/logo_horizontal.png',
                      width: MediaQuery.of(context).size.width * 0.23,
                    ),
                  )
                else
                  SizedBox()
              else
                Image.asset(
                  'assets/images/no_internet.png',
                  width: 38,
                ),
              Text(widget.title,
                  style: Theme.of(context).appBarTheme.titleTextStyle),
            ],
          ),
          bottom: widget.bottom,
          leading: widget.leading ??
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(SettingsDialog.routeName);
                },
                icon: Icon(Icons.settings),
              ),
          actions: [
            widget.action ??
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    logout(context);
                  },
                )
          ],
        );
      },
    );
  }
}

logout(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.getKeys().forEach((key) async {
    if (key != 'username' && key != 'password' && key != 'server') {
      await prefs.remove(key);
    }
  });
  dio = Dio();
  await deleteDb();
  // UserLatestSession.shared.cancelTimer();
  Navigator.pushReplacementNamed(context, '/');
}
