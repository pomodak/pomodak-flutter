import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:provider/provider.dart';

class TimerStartButton extends StatelessWidget {
  const TimerStartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerOptionsViewModel =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    final timerStateViewModel =
        Provider.of<TimerStateViewModel>(context, listen: false);

    return ElevatedButton(
      onPressed: () {
        // isPomodoroMode를 확인하여 적절한 타이머 시작 메서드 호출
        if (timerOptionsViewModel.isPomodoroMode) {
          timerStateViewModel.pomodoroStart();
        } else {
          timerStateViewModel.normalStart();
        }
        context.go(AppPage.timer.toPath);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 48),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: const Text(
        'Start',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
