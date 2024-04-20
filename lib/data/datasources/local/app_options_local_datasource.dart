import 'package:shared_preferences/shared_preferences.dart';

abstract class AppOptionsLocalDataSource {
  bool getVibration();
  bool getKeepScreenOn();
  Future<void> saveAppOptions(
      {required bool vibration, required bool keepScreenOn});
}

const vibrationKey = "vibration";
const keepScreenOnKey = "keepScreenOn";

const defaultVibration = true;
const defaultKeepScreenOn = true;

class AppOptionsLocalDataSourceImpl implements AppOptionsLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppOptionsLocalDataSourceImpl(this.sharedPreferences);

  @override
  bool getVibration() {
    try {
      return sharedPreferences.getBool(vibrationKey) ?? defaultVibration;
    } catch (e) {
      sharedPreferences.remove(vibrationKey);
      return defaultVibration;
    }
  }

  @override
  bool getKeepScreenOn() {
    try {
      return sharedPreferences.getBool(keepScreenOnKey) ?? defaultKeepScreenOn;
    } catch (e) {
      sharedPreferences.remove(keepScreenOnKey);
      return defaultKeepScreenOn;
    }
  }

  @override
  Future<void> saveAppOptions({
    required bool vibration,
    required bool keepScreenOn,
  }) async {
    await sharedPreferences.setBool(vibrationKey, vibration);
    await sharedPreferences.setBool(keepScreenOnKey, keepScreenOn);
  }
}
