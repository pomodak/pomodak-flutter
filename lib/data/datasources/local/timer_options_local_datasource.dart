import 'package:shared_preferences/shared_preferences.dart';

abstract class TimerOptionsLocalDataSource {
  Future<void> saveTimerOptions({
    required bool isPomodoroMode,
    required bool isFocusTogetherMode,
    required int workTime,
    required int restTime,
    required int sections,
  });

  bool getIsPomodoroMode();
  bool getIsFocusTogetherMode();
  int getTargetWorkTime();
  int getTargetRestTime();
  int getTargetSections();
}

const String isPomodoroModeKey = "isPomodoroMode";
const String isFocusTogetherModeKey = "isFocusTogetherMode";
const String targetWorkTimeKey = "targetWorkTime";
const String targetRestTimeKey = "targetRestTime";
const String targetSectionsKey = "targetSections";

const bool defaultIsPomodoroMode = true;
const bool defaultIsFocusTogetherMode = false;
const int defaultTargetWorkTime = 25;
const int defaultTargetRestTime = 5;
const int defaultTargetSections = 4;

class TimerOptionsLocalDataSourceImpl implements TimerOptionsLocalDataSource {
  final SharedPreferences sharedPreferences;

  TimerOptionsLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTimerOptions({
    required bool isPomodoroMode,
    required bool isFocusTogetherMode,
    required int workTime,
    required int restTime,
    required int sections,
  }) async {
    await sharedPreferences.setBool(isPomodoroModeKey, isPomodoroMode);
    await sharedPreferences.setBool(
        isFocusTogetherModeKey, isFocusTogetherMode);
    await sharedPreferences.setInt(targetWorkTimeKey, workTime);
    await sharedPreferences.setInt(targetRestTimeKey, restTime);
    await sharedPreferences.setInt(targetSectionsKey, sections);
  }

  @override
  bool getIsPomodoroMode() {
    try {
      return sharedPreferences.getBool(isPomodoroModeKey) ??
          defaultIsPomodoroMode;
    } catch (e) {
      sharedPreferences.remove(isPomodoroModeKey);
      return defaultIsPomodoroMode;
    }
  }

  @override
  bool getIsFocusTogetherMode() {
    try {
      return sharedPreferences.getBool(isFocusTogetherModeKey) ??
          defaultIsFocusTogetherMode;
    } catch (e) {
      sharedPreferences.remove(isFocusTogetherModeKey);
      return defaultIsFocusTogetherMode;
    }
  }

  @override
  int getTargetWorkTime() {
    try {
      return sharedPreferences.getInt(targetWorkTimeKey) ??
          defaultTargetWorkTime;
    } catch (e) {
      sharedPreferences.remove(targetWorkTimeKey);
      return defaultTargetWorkTime;
    }
  }

  @override
  int getTargetRestTime() {
    try {
      return sharedPreferences.getInt(targetRestTimeKey) ??
          defaultTargetRestTime;
    } catch (e) {
      sharedPreferences.remove(targetRestTimeKey);
      return defaultTargetRestTime;
    }
  }

  @override
  int getTargetSections() {
    try {
      return sharedPreferences.getInt(targetSectionsKey) ??
          defaultTargetSections;
    } catch (e) {
      sharedPreferences.remove(targetSectionsKey);
      return defaultTargetSections;
    }
  }
}
