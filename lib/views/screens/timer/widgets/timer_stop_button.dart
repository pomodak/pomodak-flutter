import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
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
      onPressed: () => _showConfirmationDialog(
        context,
        text,
        timerOptions,
        timerState,
      ),
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

  void _showConfirmationDialog(BuildContext context, String text,
      TimerOptionsViewModel timerOptions, TimerStateViewModel timerState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "정말 멈추시겠습니까?",
            style: TextStyle(fontSize: 24),
          ),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("취소"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                if (timerOptions.isPomodoroMode) {
                  if (timerState.pomodoroMode == PomodoroMode.focus) {
                    timerState.pomodoroGiveUp();
                  } else {
                    timerState.pomodoroPass();
                    context.go("/");
                  }
                } else {
                  timerState.normalEnd();
                }
                Navigator.of(context).pop();
              },
              child: const Text(
                "확인",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
