import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

enum PomodoroMode { focus, rest }

class TimerStateViewModel with ChangeNotifier {
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
  // DateTime? _backgroundTime; // 백그라운드로 전환된 시간

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
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => _tick(onTimerEnd),
    );
    notifyListeners();
  }

  void _timerStop() {
    if (!_isRunning) return;
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void normalEnd(Function(AlarmType, int) onTimerEnd) {
    if (!_isRunning) return;
    int time = _elapsedSeconds;
    _timerStop();
    _recordTimerSession(time: time, isCompleted: false);
    notifyListeners();
    onTimerEnd(AlarmType.normal, time);
  }

  void pomodoroEnd(Function(AlarmType, int) onTimerEnd) {
    if (!_isRunning) return;
    _timerStop();

    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(
        time: timerOptionsViewModel.workTime * 60,
        isCompleted: true,
      );
    }

    _pomodoroNext();
    _notifyEndBasedOnMode(onTimerEnd);
  }

  void pomodoroPass() {
    _timerStop();
    _pomodoroNext();
  }

  void pomodoroGiveUp(Function(AlarmType, int) onTimerEnd) async {
    final int time = _elapsedSeconds;
    _timerStop();
    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(time: time, isCompleted: false);
    }
    notifyListeners();
    onTimerEnd(AlarmType.giveup, time);
  }

  void togglePause() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void _tick(Function(AlarmType, int) onTimerEnd) {
    if (!isRunning) return;

    _updateElapsedTime();
    _checkAndHandleTargetReached(onTimerEnd);
  }

  void _updateElapsedTime() {
    _elapsedSeconds++;
    notifyListeners();
  }

  void _checkAndHandleTargetReached(Function(AlarmType, int) onTimerEnd) {
    if (!timerOptionsViewModel.isPomodoroMode) return;

    final targetReached = _elapsedSeconds >= _getTargetSeconds();
    if (targetReached) {
      pomodoroEnd(onTimerEnd);
    }
  }

  void _notifyEndBasedOnMode(Function(AlarmType, int) onTimerEnd) {
    AlarmType alarmType;

    if (_pomodoroMode == PomodoroMode.focus) {
      alarmType = _sectionCounts == 0 ? AlarmType.finish : AlarmType.work;
    } else {
      alarmType = AlarmType.rest;
    }

    _recordTimerSession(time: _getTargetSeconds(), isCompleted: true);

    onTimerEnd(alarmType, _getTargetSeconds());

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
