import 'package:flutter/material.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:pomodak/views/screens/group_timer/widgets/members_grid_view.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_display.dart';
import 'package:pomodak/views/screens/timer/widgets/timer_stop_button.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class GroupTimerPage extends StatefulWidget {
  const GroupTimerPage({super.key});

  @override
  State<GroupTimerPage> createState() => _GroupTimerPageState();
}

class _GroupTimerPageState extends State<GroupTimerPage> {
  GroupTimerViewModel? _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = Provider.of<GroupTimerViewModel>(context, listen: false);
    // 위젯이 완전히 빌드된 뒤 실행함
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startTimer();
      _maybeEnableWakeLock();
      _connectToSocket();
    });
  }

  void _startTimer() {
    final timerStateViewModel =
        Provider.of<TimerStateViewModel>(context, listen: false);
    timerStateViewModel.timerStart();
  }

  void _maybeEnableWakeLock() {
    final appViewModel = Provider.of<AppViewModel>(context, listen: false);
    if (appViewModel.keepScreenOn) {
      WakelockPlus.enable();
    }
  }

  @override
  void dispose() {
    _viewModel?.disconnect();
    WakelockPlus.disable();
    super.dispose();
  }

  void _connectToSocket() async {
    final AuthTokens? tokens =
        await Provider.of<AuthViewModel>(context, listen: false).getTokens();
    String? accessToken = tokens?.accessToken;
    if (accessToken != null && mounted) {
      _viewModel?.connectAndListen(accessToken: accessToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: MembersGridView(),
          ),
          Expanded(
            flex: 2,
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
