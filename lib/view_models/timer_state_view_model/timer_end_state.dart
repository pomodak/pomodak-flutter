import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

// 타이머 종료 상태를 저장하는 클래스
// isTimerEnded가 true이면 timerPage/timer_display.dart에서 감지 후 알람 페이지로 이동
class TimerEndState {
  bool isTimerEnded = false;
  AlarmType? lastAlarmType;
  int? lastElapsedSeconds;

  void setTimerEndState(AlarmType type, int elapsedSeconds) {
    isTimerEnded = true;
    lastAlarmType = type;
    lastElapsedSeconds = elapsedSeconds;
  }

  void reset() {
    isTimerEnded = false;
    lastAlarmType = null;
    lastElapsedSeconds = null;
  }
}
