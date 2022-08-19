import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
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
import 'package:scanner/providers/process_product_provider.dart';
import 'package:scanner/providers/settings_provider.dart';
import 'package:scanner/resources/picklist_line_repository.dart';
import 'package:scanner/resources/picklist_repository.dart';
import 'package:scanner/resources/product_repository.dart';
import 'package:scanner/resources/stock_mutation_item_repository.dart';
import 'package:scanner/resources/stock_mutation_repository.dart';
import 'package:scanner/screens/home_screen/home_screen.dart';
import 'package:scanner/screens/log_screen/log_screen.dart';
import 'package:scanner/screens/login_screen.dart';
import 'package:scanner/screens/picklist_product_screen/picklist_product_screen.dart';
import 'package:scanner/screens/picklist_screen/picklist_screen.dart';
import 'package:scanner/screens/picklists_screen/picklists_screen.dart';
import 'package:scanner/screens/products_screen/products_screen.dart';
import 'package:scanner/widgets/settings_dialog.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

RouteObserver<ModalRoute<void>> navigationObserver = RouteObserver<ModalRoute<void>>();

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
    return FutureBuilder<List<dynamic>>(
      future:
          Future.wait([Settings.fromMemory(), SharedPreferences.getInstance()]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final settings = snapshot.data![0] as Settings;
          final prefs = snapshot.data![1] as SharedPreferences;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<ValueNotifier<Settings>>(
                create: (_) => ValueNotifier<Settings>(settings),
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
              Provider<StockMutationItemRepository>(
                create: (_) => StockMutationItemRepository(_db),
              ),
              Provider<StockMutationRepository>(
                create: (_) => StockMutationRepository(_db),
              ),
              ChangeNotifierProvider<SettingProvider>(
                create: (_) => SettingProvider(_db),
              ),
              StreamProvider<ConnectivityResult?>(
                create: (_) => Connectivity().onConnectivityChanged,
                initialData: null,
              ),
              ChangeNotifierProvider<ProcessProductProvider>(
                  create: (_) => ProcessProductProvider()
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Extracom WMS',
              navigatorObservers: [navigationObserver],
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
              home: Builder(
                builder: (context) {
                  if (prefs.getString('token') != null &&
                      prefs.getString('server') != null) {
                    dio.options.baseUrl = '${prefs.getString('server')!}/api';
                    dio.options.headers = {
                      'authorization': 'Bearer ${prefs.getString('token')}',
                    };
                    return HomeScreen();
                  } else {
                    return LoginScreen(prefs: prefs);
                  }
                },
              ),
              routes: {
                SettingsDialog.routeName: (context) => SettingsDialog(),
                ProductsScreen.routeName: (context) => ProductsScreen(),
                PicklistProductScreen.routeName: (context) {
                  final line = ModalRoute.of(context)!.settings.arguments
                      as PicklistLine;
                  return PicklistProductScreen(line);
                },
                PicklistsScreen.routeName: (context) => PicklistsScreen(),
                PicklistScreen.routeName: (context) {
                  final picklist =
                      ModalRoute.of(context)!.settings.arguments as Picklist;
                  return PicklistScreen(picklist);
                },
                LogScreen.routeName: (context) => LogScreen(),
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
