import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_image.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_stop_button.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: TimerImage(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: TimerDisplay(),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        TimerStopButton(),
                      ],
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
