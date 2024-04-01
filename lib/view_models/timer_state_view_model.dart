import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';

enum PomodoroMode { focus, rest }

class TimerStateViewModel with ChangeNotifier {
  late TimerOptionsViewModel timerOptions;
  late PomodoroMode _pomodoroMode = PomodoroMode.focus;
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

  void update(TimerOptionsViewModel timerOptionsViewModel) {
    timerOptions = timerOptionsViewModel;
    _onTimerOptionsChanged();
    notifyListeners();
  }

  void _onTimerOptionsChanged() {
    if (timerOptions.lastEvent != null &&
        (timerOptions.lastEvent!.isPomodoroModeChanged ||
            timerOptions.lastEvent!.workTimeChanged ||
            timerOptions.lastEvent!.restTimeChanged ||
            timerOptions.lastEvent!.sectionsChanged)) {
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
    notifyListeners();
  }

  void _tick() {
    if (!isRunning) return;
    _elapsedSeconds++;

    if (timerOptions.isPomodoroMode == true) {
      // 뽀모도로 타이머
      int targetSeconds;
      if (_pomodoroMode == PomodoroMode.focus) {
        targetSeconds = timerOptions.workTime * 60;
      } else {
        targetSeconds = timerOptions.restTime * 60;
      }

      if (_elapsedSeconds >= targetSeconds) {
        pomodoroEnd();
      } else {
        notifyListeners();
      }
    } else {
      // 일반 타이머
      notifyListeners();
    }
  }

  // 뽀모도로 모드 타이머
  void pomodoroStart() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => _tick(),
      );
      notifyListeners();
    }
  }

  void pomodoroStop() {
    if (_isRunning) {
      _timer?.cancel();
      _timer = null;
      _isRunning = false;
      _elapsedSeconds = 0;
      notifyListeners();
    }
  }

  void pomodoroEnd() {
    pomodoroStop();

    if (pomodoroMode == PomodoroMode.focus) {
      saveRecord(timerOptions.workTime * 60, true, "default");
    }
    var prev = pomodoroMode;
    pomodoroNext();

    if (prev == PomodoroMode.focus) {
      if (sectionCounts == 0) {
        // 사이클 완료 알람 dialog
      } else {
        // 집중 끝 알람 dialog
      }
    } else {
      // 휴식 끝 알람 dialog
    }
  }

  void pomodoroNext() {
    if (sectionCounts + 1 >= timerOptions.sections) {
      // 한 사이클 완료
      _pomodoroMode = PomodoroMode.focus;
      _sectionCounts = 0;
    } else if (_pomodoroMode == PomodoroMode.focus) {
      _pomodoroMode = PomodoroMode.rest;
      _sectionCounts = sectionCounts + 1;
    } else {
      _pomodoroMode = PomodoroMode.focus;
    }
    notifyListeners();
  }

  void pomodoroInterupt() {
    pomodoroStop();
    _elapsedSeconds = 0;
    notifyListeners();
  }

  // 일반 모드 타이머
  void normalStart() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => _tick(),
      );
      notifyListeners();
    }
  } // 0부터 증가하는 타이머

  void normalEnd() {
    if (_isRunning) {
      _timer?.cancel();
      _timer = null;
      _isRunning = false;

      saveRecord(elapsedSeconds, false, "default");
      _elapsedSeconds = 0;
      notifyListeners();
    }
  }

  // 타이머 기록 (storage로 구현할 예정)
  // [DateTime] : {int totalSeconds, int totalCompleted, List<String, int> details}도 함께기록
  // List는 {category: totalSeconds}이고 카테고리는 기본값 default를 가짐
  // 저장할때 키가 존재하는지 확인 해서 없으면 생성 후 넣기, 있으면 totalSeconds 추가
  void saveRecord(int seconds, bool isCompleted, String? category) {}

  // 타이머 일시정지
  void pauseToggle() {
    _isRunning = !_isRunning;
    notifyListeners();
  }
}
