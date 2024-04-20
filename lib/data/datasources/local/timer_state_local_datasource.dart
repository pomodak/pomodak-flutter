import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';

abstract class TimerStateLocalDataSource {
  Future<void> saveTimerState({
    required int curSections,
    required PomodoroMode curPomodoroMode,
  });

  int getCurrentSections();
  PomodoroMode getCurrentPomodoroMode();
}

const String curSectionsKey = "curSections";
const String curPomodoroModeKey = "curPomodoro";

const int defaultCurSections = 0;
const PomodoroMode defaultCurPomodoroMode = PomodoroMode.focus;

class TimerStateLocalDataSourceImpl implements TimerStateLocalDataSource {
  final SharedPreferences sharedPreferences;

  TimerStateLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTimerState({
    required int curSections,
    required PomodoroMode curPomodoroMode,
  }) async {
    await sharedPreferences.setInt(curSectionsKey, curSections);
    await sharedPreferences.setString(
        curPomodoroModeKey, curPomodoroMode.toString());
  }

  @override
  int getCurrentSections() {
    try {
      return sharedPreferences.getInt(curSectionsKey) ?? defaultCurSections;
    } catch (e) {
      sharedPreferences.remove(curSectionsKey);
      return defaultCurSections;
    }
  }

  @override
  PomodoroMode getCurrentPomodoroMode() {
    try {
      String? modeString = sharedPreferences.getString(curPomodoroModeKey);
      if (modeString == null ||
          !(PomodoroMode.values
              .map((e) => e.toString())
              .contains(modeString))) {
        sharedPreferences.setString(
            curPomodoroModeKey, defaultCurPomodoroMode.toString());
        return defaultCurPomodoroMode;
      }
      return PomodoroMode.values
          .firstWhere((mode) => mode.toString() == modeString);
    } catch (e) {
      sharedPreferences.remove(curPomodoroModeKey);
      return defaultCurPomodoroMode;
    }
  }
}
