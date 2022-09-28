import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:scanner/dio.dart';
import 'package:scanner/util/user_latest_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final _authData = {
    'username': '',
    'password': '',
  };

  LoginScreen({Key? key, required this.prefs}) : super(key: key);

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo_blue.png',
                  height: 40,
                ),
                SizedBox(
                  height: 32,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Server',
                  ),
                  keyboardType: TextInputType.url,
                  initialValue:
                      prefs.getString('server') ?? 'http://powerwms.nl',
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    dio.options.baseUrl = '$value/api';
                    prefs.setString('server', value!);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .loginUsernameLabel
                        .toUpperCase(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: 'swagger@powerwms.nl',
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email is required'),
                    EmailValidator(errorText: 'Invalid email'),
                  ]),
                  onSaved: (value) {
                    _authData['username'] = value ?? '';
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.loginPasswordLabel,
                  ),
                  obscureText: true,
                  initialValue: 'Sw@gger',
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Password is required'),
                    MinLengthValidator(
                      6,
                      errorText: 'Password must be at least 6 digits long',
                    ),
                  ]),
                  onSaved: (value) {
                    _authData['password'] = value ?? '';
                  },
                ),
                SizedBox(
                  height: 32,
                ),
                TextButton(
                  child: Text(
                    AppLocalizations.of(context)!.loginSignIn.toUpperCase(),
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () async {
                    await UserLatestSession.shared.removeTimestamp();
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      try {
                        final response = await dio.post(
                          '/account/token',
                          data: {
                            'email': _authData['username'],
                            'password': _authData['password']
                          },
                        );
                        dio.options.headers = {
                          'authorization': 'Bearer ${response.data}',
                        };
                        prefs.setString('token', response.data);
                        Navigator.pushReplacementNamed(context, '/');
                      } catch (e, stack) {
                        print('$e\n$stack');
                        _showErrorDialog(context, 'Invalid credentials');
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
