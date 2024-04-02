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

  // 타이머 상태 초기화
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

  void _tick(Function(AlarmType, int) onTimerEnd) {
    if (!isRunning) return;

    _elapsedSeconds++;

    // 뽀모도로 모드 & 타이머 목표에 도달
    if (timerOptionsViewModel.isPomodoroMode == true) {
      final targetSeconds = _getTargetSeconds();
      if (_elapsedSeconds >= targetSeconds) {
        pomodoroEnd(onTimerEnd);
        return;
      }
    }
    notifyListeners();
  }

  // 뽀모도로 모드 타이머
  void pomodoroStart(Function(AlarmType, int) onTimerEnd) {
    if (_isRunning) return;
    _isRunning = true;
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => _tick(onTimerEnd),
    );
    notifyListeners();
  }

  // 타이머 멈추기 & elapsedSeconds 초기화
  void _pomodoroStop() {
    if (!_isRunning) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    _elapsedSeconds = 0;
    notifyListeners();
  }

  // 타이머
  void pomodoroEnd(Function(AlarmType, int) onTimerEnd) async {
    _pomodoroStop();

    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(isCompleted: true);
    }
    var prev = pomodoroMode;
    pomodoroNext();
    if (prev == PomodoroMode.focus) {
      if (sectionCounts == 0) {
        // 사이클 완료 알람 dialog
        onTimerEnd(AlarmType.finish, timerOptionsViewModel.workTime * 60);
      } else {
        // 집중 끝 알람 dialog
        onTimerEnd(AlarmType.work, timerOptionsViewModel.workTime * 60);
      }
    } else {
      // 휴식 끝 알람 dialog
      onTimerEnd(AlarmType.rest, timerOptionsViewModel.restTime * 60);
    }
  }

  void pomodoroNext() {
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
    _elapsedSeconds = 0;
    notifyListeners();
  }

  void pomodoroInterupt(Function(AlarmType, int) onTimerEnd) async {
    final int time = _elapsedSeconds;
    _pomodoroStop();
    if (pomodoroMode == PomodoroMode.focus) {
      _recordTimerSession(isCompleted: false);
    }
    notifyListeners();
    onTimerEnd(
      AlarmType.giveup,
      time,
    );
  }

  // 일반 모드 타이머
  void normalStart(Function(AlarmType, int) onTimerEnd) {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => _tick(onTimerEnd),
      );
      notifyListeners();
    }
  } // 0부터 증가하는 타이머

  void normalEnd(Function(AlarmType, int) onTimerEnd) async {
    if (_isRunning) {
      final int time = _elapsedSeconds;
      _timer?.cancel();
      _timer = null;
      _isRunning = false;
      _elapsedSeconds = 0;

      await timerRecordViewModel.saveRecord(
        date: DateTime.now(),
        seconds: time,
        isCompleted: false,
      );
      notifyListeners();
      onTimerEnd(AlarmType.normal, time);
    }
  }

  // 타이머 일시정지
  void pauseToggle() {
    _isRunning = !_isRunning;
    notifyListeners();
  }

  int _getTargetSeconds() {
    int targetMinutes = _pomodoroMode == PomodoroMode.focus
        ? timerOptionsViewModel.workTime
        : timerOptionsViewModel.restTime;
    return targetMinutes * 60;
  }

  // 기록
  void _recordTimerSession({required bool isCompleted}) async {
    await timerRecordViewModel.saveRecord(
      date: DateTime.now(),
      seconds: _elapsedSeconds,
      isCompleted: isCompleted,
    );
  }
}
