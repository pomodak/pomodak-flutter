import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

class TimerAlarmState {
  bool isTimerEnded = false;
  AlarmType? lastAlarmType;
  int? lastElapsedSeconds;

  void setTimerAlarmState(AlarmType type, int elapsedSeconds) {
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
