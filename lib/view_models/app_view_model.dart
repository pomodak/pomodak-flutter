import 'package:flutter/cupertino.dart';

// 앱 설정 & 앱 초기화 여부 확인
class AppViewModel with ChangeNotifier {
  bool _initialized = false;

  bool get initialized => _initialized;

  // 초기화 여부 반영 후 알림
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  void onAppStart() {
    _initialized = true;
  }
}
