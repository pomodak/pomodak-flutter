import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/data/datasources/local/member_local_datasource.dart';
import 'package:pomodak/data/datasources/remote/auth_remote_datasource.dart';
import 'package:pomodak/data/datasources/remote/member_remote_datasource.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/data/storagies/app_options_storage.dart';
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
  getIt.registerLazySingleton<AppOptionStorage>(
      () => AppOptionStorage(getIt<SharedPreferences>()));

  // LocalDataSource
  getIt.registerLazySingleton<MemberLocalDataSource>(
      () => MemberLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()));

  // ApiService
  getIt.registerLazySingleton<NetworkApiService>(() =>
      NetworkApiService(authLocalDataSource: getIt<AuthLocalDataSource>()));

  // RemoteDataSource
  getIt.registerLazySingleton<MemberRemoteDataSource>(
      () => MemberRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));

  // Timer
  getIt.registerLazySingleton<TimerOptionsStorage>(
      () => TimerOptionsStorage(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerStateStorage>(
      () => TimerStateStorage(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerRecordStorage>(() => TimerRecordStorage());
}

// Repository
void registerRepository() {
  getIt.registerLazySingleton<ShopRepository>(
      () => ShopRepository(apiService: getIt<NetworkApiService>()));

  getIt.registerLazySingleton<MemberRepository>(
    () => MemberRepository(
      localDataSource: getIt<MemberLocalDataSource>(),
      remoteDataSource: getIt<MemberRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      localDataSource: getIt<AuthLocalDataSource>(),
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );
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
