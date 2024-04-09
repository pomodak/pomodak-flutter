import 'package:flutter/material.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/utils/local_notification_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/pomodoro_manager.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_end_state.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_difference_handler.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_manager.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

enum PomodoroMode { focus, rest }

class TimerStateViewModel with ChangeNotifier, WidgetsBindingObserver {
  // DI
  final TimerStateStorage storage;
  final TimerRecordViewModel timerRecordViewModel;
  final TimerOptionsViewModel timerOptionsViewModel;
  final PomodoroManager pomodoroManager;

  // state
  final TimerManager _timerManager = TimerManager();
  final TimerDifferenceHandler _timerDifferenceHandler =
      TimerDifferenceHandler.instance;
  final TimerEndState _timerEndState = TimerEndState();

  // (백그라운드 전환 시 타이머가 실행중이었는지 기록하여 돌아왔을때 처리)
  bool _isBackgroundRunning = false;

  // 타이머 상태에 대한 Getter
  int get elapsedSeconds => _timerManager.elapsedSeconds;
  bool get isRunning => _timerManager.isRunning;
  int get sectionCounts => pomodoroManager.sectionCounts;
  PomodoroMode get pomodoroMode => pomodoroManager.pomodoroMode;
  bool get isTimerEnded => _timerEndState.isTimerEnded;
  AlarmType? get lastAlarmType => _timerEndState.lastAlarmType;
  int? get lastElaspedSeconds => _timerEndState.lastElapsedSeconds;

  TimerStateViewModel({
    required this.storage,
    required this.timerRecordViewModel,
    required this.timerOptionsViewModel,
  }) : pomodoroManager = PomodoroManager(
          timerOptionsViewModel: timerOptionsViewModel,
          storage: storage,
        ) {
    _init();
  }

  void _init() {
    timerOptionsViewModel.addListener(_onTimerOptionsChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timerManager.stop();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //  timerOptions의 특정 값들의 변경 이벤트를 감지하여 타이머 상태 초기화
  void _onTimerOptionsChanged() {
    if (timerOptionsViewModel.lastEvent != null &&
        (timerOptionsViewModel.lastEvent!.isPomodoroModeChanged ||
            timerOptionsViewModel.lastEvent!.workTimeChanged ||
            timerOptionsViewModel.lastEvent!.restTimeChanged ||
            timerOptionsViewModel.lastEvent!.sectionsChanged)) {
      pomodoroManager.reset();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 이동할 때
        _handleAppPaused();
      case AppLifecycleState.resumed:
        // 앱이 다시 활성화될 때
        _handleAppResumed();
        break;
      default:
        break;
    }
  }

  void _handleAppPaused() {
    _isBackgroundRunning = _timerManager.isRunning;
    if (_timerManager.isRunning) {
      _timerManager.pause();
      int remainingTime =
          pomodoroManager.getTargetSeconds() - _timerManager.elapsedSeconds;
      LocalNotificationUtil.schedulePomodoroNotification(
        seconds: remainingTime,
        pomodoroMode: pomodoroManager.pomodoroMode,
      );
      _timerDifferenceHandler.setPuasedAt();
      notifyListeners();
    }
  }

  void _handleAppResumed() {
    LocalNotificationUtil.canclePomodoroNotification();
    if (_isBackgroundRunning) {
      _timerManager.addTime(_timerDifferenceHandler.getTimerGapSeconds());
      notifyListeners();
      // 뽀모도로 모드면 종료된지 체크 후 종료 처리
      if (timerOptionsViewModel.isPomodoroMode) {
        final targetReached =
            _timerManager.elapsedSeconds >= pomodoroManager.getTargetSeconds();
        if (targetReached) {
          pomodoroEnd();
          return;
        }
      }
      timerStart();
    }
  }

  // 타이머 시작
  void timerStart() {
    _timerManager.startOrResume(onTickCallback: (int seconds) {
      _checkAndHandleTargetReached(seconds);
      notifyListeners();
    });
    notifyListeners();
  }

  void normalEnd() {
    _timerEndState.setTimerEndState(
      AlarmType.normal,
      pomodoroManager.getTargetSeconds(),
    );
    _recordTimerSession(time: _timerManager.elapsedSeconds, isCompleted: false);
    _timerManager.stop();
    notifyListeners();
  }

  void pomodoroEnd() {
    _timerEndState.setTimerEndState(
      pomodoroMode == PomodoroMode.focus
          ? pomodoroManager.sectionCounts + 1 == timerOptionsViewModel.sections
              ? AlarmType.finish
              : AlarmType.work
          : AlarmType.rest,
      pomodoroManager.getTargetSeconds(),
    );

    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(
        time: pomodoroManager.getTargetSeconds(),
        isCompleted: true,
      );
    }
    _timerManager.stop();
    pomodoroManager.nextPhase();
  }

  void pomodoroPass() {
    _timerManager.stop();
    pomodoroManager.nextPhase();
  }

  void pomodoroGiveUp() async {
    _timerEndState.setTimerEndState(
      AlarmType.giveup,
      _timerManager.elapsedSeconds,
    );

    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(
        time: _timerManager.elapsedSeconds,
        isCompleted: false,
      );
    }
    _timerManager.stop();
    notifyListeners();
  }

  void togglePause() {
    if (_timerManager.isRunning) {
      _timerManager.pause();
    } else {
      timerStart();
    }
    notifyListeners();
  }

  // 알람 표시 후 타이머 종료 상태를 리셋하는 메서드
  void resetTimerEndStatus() {
    _timerEndState.reset();
    notifyListeners();
  }

  void _checkAndHandleTargetReached(int seconds) {
    if (!timerOptionsViewModel.isPomodoroMode) return;
    final targetReached = seconds >= pomodoroManager.getTargetSeconds();

    if (targetReached) {
      pomodoroEnd();
    }
  }

  void _recordTimerSession(
      {required int time, required bool isCompleted}) async {
    await timerRecordViewModel.saveRecord(
      date: DateTime.now(),
      seconds: time,
      isCompleted: isCompleted,
    );
  }
}
