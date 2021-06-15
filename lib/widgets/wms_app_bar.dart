import 'package:flutter/material.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WMSAppBar extends AppBar {
  WMSAppBar(
    title, {
    Key? key,
    PreferredSizeWidget? bottom,
    required BuildContext context,
  }) : super(
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
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return SettingsDialog();
                  },
                );
              },
              icon: Icon(Icons.settings)),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacementNamed(context, '/');
              },
            )
          ],
        );
}
