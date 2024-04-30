import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';

class TimerStartButton extends StatelessWidget {
  final bool isFocusTogetherMode;

  const TimerStartButton({
    super.key,
    required this.isFocusTogetherMode,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (isFocusTogetherMode) {
          context.go(AppPage.groupTimer.toPath);
        } else {
          context.go(AppPage.timer.toPath);
        }
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
