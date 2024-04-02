import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_image.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_puase_button.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_stop_button.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';
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
    // 위젯이 완전히 빌드된 뒤 실행함
    WidgetsBinding.instance.addPostFrameCallback((_) => _startTimer());
  }

  void _startTimer() {
    final timerOptionsViewModel =
        Provider.of<TimerOptionsViewModel>(context, listen: false);
    final timerStateViewModel =
        Provider.of<TimerStateViewModel>(context, listen: false);

    // addPostFrameCallback이 실행될때 onTimerEnd함수가 생성 되어야 올바른 context를 참조 가능
    void onTimerEnd(AlarmType alarmType, int time) {
      context.go(
        "/timer-alarm",
        extra: AlarmInfo(
          alarmType: alarmType,
          time: time,
        ),
      );
    }

    if (timerOptionsViewModel.isPomodoroMode) {
      timerStateViewModel.pomodoroStart(onTimerEnd);
    } else {
      timerStateViewModel.normalStart(onTimerEnd);
    }
  }

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
            ),
          ),
        ],
      ),
    );
  }
}
