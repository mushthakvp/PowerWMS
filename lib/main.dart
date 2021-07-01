import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/screens/home_screen/home_screen.dart';
import 'package:scanner/screens/login_screen.dart';
import 'package:scanner/screens/picklist_screen/picklist_screen.dart';
import 'package:scanner/screens/picklists_screen/picklists_screen.dart';
import 'package:scanner/screens/product_screen/product_screen.dart';
import 'package:scanner/screens/products_screen/products_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider(
      initialData: ValueNotifier<Settings>(Settings()),
      create: (context) =>
          Settings.fromMemory().then((value) => ValueNotifier<Settings>(value)),
      catchError: (context, error) => ValueNotifier<Settings>(Settings()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Extracom WMS',
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.grey,
          scaffoldBackgroundColor: Color(0xFFEDF0F5),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey[500]),
          ),
          textTheme: TextTheme(button: TextStyle(color: Colors.blueAccent)),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: Colors.blueAccent),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Colors.blueAccent,
            ),
          ),
        ),
        home: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.getString('token') != null &&
                snapshot.data!.getString('server') != null) {
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
          '/products': (context) => ProductsScreen(),
          '/product': (context) {
            final line =
                ModalRoute.of(context)!.settings.arguments as PicklistLine;
            return ProductScreen(line);
          },
          '/picklists': (context) => PicklistsScreen(),
          '/picklist': (context) {
            final picklist =
                ModalRoute.of(context)!.settings.arguments as Picklist;
            return PicklistScreen(picklist);
          },
        },
      ),
    );
  }
}
