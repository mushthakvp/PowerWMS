import 'package:flutter/material.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/screens/home_screen/home_screen.dart';
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
      title: 'Extracom WMS',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Color(0xFFEDF0F5),
        appBarTheme: AppBarTheme(
          // titleTextStyle: TextStyle(color: Colors.grey[800]),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.grey[500]),
        ),
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.getString('token') != null && snapshot.data!.getString('server') != null) {
            dio.options.baseUrl = snapshot.data!.getString('server')!;
            dio.options.headers = {
              'authorization': 'Bearer ${snapshot.data!.getString('token')}',
            };
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        // '/products':
        '/picklists': (context) => PicklistsScreen(),
      },
    );
  }
}
