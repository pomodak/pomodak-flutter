import 'package:flutter/cupertino.dart';
import 'package:pomodak/data/repositories/app_options_repository.dart';
import 'package:pomodak/utils/firebase_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
    _toggleVibration();
    notifyListeners();
  }

  set keepScreenOn(bool value) {
    _keepScreenOn = value;
    repository.saveAppOptions(
      vibration: _vibration,
      keepScreenOn: _keepScreenOn,
    );
    _toggleWakeLock();
    notifyListeners();
  }

  void _toggleWakeLock() {
    if (_keepScreenOn) {
      WakelockPlus.enable();
      MessageUtil.showSuccessToast("화면꺼짐 방지 on");
    } else {
      WakelockPlus.disable();
      MessageUtil.showSuccessToast("화면꺼짐 방지 off");
    }
  }

  Future<void> _toggleVibration() async {
    if (_vibration) {
      MessageUtil.showSuccessToast("휴대폰 진동이 켜져있나 확인해주세요!");
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 400);
      }
    }
  }

  // 초기화 여부 반영 후 알림
  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  void onAppStart(BuildContext context) async {
    var isLatestVesrion = await FirebaseUtil.checkAppVersion(context);

    // 최신버전이 아니라면 _initialized를 false로 설정하여 splash 페이지를 벗어나지 않도록 함
    if (!isLatestVesrion) {
      return;
    }
    _initialized = true;
    _vibration = await repository.getVibration();
    _keepScreenOn = await repository.getKeepScreenOn();

    if (_keepScreenOn) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }

    notifyListeners();
  }
}
