import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scanner/models/picklist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PicklistView extends StatelessWidget {
  final Future<Response<Map<String, dynamic>>> _future;
  final bool Function(Picklist picklist) _where;

  const PicklistView(this._future, this._where, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          var error = (snapshot.error as DioError);
          var response = error.response;
          if (response?.statusCode == 401) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.clear();
              Navigator.pushReplacementNamed(context, '/');
            });
          } else {
            Future.microtask(() {
              final snackBar = SnackBar(content: Text(error.message));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }
        }
        if (snapshot.hasData) {
          final filtered = (snapshot.data!.data!['data'] as List<dynamic>)
              .map((json) => Picklist.fromJson(json))
              .where(_where);
          try {
            return ListView(
              children: filtered
                  .map((picklist) => Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/picklist',
                                  arguments: picklist);
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(picklist.uid),
                                if (picklist.debtor.city != null)
                                  Text(picklist.debtor.city!),
                                Text(picklist.debtor.name,
                                    style: TextStyle(color: Colors.grey[400])),
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right),
                          ),
                          Divider(
                            height: 1,
                          ),
                        ],
                      ))
                  .toList(),
            );
          } catch (e, stack) {
            return Text('${e.toString()}:\n${stack.toString()}');
          }
        } else {
          return Container();
        }
      },
    );
  }
}
