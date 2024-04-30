import 'package:flutter/material.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/screens/timer/widgets/alarm_handler.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_image.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_puase_button.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_settings_row.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_stop_button.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 빌드된 뒤 타이머 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<TimerViewModel>().timerStart();
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupAlarmHandler(context);
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 1,
            child: TimerImage(),
          ),
          Expanded(
            flex: 1,
            child: _buildTimerControls(),
          ),
        ],
      ),
    );
  }

  // TimerAlarmViewModel 변화 감지 후 알람 처리
  void _setupAlarmHandler(BuildContext context) {
    final timerAlarmViewModel = context.watch<TimerAlarmViewModel>();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => checkForAlarm(context, timerAlarmViewModel));
  }

  Widget _buildTimerControls() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Expanded(
              child: Column(children: [
                TimerDisplay(),
                TimerSettingsRow(),
              ]),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      TimerPauseButton(),
                      TimerStopButton(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
