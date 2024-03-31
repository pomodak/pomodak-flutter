import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';

enum TimerMode { focus, rest, normal }

class TimerStateViewModel with ChangeNotifier {
  late TimerOptionsViewModel timerOptions;
  late TimerMode _timerMode;
  Timer? _timer;
  int _elapsedSeconds = 0; // 경과 시간(초 단위)
  DateTime? _backgroundTime; // 백그라운드로 전환된 시간
  bool _isRunning = false; // 타이머 실행 상태

  // 타이머 상태에 대한 Getter
  int get elapsedSeconds => _elapsedSeconds;
  bool get isRunning => _isRunning;

  void update(TimerOptionsViewModel timerOptionsViewModel) {
    timerOptions = timerOptionsViewModel;
    _timerMode =
        timerOptions.isPomodoroMode ? TimerMode.focus : TimerMode.normal;
    _onTimerOptionsChanged();
    notifyListeners();
  }

  void _onTimerOptionsChanged() {
    if (timerOptions.lastEvent != null &&
        (timerOptions.lastEvent!.isPomodoroModeChanged ||
            timerOptions.lastEvent!.workTimeChanged ||
            timerOptions.lastEvent!.restTimeChanged ||
            timerOptions.lastEvent!.sectionsChanged)) {
      resetTimer(
        timerOptions.isPomodoroMode ? TimerMode.focus : TimerMode.normal,
      );
    }
  }

  // 타이머 초기화
  void resetTimer(TimerMode mode) {
    _timerMode = mode;
    _elapsedSeconds = 0;
    _backgroundTime = null;
    _isRunning = false;
    if (_timer != null) _timer!.cancel();
  }
}
