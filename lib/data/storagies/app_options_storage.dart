import 'package:shared_preferences/shared_preferences.dart';

const String vibrationKey = 'vibration';
const bool defaultVibration = true;

const String keepScreenOnKey = 'keepScreenOn';
const bool defaultKeepScreenOn = true;

class AppOptionStorage {
  late SharedPreferences storage;

  AppOptionStorage(this.storage);

  Future<void> saveTimerOptions({
    required bool vibration,
    required bool keepScreenOn,
  }) async {
    await storage.setBool(vibrationKey, defaultVibration);
    await storage.setBool(keepScreenOnKey, defaultKeepScreenOn);
  }

  bool getVibration() {
    return storage.getBool(vibrationKey) ?? defaultVibration;
  }

  bool getKeepScreenOn() {
    return storage.getBool(keepScreenOnKey) ?? defaultKeepScreenOn;
  }

  Future<void> saveAppOption({
    required bool vibration,
    required bool keepScreenOn,
  }) async {
    await storage.setBool(vibrationKey, vibration);
    await storage.setBool(keepScreenOnKey, keepScreenOn);
  }
}
