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
    try {
      bool? value = storage.getBool(isPomodoroModeKey);

      if (value == null) {
        storage.setBool(isPomodoroModeKey, defaultIsPomodoroMode);
        value = defaultIsPomodoroMode;
      }
      return value;
    } catch (e) {
      storage.remove(isPomodoroModeKey);
      return defaultIsPomodoroMode;
    }
  }

  bool getIsFocusTogetherMode() {
    try {
      bool? value = storage.getBool(isFocusTogetherModeKey);
      if (value == null) {
        storage.setBool(isFocusTogetherModeKey, defaultIsFocusTogetherModeKey);
        value = defaultIsFocusTogetherModeKey;
      }
      return value;
    } catch (e) {
      storage.remove(isFocusTogetherModeKey);
      return defaultIsFocusTogetherModeKey;
    }
  }

  int getTargetWorkTime() {
    try {
      int? value = storage.getInt(targetWorkTimeKey);
      if (value == null) {
        storage.setInt(targetWorkTimeKey, defaultTargetWorkTime);
        value = defaultTargetWorkTime;
      }
      return value;
    } catch (e) {
      storage.remove(targetWorkTimeKey);
      return defaultTargetWorkTime;
    }
  }

  int getTargetRestTime() {
    try {
      int? value = storage.getInt(targetRestTimeKey);
      if (value == null) {
        storage.setInt(targetRestTimeKey, defaultTargetRestTime);
        value = defaultTargetRestTime;
      }
      return value;
    } catch (e) {
      storage.remove(targetRestTimeKey);
      return defaultTargetRestTime;
    }
  }

  int getTargetSections() {
    try {
      int? value = storage.getInt(targetSectionsKey);
      if (value == null) {
        storage.setInt(targetSectionsKey, defaultTargetSections);
        value = defaultTargetSections;
      }
      return value;
    } catch (e) {
      storage.remove(targetSectionsKey);
      return defaultTargetSections;
    }
  }
}
