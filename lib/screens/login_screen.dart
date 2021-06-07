import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final _authData = {
    'server': '',
    'username': '',
    'password': '',
  };

  LoginScreen({Key key}) : super(key: key);

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
                  initialValue: 'http://powerwms.nl',
                  validator: (value) {
                    return null;
                  },
                  onSaved: (value) {
                    _authData['server'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  initialValue: 'swagger@powerwms.nl',
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Email is required'),
                    EmailValidator(errorText: 'Invalid email'),
                  ]),
                  onSaved: (value) {
                    _authData['username'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                    _authData['password'] = value;
                  },
                ),
                SizedBox(
                  height: 32,
                ),
                TextButton(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      try {
                        final response = await post(
                          Uri.parse('${_authData['server']}/api/account/token'),
                          body: {
                            'email': _authData['username'],
                            'password': _authData['password']
                          },
                        );
                        if (response.statusCode != 200) {
                          throw ClientException('Invalid credentials');
                        }
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('token', jsonDecode(response.body));
                        prefs.setString('server', _authData['server']);
                        Navigator.pushReplacementNamed(context, '/');
                      } catch (e) {
                        _showErrorDialog(context, e.toString());
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

// Future<void> _submit() async {
//   if (!_formKey.currentState.validate()) {
//     // Invalid!
//     return;
//   }
//   _formKey.currentState.save();
//   setState(() {
//     _isLoading = true;
//   });
//   try {
//     if (_authMode == AuthMode.Login) {
//       // Log user in
//       // await Provider.of<Auth>(context, listen: false).login(
//       //   _authData['email'],
//       //   _authData['password'],
//       // );
//     } else {
//       // Sign user up
//       // await Provider.of<Auth>(context, listen: false).signup(
//       //   _authData['email'],
//       //   _authData['password'],
//       // );
//     }
//     // } on HttpException catch (error) {
//     //   var errorMessage = 'Authentication failed';
//     //   if (error.toString().contains('EMAIL_EXISTS')) {
//     //     errorMessage = 'This email address is already in use.';
//     //   } else if (error.toString().contains('INVALID_EMAIL')) {
//     //     errorMessage = 'This is not a valid email address';
//     //   } else if (error.toString().contains('WEAK_PASSWORD')) {
//     //     errorMessage = 'This password is too weak.';
//     //   } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
//     //     errorMessage = 'Could not find a user with that email.';
//     //   } else if (error.toString().contains('INVALID_PASSWORD')) {
//     //     errorMessage = 'Invalid password.';
//     //   }
//     //   _showErrorDialog(errorMessage);
//   } catch (error) {
//     const errorMessage =
//         'Could not authenticate you. Please try again later.';
//     _showErrorDialog(errorMessage);
//   }
//
//   setState(() {
//     _isLoading = false;
//   });
// }
}
