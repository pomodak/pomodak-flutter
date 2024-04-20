import 'package:pomodak/data/datasources/local/app_options_local_datasource.dart';

class AppOptionsRepository {
  final AppOptionsLocalDataSource localDataSource;

  AppOptionsRepository({required this.localDataSource});

  Future<bool> getVibration() async {
    return localDataSource.getVibration();
  }

  Future<bool> getKeepScreenOn() async {
    return localDataSource.getKeepScreenOn();
  }

  Future<void> saveAppOptions({
    required bool vibration,
    required bool keepScreenOn,
  }) async {
    await localDataSource.saveAppOptions(
        vibration: vibration, keepScreenOn: keepScreenOn);
  }
}
