import 'package:flutter/material.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/screens/login_screen.dart';
import 'package:scanner/screens/picklists_screen/picklists_screen.dart';
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
          if (snapshot.hasData && snapshot.data!.getString('token') != null && snapshot.data!.getString('server') != null) {
            dio.options.baseUrl = snapshot.data!.getString('server')!;
            dio.options.headers = {
              'authorization': 'Bearer ${snapshot.data!.getString('token')}',
            };
            return PicklistsScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
