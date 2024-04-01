import 'package:flutter/material.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:provider/provider.dart';

class TimerTargetDisplay extends StatelessWidget {
  const TimerTargetDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    String displayTime;
    final timerState = Provider.of<TimerStateViewModel>(context, listen: false);
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    if (timerOptions.isPomodoroMode) {
      int targetSeconds = (timerState.pomodoroMode == PomodoroMode.focus)
          ? timerOptions.workTime * 60
          : timerOptions.restTime * 60;

      displayTime = FormatUtil.formatSeconds(targetSeconds);
    } else {
      displayTime = FormatUtil.formatSeconds(0);
    }

    return Text(
      displayTime,
      style: const TextStyle(
        fontSize: 54,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
      ),
    );
  }
}
