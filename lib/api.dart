import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Response> login(String username, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return post(
    Uri.parse('${prefs.getString('server')}/api/account/token'),
    body: {
      'email': username,
      'password': password,
    },
  );
}

Future<Response> getPicklists(String search) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return post(
    Uri.parse('${prefs.getString('server')}/api/picklist/list'),
    body: {
      'search': search,
      'skipPaging': '1',
    },
    headers: {
      'Authorization': 'Bearer ${prefs.getString('token')}',
    },
  );
}
