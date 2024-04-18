import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/data/storagies/app_options_storage.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';
import 'package:pomodak/data/storagies/timer_options_storage.dart';
import 'package:pomodak/data/storagies/timer_record_storage.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  const flutterSecureStorage = FlutterSecureStorage();

  getIt.registerLazySingleton<FlutterSecureStorage>(() => flutterSecureStorage);
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  registerDataSource();
  registerRepository();
  registerViewModel();
}

// DataSource
void registerDataSource() {
  getIt.registerLazySingleton<AuthStorage>(
      () => AuthStorage(getIt<FlutterSecureStorage>()));
  getIt.registerLazySingleton<AppOptionStorage>(
      () => AppOptionStorage(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerOptionsStorage>(
      () => TimerOptionsStorage(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerStateStorage>(
      () => TimerStateStorage(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerRecordStorage>(() => TimerRecordStorage());
}

// Repository
void registerRepository() {
  // Api Service
  getIt.registerLazySingleton<NetworkApiService>(
      () => NetworkApiService(storage: getIt<AuthStorage>()));

  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(
      apiService: getIt<NetworkApiService>(), storage: getIt<AuthStorage>()));
  getIt.registerLazySingleton<MemberRepository>(
      () => MemberRepository(apiService: getIt<NetworkApiService>()));
  getIt.registerLazySingleton<ShopRepository>(
      () => ShopRepository(apiService: getIt<NetworkApiService>()));
}

// View Model
void registerViewModel() {
  getIt.registerLazySingleton<AppViewModel>(
      () => AppViewModel(storage: getIt<AppOptionStorage>()));
  getIt.registerLazySingleton<MemberViewModel>(
      () => MemberViewModel(repository: getIt<MemberRepository>()));
  getIt.registerLazySingleton<AuthViewModel>(() => AuthViewModel(
        repository: getIt<AuthRepository>(),
        memberViewModel: getIt<MemberViewModel>(),
      ));
  getIt.registerLazySingleton<ShopViewModel>(() => ShopViewModel(
        repository: getIt<ShopRepository>(),
        memberViewModel: getIt<MemberViewModel>(),
      ));
  getIt.registerLazySingleton<TimerOptionsViewModel>(
      () => TimerOptionsViewModel(storage: getIt<TimerOptionsStorage>()));
  getIt.registerLazySingleton<TimerRecordViewModel>(() => TimerRecordViewModel(
        storage: getIt<TimerRecordStorage>(),
        memberViewModel: getIt<MemberViewModel>(),
      ));
  getIt.registerLazySingleton<TimerStateViewModel>(() => TimerStateViewModel(
      storage: getIt<TimerStateStorage>(),
      timerOptionsViewModel: getIt<TimerOptionsViewModel>(),
      timerRecordViewModel: getIt<TimerRecordViewModel>()));
  getIt.registerLazySingleton<GroupTimerViewModel>(() => GroupTimerViewModel());
}
