import 'package:flutter/material.dart';
import 'package:pomodak/models/timer/alarm_info.dart';

// 타이머 종료 상태를 저장하는 클래스
// isTimerEnded의 변화를 timerPage/timer_display.dart에서 감지 후 알람 페이지로 이동
class TimerAlarmViewModel with ChangeNotifier {
  AlarmInfo? _lastAlarmInfo;

  AlarmInfo? get lastAlarmInfo => _lastAlarmInfo;

  void setAlarm({
    required AlarmType type,
    required int elapsedSeconds,
    required bool endedInBackground,
  }) {
    _lastAlarmInfo = AlarmInfo(
      alarmType: type,
      time: elapsedSeconds,
      isEndedInBackground: endedInBackground,
    );
    notifyListeners();
  }

  void reset() {
    _lastAlarmInfo = null;
    notifyListeners();
  }
}
