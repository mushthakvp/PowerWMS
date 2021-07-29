import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scanner/db.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/log.dart';
import 'package:scanner/models/picklist.dart';
import 'package:scanner/models/picklist_line.dart';
import 'package:scanner/models/settings.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/resources/product_repository.dart';
import 'package:scanner/screens/home_screen/home_screen.dart';
import 'package:scanner/screens/log_screen/log_screen.dart';
import 'package:scanner/screens/login_screen.dart';
import 'package:scanner/screens/picklist_screen/picklist_screen.dart';
import 'package:scanner/screens/picklists_screen/picklists_screen.dart';
import 'package:scanner/screens/product_screen/product_screen.dart';
import 'package:scanner/screens/products_screen/products_screen.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initLogs();
  final db = await createDb();

  runApp(WMSApp(db));
}

class WMSApp extends StatelessWidget {
  WMSApp(this._db);

  final Database _db;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Settings>(
      future: Settings.fromMemory(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ValueNotifier<Settings>>(
                create: (_) => ValueNotifier<Settings>(snapshot.data!),
              ),
              Provider<PicklistRepository>(
                create: (_) => PicklistRepository(_db),
              ),
              Provider<PicklistLineRepository>(
                create: (_) => PicklistLineRepository(_db),
              ),
              Provider<ProductRepository>(
                create: (_) => ProductRepository(_db),
              ),
            ],
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
                textTheme:
                    TextTheme(button: TextStyle(color: Colors.blueAccent)),
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
                      'authorization':
                          'Bearer ${snapshot.data!.getString('token')}',
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
                  final line = ModalRoute.of(context)!.settings.arguments
                      as PicklistLine;
                  return ProductScreen(line);
                },
                '/picklists': (context) => PicklistsScreen(),
                '/picklist': (context) {
                  final picklist =
                      ModalRoute.of(context)!.settings.arguments as Picklist;
                  return PicklistScreen(picklist);
                },
                '/logs': (context) => LogScreen(),
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
