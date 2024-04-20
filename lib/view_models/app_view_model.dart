import 'package:flutter/cupertino.dart';
import 'package:pomodak/data/repositories/app_options_repository.dart';

// 앱 설정 & 앱 초기화 여부 확인
class AppViewModel with ChangeNotifier {
  AppOptionsRepository repository;
  bool _initialized = false;
  bool _vibration = false;
  bool _keepScreenOn = false;

  bool get initialized => _initialized;
  bool get vibration => _vibration;
  bool get keepScreenOn => _keepScreenOn;

  AppViewModel({required this.repository});

  set vibration(bool value) {
    _vibration = value;
    repository.saveAppOptions(
      vibration: _vibration,
      keepScreenOn: _keepScreenOn,
    );
    notifyListeners();
  }

  set keepScreenOn(bool value) {
    _keepScreenOn = value;
    repository.saveAppOptions(
      vibration: _vibration,
      keepScreenOn: _keepScreenOn,
    );
    notifyListeners();
  }

  // 초기화 여부 반영 후 알림
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  void onAppStart() async {
    _initialized = true;
    _vibration = await repository.getVibration();
    _keepScreenOn = await repository.getKeepScreenOn();
  }
}
