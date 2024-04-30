import 'package:flutter/material.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_image.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_puase_button.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_setting_toggle.dart';
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
    // 위젯이 완전히 빌드된 뒤 실행함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  void _startTimer() {
    final timerStateViewModel =
        Provider.of<TimerViewModel>(context, listen: false);
    timerStateViewModel.timerStart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appViewModel = Provider.of<AppViewModel>(context);
    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            child: TimerImage(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Column(children: [
                        const TimerDisplay(),
                        Row(
                          children: [
                            SettingToggle(
                              isActive: appViewModel.vibration,
                              icon: Icons.vibration,
                              label: "진동",
                              onTap: () => appViewModel.vibration =
                                  !appViewModel.vibration,
                            ),
                            const SizedBox(width: 16),
                            SettingToggle(
                              isActive: appViewModel.keepScreenOn,
                              icon: Icons.remove_red_eye_outlined,
                              label: "화면",
                              onTap: () => appViewModel.keepScreenOn =
                                  !appViewModel.keepScreenOn,
                            ),
                          ],
                        ),
                      ]),
                    ),
                    const Expanded(
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
