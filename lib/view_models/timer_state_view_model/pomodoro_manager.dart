import 'package:pomodak/data/repositories/timer_state_repository.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';

// 뽀모도로 모드를 관리하는 클래스
class PomodoroManager {
  final TimerStateRepository repository;
  PomodoroMode pomodoroMode = PomodoroMode.focus;
  int sectionCounts = 0;
  final TimerOptionsViewModel timerOptionsViewModel;

  PomodoroManager({
    required this.timerOptionsViewModel,
    required this.repository,
  }) {
    pomodoroMode = repository.getCurrentPomodoroMode();
    sectionCounts = repository.getCurrentSections();
  }

  void nextPhase() {
    if (pomodoroMode == PomodoroMode.focus) {
      pomodoroMode = PomodoroMode.rest;
      sectionCounts++;
      if (sectionCounts >= timerOptionsViewModel.sections) {
        pomodoroMode = PomodoroMode.focus;
        sectionCounts = 0;
      }
    } else {
      pomodoroMode = PomodoroMode.focus;
    }
    repository.saveTimerState(
      curSections: sectionCounts,
      curPomodoroMode: pomodoroMode,
    );
  }

  int getTargetSeconds() {
    return pomodoroMode == PomodoroMode.focus
        ? timerOptionsViewModel.workTime * 60
        : timerOptionsViewModel.restTime * 60;
  }

  void reset() {
    pomodoroMode = PomodoroMode.focus;
    sectionCounts = 0;
    repository.saveTimerState(
      curPomodoroMode: pomodoroMode,
      curSections: sectionCounts,
    );
  }
}
