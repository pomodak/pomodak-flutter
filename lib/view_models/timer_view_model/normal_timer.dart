import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/view_models/timer_view_model/base_timer.dart';

class NormalTimer extends BaseTimer {
  Future<void> Function({
    required int time,
    required bool isCompleted,
  }) saveRecord;

  void Function({
    required AlarmType type,
    required int elapsedSeconds,
    required bool endedInBackground,
  }) setAlarm;

  NormalTimer({
    required this.saveRecord,
    required this.setAlarm,
  });

  @override
  void interuptSession() {
    setAlarm(
      type: AlarmType.normal,
      elapsedSeconds: elapsedSeconds,
      endedInBackground: false,
    );
    saveRecord(time: elapsedSeconds, isCompleted: false);
  }
}
