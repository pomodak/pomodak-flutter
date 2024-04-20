import 'package:pomodak/data/datasources/local/timer_options_local_datasource.dart';

class TimerOptionsRepository {
  final TimerOptionsLocalDataSource localDataSource;

  TimerOptionsRepository({required this.localDataSource});

  Future<void> saveTimerOptions({
    required bool isPomodoroMode,
    required bool isFocusTogetherMode,
    required int workTime,
    required int restTime,
    required int sections,
  }) async {
    await localDataSource.saveTimerOptions(
      isPomodoroMode: isPomodoroMode,
      isFocusTogetherMode: isFocusTogetherMode,
      workTime: workTime,
      restTime: restTime,
      sections: sections,
    );
  }

  bool getIsPomodoroMode() => localDataSource.getIsPomodoroMode();
  bool getIsFocusTogetherMode() => localDataSource.getIsFocusTogetherMode();
  int getTargetWorkTime() => localDataSource.getTargetWorkTime();
  int getTargetRestTime() => localDataSource.getTargetRestTime();
  int getTargetSections() => localDataSource.getTargetSections();
}
