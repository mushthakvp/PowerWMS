import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scanner/api.dart';
import 'package:scanner/widgets/wms_app_bar.dart';

class PicklistScreen extends StatefulWidget {
  const PicklistScreen({Key key}) : super(key: key);

  @override
  _PicklistScreenState createState() => _PicklistScreenState();
}

class _PicklistScreenState extends State<PicklistScreen> {
  Timer _searchOnStoppedTyping;
  Future _future;

  @override
  void initState() {
    _search('');
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: WMSAppBar(
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: 'OPEN'),
                    Tab(text: 'REVISE'),
                  ],
                ),
                Container(
                  child: TextField(
                    onChanged: _onChangeHandler,
                    decoration: InputDecoration(
                      hintText: 'Search...',
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
            FutureBuilder<Response>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  // if (response.statusCode == 401) {
                  //   prefs.clear();
                  //   Navigator.pushReplacementNamed(context, '/');
                  // }
                }
                if (snapshot.hasData) {
                  print(jsonDecode(snapshot.data.body));
                  print(snapshot.data.statusCode);
                  return Text(snapshot.data.body);
                  // final filtered = (jsonDecode(snapshot.data.body) as List<dynamic>)
                  //     .where((element) => [1, 2].contains(element.status));
                  // return ListView(
                  //   children: filtered.map((picklist) => ListTile(
                  //     title: picklist.uid,
                  //     subtitle: picklist.debtor.city,
                  //     leading: Text(picklist.debtor.name),
                  //   )).toList(),
                  // );
                } else {
                  return Text('Loading...');//CircularProgressIndicator();
                }
              },
            ),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final filtered = (snapshot.data as List<dynamic>)
                      .where((element) => element.status == 4);
                  return ListView(
                    children: filtered.map((picklist) => ListTile(
                      title: picklist.uid,
                      subtitle: picklist.debtor.city,
                      leading: Text(picklist.debtor.name),
                    )).toList(),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
        drawer: Drawer(),
      ),
    );
  }

  _search(value) {
    _future = getPicklists(value);
  }

  _onChangeHandler(value) {
    const duration = Duration(seconds: 1);
    if (_searchOnStoppedTyping != null) {
      setState(() => _searchOnStoppedTyping.cancel());
    }
    setState(() => _searchOnStoppedTyping = new Timer(duration, () => _search(value)));
  }
}
