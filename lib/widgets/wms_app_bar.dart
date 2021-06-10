import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WMSAppBar extends AppBar {
  WMSAppBar(title, {Key? key, PreferredSizeWidget? bottom, required BuildContext context})
      : super(
          key: key,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/logo_blue.png', height: 24),
              Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
            ],
          ),
          bottom: bottom,
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
