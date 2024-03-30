import 'package:flutter/material.dart';

// Todo 타이머 설정모달 열기

class TargetTimerDisplay extends StatelessWidget {
  const TargetTimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '00:25:00',
      style: TextStyle(
        fontSize: 54,
        fontWeight: FontWeight.bold,
        letterSpacing: 4,
      ),
    );
  }
}
