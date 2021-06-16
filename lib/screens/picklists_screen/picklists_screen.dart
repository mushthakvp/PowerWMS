import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scanner/api.dart';
import 'package:scanner/screens/picklists_screen/widgets/picklist_view.dart';
import 'package:scanner/widgets/wms_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistsScreen extends StatefulWidget {
  const PicklistsScreen({Key? key}) : super(key: key);

  @override
  _PicklistScreenState createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistsScreen> {
  Timer? _searchOnStoppedTyping;
  Future<Response<Map<String, dynamic>>>? _future;

  @override
  void initState() {
    _search(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: WMSAppBar(
          'Extracom',
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      text: AppLocalizations.of(context)!
                          .picklistsOpen
                          .toUpperCase(),
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!
                          .picklistsRevise
                          .toUpperCase(),
                    ),
                  ],
                ),
                Container(
                  child: TextField(
                    onChanged: _onChangeHandler,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.picklistsSearch,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white),
                )
              ],
            ),
          ),
          context: context,
        ),
        body: TabBarView(
          children: [
            PicklistView(
                _future!, (element) => [1, 2].contains(element.status)),
            PicklistView(_future!, (element) => element.status == 4),
          ],
        ),
      ),
    );
  }

  _search(value) async {
    try {
      setState(() {
        _future = getPicklists(value);
      });
    } catch (e) {
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  _onChangeHandler(value) {
    const duration = Duration(milliseconds: 700);
    if (_searchOnStoppedTyping != null) {
      setState(() => _searchOnStoppedTyping!.cancel());
    }
    setState(() {
      _searchOnStoppedTyping = new Timer(duration, () => _search(value));
    });
  }
}
