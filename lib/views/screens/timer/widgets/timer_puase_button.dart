import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class TimerPauseButton extends StatelessWidget {
  const TimerPauseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<TimerViewModel>().togglePause();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 48),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      child: const Text(
        "Pause",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
