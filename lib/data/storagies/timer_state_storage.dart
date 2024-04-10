import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const curSectionsKey = "curSections";
const curPomodoroModeKey = "curPomodoro";

const defaultCurSections = 0;
const defaultCurPomodoroMode = PomodoroMode.focus;

class TimerStateStorage {
  late SharedPreferences storage;

  TimerStateStorage(this.storage);

  Future<void> saveTimerState({
    required int curSections,
    required PomodoroMode curPomodoroMode,
  }) async {
    await storage.setInt(curSectionsKey, curSections);
    await storage.setString(curPomodoroModeKey, curPomodoroMode.toString());
  }

  int getCurSections() {
    try {
      int? value = storage.getInt(curSectionsKey);
      if (value == null) {
        storage.setInt(curSectionsKey, defaultCurSections);
        value = defaultCurSections;
      }
      return value;
    } catch (e) {
      storage.remove(curSectionsKey);
      return defaultCurSections;
    }
  }

  PomodoroMode getCurPomodoroMode() {
    try {
      String? value = storage.getString(curPomodoroModeKey);

      if (value == null) {
        storage.setString(curSectionsKey, defaultCurPomodoroMode.toString());
        value = defaultCurPomodoroMode.toString();
      }

      return value == PomodoroMode.focus.toString()
          ? PomodoroMode.focus
          : PomodoroMode.rest;
    } catch (e) {
      storage.remove(curPomodoroModeKey);
      return defaultCurPomodoroMode;
    }
  }
}
