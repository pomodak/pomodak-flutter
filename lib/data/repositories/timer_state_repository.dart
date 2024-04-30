import 'package:pomodak/data/datasources/local/timer_state_local_datasource.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';

class TimerStateRepository {
  final TimerStateLocalDataSource localDataSource;

  TimerStateRepository({required this.localDataSource});

  Future<void> saveTimerState({
    required int curSections,
    required PomodoroMode curPomodoroMode,
  }) async {
    await localDataSource.saveTimerState(
      curSections: curSections,
      curPomodoroMode: curPomodoroMode,
    );
  }

  int getCurrentSections() => localDataSource.getCurrentSections();
  PomodoroMode getCurrentPomodoroMode() =>
      localDataSource.getCurrentPomodoroMode();
}
