import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class InternetState {
  InternetState._();
  static InternetState shared = InternetState._();

  late ConnectivityResult _connectionStatus = ConnectivityResult.wifi;
  final Connectivity _connectivity = Connectivity();

  Future<void> ensureInitialized() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } on PlatformException catch (_) {
      print('Couldn\'t check connectivity status');
    }
  }

  Future<bool> isConnectivityAvailable() async {
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
    return (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet);
  }

  bool connectivityAvailable() {
    return (_connectionStatus == ConnectivityResult.mobile ||
        _connectionStatus == ConnectivityResult.wifi ||
        _connectionStatus == ConnectivityResult.ethernet);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
    // print('Internet status: $result');
  }
}