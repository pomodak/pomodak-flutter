import 'package:shared_preferences/shared_preferences.dart';

const isPomodoroModeKey = "isPomodoroMode";
const isFocusTogetherModeKey = "isFocusTogetherMode";
const targetWorkTimeKey = "targetWorkTime";
const targetRestTimeKey = "targetRestTime";
const targetSectionsKey = "targetSections";

const defaultIsPomodoroMode = true;
const defaultIsFocusTogetherModeKey = false;
const defaultTargetWorkTime = 25;
const defaultTargetRestTime = 5;
const defaultTargetSections = 4;

class TimerOptionsStorage {
  late SharedPreferences storage;

  TimerOptionsStorage(this.storage);

  Future<void> saveTimerOptions({
    required bool isPomodoroMode,
    required bool isFocusTogetherMode,
    required int workTime,
    required int restTime,
    required int sections,
  }) async {
    await storage.setBool(isPomodoroModeKey, isPomodoroMode);
    await storage.setBool(isFocusTogetherModeKey, isFocusTogetherMode);
    await storage.setInt(targetWorkTimeKey, workTime);
    await storage.setInt(targetRestTimeKey, restTime);
    await storage.setInt(targetSectionsKey, sections);
  }

  bool getIsPomodoroMode() {
    bool? value = storage.getBool(isPomodoroModeKey);

    if (value == null) {
      storage.setBool(isPomodoroModeKey, defaultIsPomodoroMode);
      value = defaultIsPomodoroMode;
    }
    return value;
  }

  bool getIsFocusTogetherMode() {
    bool? value = storage.getBool(isFocusTogetherModeKey);
    if (value == null) {
      storage.setBool(isFocusTogetherModeKey, defaultIsFocusTogetherModeKey);
      value = defaultIsFocusTogetherModeKey;
    }
    return value;
  }

  int getTargetWorkTime() {
    int? value = storage.getInt(targetWorkTimeKey);
    if (value == null) {
      storage.setInt(targetWorkTimeKey, defaultTargetWorkTime);
      value = defaultTargetWorkTime;
    }
    return value;
  }

  int getTargetRestTime() {
    int? value = storage.getInt(targetRestTimeKey);
    if (value == null) {
      storage.setInt(targetRestTimeKey, defaultTargetRestTime);
      value = defaultTargetRestTime;
    }
    return value;
  }

  int getTargetSections() {
    int? value = storage.getInt(targetSectionsKey);
    if (value == null) {
      storage.setInt(targetSectionsKey, defaultTargetSections);
      value = defaultTargetSections;
    }
    return value;
  }
}
