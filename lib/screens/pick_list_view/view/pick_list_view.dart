import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'widgets/open_widgets.dart';
import 'widgets/revise_widgets.dart';

class PickListViewV2 extends StatefulWidget {
  const PickListViewV2({Key? key}) : super(key: key);

  @override
  State<PickListViewV2> createState() => _PickListViewV2State();
}

class _PickListViewV2State extends State<PickListViewV2> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo_horizontal.png',
                width: size.width * 0.23,
              ),
              Text(
                'Sander',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              SizedBox(width: size.width * 0.13),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Column(
              children: [
                TabBar(
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 20),
                  tabs: [
                    Tab(
                      text: 'OPEN',
                    ),
                    Tab(
                      text: 'REVISE',
                    ),
                  ],
                ),
                SizedBox(height: 5),
                TextField(
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            OpenTabWidget(),
            ReviseWidget(),
          ],
        ),
      ),
    );
  }
}
