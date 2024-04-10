import 'package:shared_preferences/shared_preferences.dart';

const String vibrationKey = 'vibration';
const bool defaultVibration = true;

const String keepScreenOnKey = 'keepScreenOn';
const bool defaultKeepScreenOn = true;

class AppOptionStorage {
  late SharedPreferences storage;

  AppOptionStorage(this.storage);

  bool getVibration() {
    try {
      return storage.getBool(vibrationKey) ?? defaultVibration;
    } catch (e) {
      storage.remove(vibrationKey);
      return defaultVibration;
    }
  }

  bool getKeepScreenOn() {
    try {
      return storage.getBool(keepScreenOnKey) ?? defaultKeepScreenOn;
    } catch (e) {
      storage.remove(keepScreenOnKey);
      return defaultKeepScreenOn;
    }
  }

  Future<void> saveAppOption({
    required bool vibration,
    required bool keepScreenOn,
  }) async {
    await storage.setBool(vibrationKey, vibration);
    await storage.setBool(keepScreenOnKey, keepScreenOn);
  }
}
