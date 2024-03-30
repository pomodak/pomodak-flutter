import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 앱 설정 & 앱 초기화 여부 확인
class AppViewModel with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  bool _initialized = false;

  AppViewModel(this.sharedPreferences);

  bool get initialized => _initialized;

  // 초기화 여부 반영 후 알림
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  Future<void> onAppStart() async {
    await Future.delayed(const Duration(seconds: 2));

    _initialized = true;
    notifyListeners();
  }
}
