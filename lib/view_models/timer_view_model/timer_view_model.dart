import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/timer_state_repository.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/utils/local_notification_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/pomodoro_manager.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_difference_handler.dart';
import 'package:pomodak/view_models/timer_view_model/timer_manager.dart';

enum PomodoroMode { focus, rest }

class TimerViewModel with ChangeNotifier, WidgetsBindingObserver {
  // DI
  final TimerStateRepository repository;
  final TimerRecordViewModel timerRecordViewModel;
  final TimerOptionsViewModel timerOptionsViewModel;
  final PomodoroManager pomodoroManager;

  // State
  final TimerManager _timerManager = TimerManager();
  final TimerDifferenceHandler _timerDifferenceHandler =
      TimerDifferenceHandler.instance;
  bool _isBackgroundRunning = false; // 앱이 백그라운드에서 실행중인지 여부
  AppLifecycleState?
      _lastLifecycleState; // 직전 lifecycle 상태 (상단바를 내리고 다시 올릴 때 resume이 호출되는 문제 해결용)

  // Getter
  int get elapsedSeconds => _timerManager.elapsedSeconds;
  bool get isRunning => _timerManager.isRunning;
  int get sectionCounts => pomodoroManager.sectionCounts;
  PomodoroMode get pomodoroMode => pomodoroManager.pomodoroMode;

  TimerViewModel({
    required this.repository,
    required this.timerRecordViewModel,
    required this.timerOptionsViewModel,
  }) : pomodoroManager = PomodoroManager(
          timerOptionsViewModel: timerOptionsViewModel,
          repository: repository,
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

  // timerOptions의 특정 값들의 변경 이벤트를 감지하여 타이머 상태 초기화
  void _onTimerOptionsChanged() {
    if (timerOptionsViewModel.lastEvent != null &&
        (timerOptionsViewModel.lastEvent!.isPomodoroModeChanged ||
            timerOptionsViewModel.lastEvent!.workTimeChanged ||
            timerOptionsViewModel.lastEvent!.restTimeChanged ||
            timerOptionsViewModel.lastEvent!.sectionsChanged)) {
      pomodoroManager.reset();
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // 모바일 상다바를 내리고 다시 올릴 때 resume이 호출되기 때문에 pause 상태에서 resume으로 전환되는 경우만 처리
    // 상단바를 내릴떄: inactive
    // 상단바를 올릴때: resumed
    // 포그라운드 전환: hidden -> inactive -> resumed
    // 백그라운드 전환: inactive -> hidden -> paused
    if (_lastLifecycleState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
      _handleAppResumed();

      _lastLifecycleState = state;
    } else if (state == AppLifecycleState.paused) {
      _handleAppPaused();

      _lastLifecycleState = state;
    }
  }

  /// 백그라운드 전환 시 타이머 일시정지 & 전환된 시간 저장
  /// 뽀모도로 모드면 남은 시간을 계산하여 로컬 알람 스케줄링
  void _handleAppPaused() {
    _isBackgroundRunning = _timerManager.isRunning;
    if (_timerManager.isRunning) {
      _timerManager.pause();

      if (timerOptionsViewModel.isPomodoroMode) {
        int remainingTime =
            pomodoroManager.getTargetSeconds() - _timerManager.elapsedSeconds;
        LocalNotificationUtil.schedulePomodoroNotification(
          seconds: remainingTime,
          pomodoroMode: pomodoroManager.pomodoroMode,
        );
      }

      _timerDifferenceHandler.setPuasedAt();
      notifyListeners();
    }
  }

  /// 포그라운드 전환 시 타이머 재개 & 스케줄링된 뽀모도로 알람 취소
  /// 백그라운드에서 실행중이었던 경우 타이머에 백그라운드에서 경과한 시간 추가
  /// 뽀모도로 모드 & 타이머 종료 시 pomodoroEnd() 호출
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
          pomodoroEnd(isEndedInBackground: true);
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

  // 일반 타이머 종료
  void normalEnd() {
    getIt<TimerAlarmViewModel>().setAlarm(
      AlarmType.normal,
      _timerManager.elapsedSeconds,
      false,
    );
    _recordTimerSession(time: _timerManager.elapsedSeconds, isCompleted: false);
    _timerManager.stop();
    notifyListeners();
  }

  // 뽀모도로 타이머 종료
  void pomodoroEnd({required bool isEndedInBackground}) {
    getIt<TimerAlarmViewModel>().setAlarm(
      pomodoroMode == PomodoroMode.focus
          ? pomodoroManager.sectionCounts + 1 == timerOptionsViewModel.sections
              ? AlarmType.finish
              : AlarmType.work
          : AlarmType.rest,
      pomodoroManager.getTargetSeconds(),
      isEndedInBackground,
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

  // 뽀모도로 타이머 생략(휴식 모드)
  void pomodoroPass() {
    _timerManager.stop();
    pomodoroManager.nextPhase();
  }

  // 뽀모도로 타이머 포기(집중 모드)
  void pomodoroGiveUp() async {
    getIt<TimerAlarmViewModel>().setAlarm(
      AlarmType.giveup,
      _timerManager.elapsedSeconds,
      false,
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

  // 타이머 일시정지
  void togglePause() {
    if (_timerManager.isRunning) {
      _timerManager.pause();
    } else {
      timerStart();
    }
    notifyListeners();
  }

  // 뽀모도로 타이머가 종료되었는지 확인하고 pomodoroEnd() 호출
  void _checkAndHandleTargetReached(int seconds) {
    if (!timerOptionsViewModel.isPomodoroMode) return;
    final targetReached = seconds >= pomodoroManager.getTargetSeconds();

    if (targetReached) {
      pomodoroEnd(isEndedInBackground: false);
    }
  }

  // 타이머 세션을 기록
  void _recordTimerSession(
      {required int time, required bool isCompleted}) async {
    await timerRecordViewModel.saveRecord(
      date: DateTime.now(),
      seconds: time,
      isCompleted: isCompleted,
    );
  }
}
