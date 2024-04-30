import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pomodak/data/repositories/timer_state_repository.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/utils/local_notification_util.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/base_timer.dart';
import 'package:pomodak/view_models/timer_view_model/normal_timer.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/pomodoro_timer.dart';
import 'package:pomodak/view_models/timer_view_model/timer_difference_handler.dart';

enum PomodoroMode { focus, rest }

class TimerViewModel with ChangeNotifier, WidgetsBindingObserver {
  // DI
  final TimerStateRepository repository;
  final TimerOptionsViewModel timerOptionsViewModel;

  // State
  BaseTimer _curTimer = BaseTimer();
  final TimerDifferenceHandler _timerDifferenceHandler =
      TimerDifferenceHandler.instance;
  bool _isBackgroundRunning = false; // 앱이 백그라운드에서 실행중인지 여부
  AppLifecycleState?
      _lastLifecycleState; // 직전 lifecycle 상태 (상단바를 내리고 다시 올릴 때 resume이 호출되는 문제 해결용)

  // Getter
  int get elapsedSeconds => _curTimer.elapsedSeconds;
  bool get isRunning => _curTimer.isRunning;
  int get sectionCounts =>
      _curTimer is PomodoroTimer ? (_curTimer as PomodoroTimer).curSections : 0;
  PomodoroPhase get pomodoroPhase => _curTimer is PomodoroTimer
      ? (_curTimer as PomodoroTimer).pomodoroPhase == PomodoroPhase.focus
          ? PomodoroPhase.focus
          : PomodoroPhase.rest
      : PomodoroPhase.focus;

  TimerViewModel({
    required this.repository,
    required this.timerOptionsViewModel,
  }) {
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addObserver(this);
    if (timerOptionsViewModel.isPomodoroMode) {
      switchPomodoroMode();
    } else {
      switchNormalMode();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
    _isBackgroundRunning = _curTimer.isRunning;
    if (_curTimer.isRunning) {
      _curTimer.pause();

      if (timerOptionsViewModel.isPomodoroMode && _curTimer is PomodoroTimer) {
        int remainingTime = (_curTimer as PomodoroTimer).getTargetSeconds() -
            _curTimer.elapsedSeconds;
        LocalNotificationUtil.schedulePomodoroNotification(
          seconds: remainingTime,
          pomodoroPhase: (_curTimer as PomodoroTimer).pomodoroPhase,
        );

        if (kDebugMode) {
          print('$remainingTime초 후 알람이 울립니다.');
        }
      }

      _timerDifferenceHandler.setPuasedAt();
      notifyListeners();
    }
  }

  /// 포그라운드 전환 시 타이머 재개 & 스케줄링된 뽀모도로 알람 취소
  /// 백그라운드에서 실행중이었던 경우 타이머에 백그라운드에서 경과한 시간 추가
  /// 뽀모도로 모드 & 타이머 종료 시 재시작 하지 않고 endSession(true) 호출
  void _handleAppResumed() {
    LocalNotificationUtil.canclePomodoroNotification();
    if (kDebugMode) {
      print('알림예약 취소');
    }
    if (_isBackgroundRunning) {
      _curTimer.addTime(_timerDifferenceHandler.getTimerGapSeconds());
      notifyListeners();
      // 뽀모도로 모드면 종료된지 체크 후 종료 처리
      if (timerOptionsViewModel.isPomodoroMode && _curTimer is PomodoroTimer) {
        if (_curTimer.shouldEnd()) {
          (_curTimer as PomodoroTimer).endSession(isEndedInBackground: true);
          return;
        }
      }
      timerStart();
    }
  }

  // 타이머 시작
  void timerStart() {
    _curTimer.start(onUpdate: () {
      notifyListeners();
    });
    notifyListeners();
  }

  // 일반 타이머 종료
  void normalEnd() {
    _curTimer.stop();
    notifyListeners();
  }

  // 뽀모도로 타이머 종료
  void pomodoroEnd({required bool isEndedInBackground}) {
    _curTimer.stop();
    notifyListeners();
  }

  // 뽀모도로 타이머 생략(휴식 모드)
  void pomodoroPass() {
    _curTimer.stop();
    notifyListeners();
  }

  // 뽀모도로 타이머 포기(집중 모드)
  void pomodoroGiveUp() {
    _curTimer.stop();
    notifyListeners();
  }

  // 타이머 일시정지
  void togglePause() {
    if (_curTimer.isRunning) {
      _curTimer.pause();
    } else {
      timerStart();
    }
    notifyListeners();
  }

  // 뽀모도로 모드로 전환
  void switchPomodoroMode() {
    _curTimer = PomodoroTimer(
      saveRecord: _recordTimerSession,
      setAlarm: getIt<TimerAlarmViewModel>().setAlarm,
      timerOptionsViewModel: timerOptionsViewModel,
    );
    notifyListeners();
  }

  // 일반 모드로 전환
  void switchNormalMode() {
    _curTimer = NormalTimer(
      saveRecord: _recordTimerSession,
      setAlarm: getIt<TimerAlarmViewModel>().setAlarm,
    );
    notifyListeners();
  }

  // 타이머 세션을 기록
  Future<void> _recordTimerSession(
      {required int time, required bool isCompleted}) async {
    getIt<TimerRecordViewModel>().saveRecord(
      date: DateTime.now(),
      seconds: time,
      isCompleted: isCompleted,
    );
  }
}
