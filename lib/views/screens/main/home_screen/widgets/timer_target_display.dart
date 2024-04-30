import 'package:flutter/material.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/pomodoro_timer.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/screens/main/home_screen/widgets/show_timer_option_modal.dart';
import 'package:provider/provider.dart';

class TimerTargetDisplay extends StatelessWidget {
  const TimerTargetDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final pomodoroPhase =
        context.select((TimerViewModel vm) => vm.pomodoroPhase);
    final timerOptions = context.watch<TimerOptionsViewModel>();

    final targetSeconds = timerOptions.isPomodoroMode
        ? (pomodoroPhase == PomodoroPhase.focus
                ? timerOptions.workTime
                : timerOptions.restTime) *
            60
        : 0;

    final displayTime = FormatUtil.formatSeconds(targetSeconds);

    return InkWell(
      onTap: () {
        showTimerOptionsModal(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        child: Text(
          displayTime,
          style: const TextStyle(
            fontSize: 54,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
