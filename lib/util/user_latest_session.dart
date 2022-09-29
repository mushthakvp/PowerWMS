import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class UserLatestSession {
  UserLatestSession._();
  static UserLatestSession shared = UserLatestSession._();

  static SharedPreferences? _preferences;

  static const _key = 'user_latest_session';

  static Future ensureInitialized() async =>
      _preferences = await SharedPreferences.getInstance();

  late Timer _timer;

  Future<void> startTimer() async {
    await _setTimestamp();
    // Log the latest session after each 2 minutes
    const tenSec = const Duration(seconds: 120);
    _timer = Timer.periodic(tenSec, (_) async {
      await _setTimestamp();
    });
  }

  static bool isOutOfSession() {
    int? timestamp = _preferences?.getInt(_key);
    if (timestamp != null) {
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime now = DateTime.now();
      if (tsdate.year == now.year
          && tsdate.month == now.month
          && tsdate.day == now.day
      ) {
        int h = now.hour - tsdate.hour;
        if (h == 4) {
          return (now.minute >= tsdate.minute);
        } else if (h > 4) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> removeTimestamp() async {
    await _preferences?.remove(_key);
  }

  void cancelTimer() {
    _timer.cancel();
  }

  Future<void> _setTimestamp() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    await _preferences?.setInt(_key, timestamp);
  }
}