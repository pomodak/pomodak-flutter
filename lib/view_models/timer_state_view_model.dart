import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

enum PomodoroMode { focus, rest }

class TimerStateViewModel with ChangeNotifier, WidgetsBindingObserver {
  // DI
  final TimerStateStorage storage;
  final TimerRecordViewModel timerRecordViewModel;
  final TimerOptionsViewModel timerOptionsViewModel;

  // state
  PomodoroMode _pomodoroMode = PomodoroMode.focus;
  Timer? _timer;
  int _elapsedSeconds = 0; // 경과 시간(초 단위)
  bool _isRunning = false; // 타이머 실행 상태
  int _sectionCounts = 0; // 섹션 수

  // onTimerEnd 콜백 함수를 저장할 변수 추가
  // (null이 아닐 경우 타이머를 진행중인 상태)
  Function(AlarmType, int)? _onTimerEnd;
  // (백그라운드 전환 시 타이머가 실행중이었는지 기록하여 돌아왔을때 처리)
  bool _isBackgroundRunning = false;
  final timerHandler = TimerDifferenceHandler.instance; // 백그라운드 타이머 계산

  // 타이머 상태에 대한 Getter
  int get elapsedSeconds => _elapsedSeconds;
  int get sectionCounts => _sectionCounts;
  bool get isRunning => _isRunning;
  PomodoroMode get pomodoroMode => _pomodoroMode;

  TimerStateViewModel({
    required this.storage,
    required this.timerRecordViewModel,
    required this.timerOptionsViewModel,
  }) {
    _initialize();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        // 앱이 백그라운드로 이동할 때
        _isBackgroundRunning = isRunning; // 전환될때 타이머가 실행중이었는지 기록
        int temp = _elapsedSeconds;
        _timerStop(); // 내부에서 _elaspedSeconds가 초기화 되어서 temp로 복구
        _elapsedSeconds = temp;
        timerHandler.setPuasedAt(); // 백그라운드 전환 시간 기록
        notifyListeners();
        break;
      case AppLifecycleState.resumed:
        // 앱이 다시 활성화될 때
        if (_onTimerEnd != null) {
          timerStart(_onTimerEnd!); // 제거된 타이머 이벤트를 복구
        }
        if (_isBackgroundRunning) {
          _elapsedSeconds += timerHandler.getTimerGapSeconds();
        } else {
          _isRunning = false; // 이전에 일시정지 상태였으면 다시 일시정지 상태로
        }
        notifyListeners();
        break;
      default:
        break;
    }
  }

  void _initialize() {
    _loadState();
    timerOptionsViewModel.addListener(_onTimerOptionsChanged);
  }

  void _loadState() {
    _sectionCounts = storage.getCurSections();
    _pomodoroMode = storage.getCurPomodoroMode();
    notifyListeners();
  }

  void _onTimerOptionsChanged() {
    if (timerOptionsViewModel.lastEvent != null &&
        (timerOptionsViewModel.lastEvent!.isPomodoroModeChanged ||
            timerOptionsViewModel.lastEvent!.workTimeChanged ||
            timerOptionsViewModel.lastEvent!.restTimeChanged ||
            timerOptionsViewModel.lastEvent!.sectionsChanged)) {
      resetTimerState();
    }
  }

  // 타이머 상태 초기화 (옵션 변경 시 호출)
  void resetTimerState() {
    _pomodoroMode = PomodoroMode.focus;
    _sectionCounts = 0;
    _elapsedSeconds = 0;
    // _backgroundTime = null;
    _isRunning = false;
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    storage.saveTimerState(
      curPomodoroMode: _pomodoroMode,
      curSections: _sectionCounts,
    );
    notifyListeners();
  }

  // 타이머 시작
  void timerStart(Function(AlarmType, int) onTimerEnd) {
    _onTimerEnd = onTimerEnd;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => _tick(),
    );
    notifyListeners();
  }

  void _timerStop() {
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void normalEnd() {
    if (!_isRunning) return;
    int time = _elapsedSeconds;
    _timerStop();
    _recordTimerSession(time: time, isCompleted: false);
    notifyListeners();

    if (_onTimerEnd != null) {
      _onTimerEnd!(AlarmType.giveup, time);
    }
  }

  void pomodoroEnd() {
    if (!_isRunning) return;
    _timerStop();

    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(
        time: timerOptionsViewModel.workTime * 60,
        isCompleted: true,
      );
    }

    _notifyEndBasedOnMode();
    _pomodoroNext();
  }

  void pomodoroPass() {
    _timerStop();
    _pomodoroNext();
  }

  void pomodoroGiveUp() async {
    final int time = _elapsedSeconds;
    _timerStop();
    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(time: time, isCompleted: false);
    }
    notifyListeners();
    if (_onTimerEnd != null) {
      _onTimerEnd!(AlarmType.giveup, time);
    }
  }

  void togglePause() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void _tick() {
    if (!isRunning) return;

    _updateElapsedTime();
    _checkAndHandleTargetReached();
  }

  void _updateElapsedTime() {
    _elapsedSeconds++;
    notifyListeners();
  }

  void _checkAndHandleTargetReached() {
    if (!timerOptionsViewModel.isPomodoroMode) return;

    final targetReached = _elapsedSeconds >= _getTargetSeconds();
    if (targetReached) {
      pomodoroEnd();
    }
  }

  void _notifyEndBasedOnMode() {
    AlarmType alarmType;

    if (_pomodoroMode == PomodoroMode.focus) {
      alarmType = _sectionCounts == timerOptionsViewModel.sections - 1
          ? AlarmType.finish
          : AlarmType.work;
    } else {
      alarmType = AlarmType.rest;
    }

    _recordTimerSession(time: _getTargetSeconds(), isCompleted: true);

    if (_onTimerEnd != null) {
      _onTimerEnd!(alarmType, _getTargetSeconds());
    }
    _onTimerEnd = null; // 알람 이벤트 제거
    notifyListeners();
  }

  int _getTargetSeconds() {
    int targetMinutes = _pomodoroMode == PomodoroMode.focus
        ? timerOptionsViewModel.workTime
        : timerOptionsViewModel.restTime;
    return targetMinutes * 60;
  }

  void _recordTimerSession(
      {required int time, required bool isCompleted}) async {
    await timerRecordViewModel.saveRecord(
      date: DateTime.now(),
      seconds: time,
      isCompleted: isCompleted,
    );
  }

  void _pomodoroNext() {
    if (_pomodoroMode == PomodoroMode.focus) {
      _pomodoroMode = PomodoroMode.rest;
      _sectionCounts = sectionCounts + 1;

      // 한 사이클 완료
      if (_sectionCounts == timerOptionsViewModel.sections) {
        _pomodoroMode = PomodoroMode.focus;
        _sectionCounts = 0;
      }
    } else {
      _pomodoroMode = PomodoroMode.focus;
    }
    storage.saveTimerState(
      curSections: _sectionCounts,
      curPomodoroMode: _pomodoroMode,
    );
    notifyListeners();
  }
}

class TimerDifferenceHandler {
  static late DateTime pausedAt;

  static final TimerDifferenceHandler _instance = TimerDifferenceHandler();

  static TimerDifferenceHandler get instance => _instance;

  int getTimerGapSeconds() {
    final DateTime dateTimeNow = DateTime.now();
    final Duration gapTime = dateTimeNow.difference(pausedAt);
    final int gapSeconds = gapTime.inSeconds;

    return gapSeconds;
  }

  void setPuasedAt() {
    final DateTime dateTimeNow = DateTime.now();
    pausedAt = dateTimeNow;
  }
}
