import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';
import 'package:provider/provider.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final timerState = Provider.of<TimerStateViewModel>(context);
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);

    String displayTime = _formatDisplayTime(timerState, timerOptions);

    if (timerState.isTimerEnded) {
      Future.delayed(Duration.zero, () {
        context.go(
          "/timer-alarm",
          extra: AlarmInfo(
            alarmType: timerState.lastAlarmType!, // 마지막 알람 타입
            time: timerState.lastElaspedSeconds ?? 0, // 경과 시간
          ),
        );
        timerState.resetTimerEndStatus(); // 타이머 종료 상태 리셋
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
      TimerStateViewModel timerState, TimerOptionsViewModel timerOptions) {
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
