import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:provider/provider.dart';

class TimerStopButton extends StatelessWidget {
  const TimerStopButton({super.key});

  @override
  Widget build(BuildContext context) {
    String text;
    final timerOptions =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    final timerState = Provider.of<TimerStateViewModel>(context, listen: false);

    if (!timerOptions.isPomodoroMode) {
      text = "Stop";
    } else {
      if (timerState.pomodoroMode == PomodoroMode.focus) {
        text = "Give up";
      } else {
        text = "Pass";
      }
    }

    return ElevatedButton(
      onPressed: () {
        if (timerOptions.isPomodoroMode) {
          timerState.pomodoroEnd();
        } else {
          timerState.normalEnd();
        }

        // 메인으로 이동
        context.go("/");
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 48),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
