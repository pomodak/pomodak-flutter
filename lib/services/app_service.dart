import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// sharedPreferences 로그인 여부 키값
String loginKey = "6E45EF1G1AUI3E51BD1VG9SD68";

// 로그인 여부, 앱 초기화 여부 확인
class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  bool _loginState = false;
  bool _initialized = false;

  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  bool get initialized => _initialized;

  // 변경사항 반영 후 알림
  set loginState(bool state) {
    sharedPreferences.setBool(loginKey, state);
    _loginState = state;
    notifyListeners();
  }

  // 초기화 여부 반영 후 알림
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  Future<void> onAppStart() async {
    _loginState = sharedPreferences.getBool(loginKey) ?? false;

    await Future.delayed(const Duration(seconds: 2));

    _initialized = true;
    notifyListeners();
  }
}
