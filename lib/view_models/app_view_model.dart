import 'package:flutter/cupertino.dart';
import 'package:pomodak/data/storagies/app_options_storage.dart';

// 앱 설정 & 앱 초기화 여부 확인
class AppViewModel with ChangeNotifier {
  AppOptionStorage storage;
  bool _initialized = false;
  bool _vibration = false;
  bool _keepScreenOn = false;

  bool get initialized => _initialized;
  bool get vibration => _vibration;
  bool get keepScreenOn => _keepScreenOn;

  AppViewModel({required this.storage});

  set vibration(bool value) {
    _vibration = value;
    storage.saveAppOption(
      vibration: _vibration,
      keepScreenOn: _keepScreenOn,
    );
    notifyListeners();
  }

  set keepScreenOn(bool value) {
    _keepScreenOn = value;
    storage.saveAppOption(
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
  void onAppStart() {
    _initialized = true;
    _vibration = storage.getVibration();
    _keepScreenOn = storage.getKeepScreenOn();
  }
}
