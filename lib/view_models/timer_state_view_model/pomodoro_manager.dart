import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';

class PomodoroManager {
  final TimerStateStorage storage;
  PomodoroMode pomodoroMode = PomodoroMode.focus;
  int sectionCounts = 0;
  final TimerOptionsViewModel timerOptionsViewModel;

  PomodoroManager({
    required this.timerOptionsViewModel,
    required this.storage,
  }) {
    pomodoroMode = storage.getCurPomodoroMode();
    sectionCounts = storage.getCurSections();
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
    storage.saveTimerState(
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
    storage.saveTimerState(
      curPomodoroMode: pomodoroMode,
      curSections: sectionCounts,
    );
  }
}
