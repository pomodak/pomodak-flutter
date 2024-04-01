import 'package:flutter/material.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:provider/provider.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final timerState = Provider.of<TimerStateViewModel>(context);
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);

    String displayTime = _formatDisplayTime(timerState, timerOptions);

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
