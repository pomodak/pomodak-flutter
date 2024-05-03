import 'package:pomodak/di.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/view_models/timer_view_model/base_timer.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';

class NormalTimer extends BaseTimer {
  Future<void> Function({
    required int time,
    required bool isCompleted,
  }) saveRecord;

  void Function({
    required AlarmType type,
    required int elapsedSeconds,
    required bool endedInBackground,
    int? earnedPoints,
  }) setAlarm;

  NormalTimer({
    required this.saveRecord,
    required this.setAlarm,
  });

  @override
  void interuptSession() async {
    int earnedPoints = getIt<TransactionViewModel>()
        .calcPointsFromFocusSeconds(elapsedSeconds);
    setAlarm(
      type: AlarmType.normal,
      elapsedSeconds: elapsedSeconds,
      endedInBackground: false,
      earnedPoints: earnedPoints,
    );
    saveRecord(time: elapsedSeconds, isCompleted: false);
  }
}
