import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/timer_alarm/timer_alarm_page.dart';

enum PomodoroMode { focus, rest }

class TimerStateViewModel with ChangeNotifier {
  late final TimerStateStorage storage;
  late final TimerRecordViewModel timerRecordViewModel;
  late final TimerOptionsViewModel timerOptionsViewModel;
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

  void _tick(BuildContext context) {
    if (!isRunning) return;
    _elapsedSeconds++;

    if (timerOptionsViewModel.isPomodoroMode == true) {
      // 뽀모도로 타이머
      int targetSeconds;
      if (_pomodoroMode == PomodoroMode.focus) {
        targetSeconds = timerOptionsViewModel.workTime * 60;
      } else {
        targetSeconds = timerOptionsViewModel.restTime * 60;
      }

      if (_elapsedSeconds >= targetSeconds) {
        pomodoroEnd(context);
      } else {
        notifyListeners();
      }
    } else {
      // 일반 타이머
      notifyListeners();
    }
  }

  // 뽀모도로 모드 타이머
  void pomodoroStart(BuildContext context) {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => _tick(context),
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

  void pomodoroEnd(BuildContext context) async {
    pomodoroStop();

    if (pomodoroMode == PomodoroMode.focus) {
      await timerRecordViewModel.saveRecord(
        date: DateTime.now(),
        seconds: timerOptionsViewModel.workTime * 60,
        isCompleted: true,
      );
    }
    var prev = pomodoroMode;
    pomodoroNext();
    if (prev == PomodoroMode.focus) {
      if (sectionCounts == 0) {
        // 사이클 완료 알람 dialog
        if (context.mounted) {
          context.go(
            "/timer-alarm",
            extra: AlarmInfo(
              alarmType: AlarmType.finish,
              time: timerOptionsViewModel.workTime * 60,
            ),
          );
        }
      } else {
        // 집중 끝 알람 dialog
        if (context.mounted) {
          context.go(
            "/timer-alarm",
            extra: AlarmInfo(
              alarmType: AlarmType.work,
              time: timerOptionsViewModel.workTime * 60,
            ),
          );
        }
      }
    } else {
      // 휴식 끝 알람 dialog
      if (context.mounted) {
        context.go(
          "/timer-alarm",
          extra: AlarmInfo(
            alarmType: AlarmType.rest,
            time: timerOptionsViewModel.restTime * 60,
          ),
        );
      }
    }
  }

  void pomodoroNext() {
    if (sectionCounts + 1 >= timerOptionsViewModel.sections) {
      // 한 사이클 완료
      _pomodoroMode = PomodoroMode.focus;
      _sectionCounts = 0;
    } else if (_pomodoroMode == PomodoroMode.focus) {
      _pomodoroMode = PomodoroMode.rest;
      _sectionCounts = sectionCounts + 1;
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

  void pomodoroInterupt(BuildContext context) async {
    final int time = _elapsedSeconds;
    pomodoroStop();
    if (pomodoroMode == PomodoroMode.focus) {
      await timerRecordViewModel.saveRecord(
        date: DateTime.now(),
        seconds: time,
        isCompleted: false,
      );
    }
    notifyListeners();
    if (context.mounted) {
      context.go(
        "/timer-alarm",
        extra: AlarmInfo(
          alarmType: AlarmType.giveup,
          time: time,
        ),
      );
    }
  }

  // 일반 모드 타이머
  void normalStart(BuildContext context) {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => _tick(context),
      );
      notifyListeners();
    }
  } // 0부터 증가하는 타이머

  void normalEnd(BuildContext context) async {
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

      if (context.mounted) {
        context.go(
          "/timer-alarm",
          extra: AlarmInfo(
            alarmType: AlarmType.normal,
            time: time,
          ),
        );
      }
    }
  }

  // 타이머 일시정지
  void pauseToggle() {
    _isRunning = !_isRunning;
    notifyListeners();
  }
}
