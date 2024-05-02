import 'package:flutter/material.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/screens/group_timer/widgets/members_grid_view.dart';
import 'package:pomodak/views/screens/timer/widgets/alarm_handler.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_settings_row.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_stop_button.dart';
import 'package:pomodak/views/widgets/ads/ad_banner.dart';
import 'package:provider/provider.dart';

class GroupTimerPage extends StatefulWidget {
  const GroupTimerPage({super.key});

  @override
  State<GroupTimerPage> createState() => _GroupTimerPageState();
}

class _GroupTimerPageState extends State<GroupTimerPage> {
  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 빌드된 뒤 타이머 시작 & 소켓 연결
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<TimerViewModel>().timerStart();
      _connectToSocket();
    });
  }

  @override
  void dispose() {
    getIt<GroupTimerViewModel>().disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupAlarmHandler(context);

    return Scaffold(
      body: Column(
        children: [
          const Expanded(
            flex: 5,
            child: MembersGridView(),
          ),
          Expanded(
            flex: 4,
            child: _buildTimerControls(),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToSocket() async {
    final AuthTokens? tokens = await getIt<AuthViewModel>().getTokens();
    String? accessToken = tokens?.accessToken;
    if (accessToken != null && mounted) {
      getIt<GroupTimerViewModel>().connectAndListen(accessToken: accessToken);
    }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TimerDisplay(),
                  TimerSettingsRow(),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      SizedBox(height: 80),
                      TimerStopButton(),
                    ],
                  ),
                  AdBanner(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
