import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final timerAlarmViewModel = Provider.of<TimerAlarmViewModel>(context);
    final timerStateViewModel = Provider.of<TimerViewModel>(context);
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);

    AlarmInfo? alarmInfo = timerAlarmViewModel.lastAlarmInfo;

    String displayTime = _formatDisplayTime(timerStateViewModel, timerOptions);
    if (alarmInfo != null) {
      Future.delayed(Duration.zero, () {
        context.go(
          "/timer-alarm",
          extra: AlarmInfo(
            alarmType: alarmInfo.alarmType, // 마지막 알람 타입
            time: alarmInfo.time, // 경과 시간
            isEndedInBackground:
                alarmInfo.isEndedInBackground, // 백그라운드에서 종료됐는지 여부
          ),
        );
        timerAlarmViewModel.reset(); // 알림 상태 리셋
      });
    }

    return Text(
      displayTime,
      style: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        letterSpacing: 6,
      ),
    );
  }

  String _formatDisplayTime(
      TimerViewModel timerState, TimerOptionsViewModel timerOptions) {
    if (timerOptions.isPomodoroMode) {
      int targetSeconds = (timerState.pomodoroMode == PomodoroMode.focus)
          ? timerOptions.workTime * 60
          : timerOptions.restTime * 60;
      int remainingSeconds = targetSeconds - timerState.elapsedSeconds;

      return FormatUtil.formatSeconds(remainingSeconds);
    } else {
      // 일반 모드에서는 경과 시간을 표시
      return FormatUtil.formatSeconds(timerState.elapsedSeconds);
    }
  }
}
