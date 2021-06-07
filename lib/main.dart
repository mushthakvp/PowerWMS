import 'package:flutter/material.dart';
import 'package:scanner/screens/login_screen.dart';
import 'package:scanner/screens/my_home_page.dart';
import 'package:scanner/screens/picklist_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScanWMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.getString('token') != null) {
            return PicklistScreen();//PicklistScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
