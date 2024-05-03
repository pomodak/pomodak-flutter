import 'package:pomodak/di.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/base_timer.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';

enum PomodoroPhase { focus, rest }

class PomodoroTimer extends BaseTimer {
  final TimerOptionsViewModel timerOptionsViewModel;

  PomodoroPhase pomodoroPhase = PomodoroPhase.focus;
  int curSections = 0;

  Future<void> Function({
    required int time,
    required bool isCompleted,
  }) saveRecord;

  void Function({
    required AlarmType type,
    required int elapsedSeconds,
    required bool endedInBackground,
    int? earnedPoints,
  }) setAlarm;

  PomodoroTimer({
    required this.saveRecord,
    required this.setAlarm,
    required this.timerOptionsViewModel,
  });

  @override
  bool shouldEnd() {
    // 목표시간 달성 시 종료
    return elapsedSeconds >= getTargetSeconds();
  }

  /// 타이머 종료(shouldEnd) 후 처리할 작업 (알람, 다음 세션, 기록 저장 등)
  ///
  /// isEndedInBackground: 백그라운드에서 종료되었을때 (true: 알람페이지에서 진동을 울리지 않음)
  @override
  Future<void> endSession({bool isEndedInBackground = false}) async {
    int focusSeconds = getTargetSeconds();
    int earnedPoints =
        getIt<TransactionViewModel>().calcPointsFromFocusSeconds(focusSeconds);
    if (pomodoroPhase == PomodoroPhase.focus) {
      saveRecord(time: focusSeconds, isCompleted: true);
      getIt<TransactionViewModel>().rewardPoints(earnedPoints);
    }
    setAlarm(
      type: pomodoroPhase == PomodoroPhase.focus
          ? AlarmType.work
          : curSections == timerOptionsViewModel.sections
              ? AlarmType.finish
              : AlarmType.rest,
      elapsedSeconds: focusSeconds,
      endedInBackground: isEndedInBackground,
      earnedPoints: pomodoroPhase == PomodoroPhase.focus ? earnedPoints : null,
    );
    _nextPhase();
  }

  @override
  void interuptSession() async {
    int earnedPoints = getIt<TransactionViewModel>()
        .calcPointsFromFocusSeconds(elapsedSeconds);

    if (pomodoroPhase == PomodoroPhase.focus) {
      // 집중 모드 중단 시 시간 기록 후 단계 유지
      setAlarm(
        type: AlarmType.giveup,
        elapsedSeconds: elapsedSeconds,
        endedInBackground: false,
        earnedPoints: earnedPoints,
      );
      saveRecord(time: elapsedSeconds, isCompleted: false);
      getIt<TransactionViewModel>().rewardPoints(earnedPoints);
    } else {
      // 휴식 모드 중단 시 다음 세션으로 이동
      setAlarm(
        type: curSections == timerOptionsViewModel.sections
            ? AlarmType.finish
            : AlarmType.rest,
        elapsedSeconds: 0,
        endedInBackground: false,
      );
      _nextPhase();
    }
  }

  int getTargetSeconds() {
    return pomodoroPhase == PomodoroPhase.focus
        ? timerOptionsViewModel.workTime * 60
        : timerOptionsViewModel.restTime * 60;
  }

  // 뽀모도로 다음 단계로 이동
  void _nextPhase() {
    if (pomodoroPhase == PomodoroPhase.focus) {
      pomodoroPhase = PomodoroPhase.rest;
      curSections++;
    } else {
      pomodoroPhase = PomodoroPhase.focus;
      if (curSections == timerOptionsViewModel.sections) {
        pomodoroPhase = PomodoroPhase.focus;
        curSections = 0;
      }
    }
    elapsedSeconds = 0;
  }
}
