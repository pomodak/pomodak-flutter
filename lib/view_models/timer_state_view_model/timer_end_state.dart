import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

// 타이머 종료 상태를 저장하는 클래스
// isTimerEnded가 true이면 timerPage/timer_display.dart에서 감지 후 알람 페이지로 이동
class TimerEndState with ChangeNotifier {
  bool _isTimerEnded = false;
  AlarmType? _lastAlarmType;
  int? _lastElapsedSeconds;
  bool _isEndedInBackground = false;

  bool get isTimerEnded => _isTimerEnded;
  AlarmType? get lastAlarmType => _lastAlarmType;
  int? get lastElapsedSeconds => _lastElapsedSeconds;
  bool get isEndedInBackground => _isEndedInBackground;

  void setTimerEndState(
      AlarmType type, int elapsedSeconds, bool endedInBackground) {
    _isTimerEnded = true;
    _lastAlarmType = type;
    _lastElapsedSeconds = elapsedSeconds;
    _isEndedInBackground = endedInBackground;
    notifyListeners();
  }

  void reset() {
    _isTimerEnded = false;
    _lastAlarmType = null;
    _lastElapsedSeconds = null;
    _isEndedInBackground = false;
    notifyListeners();
  }
}
