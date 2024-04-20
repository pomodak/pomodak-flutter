import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pomodak/data/datasources/local/app_options_local_datasource.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/data/datasources/local/member_local_datasource.dart';
import 'package:pomodak/data/datasources/local/timer_options_local_datasource.dart';
import 'package:pomodak/data/datasources/local/timer_record_local_datasource.dart';
import 'package:pomodak/data/datasources/local/timer_state_local_datasource.dart';
import 'package:pomodak/data/datasources/remote/auth_remote_datasource.dart';
import 'package:pomodak/data/datasources/remote/member_remote_datasource.dart';
import 'package:pomodak/data/datasources/remote/shop_remote_datasource.dart';
import 'package:pomodak/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/data/repositories/app_options_repository.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/data/repositories/timer_options_repository.dart';
import 'package:pomodak/data/repositories/timer_record_repository.dart';
import 'package:pomodak/data/repositories/timer_state_repository.dart';
import 'package:pomodak/data/repositories/transaction_repository.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  const flutterSecureStorage = FlutterSecureStorage();

  // timerRecords 기록
  await Hive.initFlutter();
  Hive.registerAdapter(TimerRecordModelAdapter());
  final Box<TimerRecordModel> timerRecordBox =
      await Hive.openBox<TimerRecordModel>('timerRecords');

  getIt.registerLazySingleton<FlutterSecureStorage>(() => flutterSecureStorage);
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  getIt.registerLazySingleton<Box<TimerRecordModel>>(() => timerRecordBox);

  registerDataSource();
  registerRepository();
  registerViewModel();
}

// DataSource
void registerDataSource() {
  // LocalDataSource
  getIt.registerLazySingleton<MemberLocalDataSource>(
      () => MemberLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()));
  getIt.registerLazySingleton<AppOptionsLocalDataSource>(
      () => AppOptionsLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerOptionsLocalDataSource>(
      () => TimerOptionsLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerStateLocalDataSource>(
      () => TimerStateLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerRecordLocalDataSource>(
      () => TimerRecordLocalDataSourceImpl(getIt<Box<TimerRecordModel>>()));

  // ApiService
  getIt.registerLazySingleton<NetworkApiService>(() =>
      NetworkApiService(authLocalDataSource: getIt<AuthLocalDataSource>()));

  // RemoteDataSource
  getIt.registerLazySingleton<MemberRemoteDataSource>(
      () => MemberRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  getIt.registerLazySingleton<ShopRemoteDataSource>(
      () => ShopRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  getIt.registerLazySingleton<TransactionRemoteDataSource>(() =>
      TransactionRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
}

// Repository
void registerRepository() {
  getIt.registerLazySingleton<ShopRepository>(
    () => ShopRepository(
      remoteDataSource: getIt<ShopRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(
      remoteDataSource: getIt<TransactionRemoteDataSource>(),
    ),
  );
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
  getIt.registerLazySingleton<TimerRecordRepository>(
    () => TimerRecordRepository(
      localDataSource: getIt<TimerRecordLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<AppOptionsRepository>(
    () => AppOptionsRepository(
      localDataSource: getIt<AppOptionsLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<TimerOptionsRepository>(
    () => TimerOptionsRepository(
      localDataSource: getIt<TimerOptionsLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<TimerStateRepository>(
    () => TimerStateRepository(
      localDataSource: getIt<TimerStateLocalDataSource>(),
    ),
  );
}

// View Model
void registerViewModel() {
  getIt.registerLazySingleton<AppViewModel>(
    () => AppViewModel(repository: getIt<AppOptionsRepository>()),
  );
  getIt.registerLazySingleton<MemberViewModel>(
    () => MemberViewModel(repository: getIt<MemberRepository>()),
  );
  getIt.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(
      repository: getIt<AuthRepository>(),
      memberViewModel: getIt<MemberViewModel>(),
    ),
  );
  getIt.registerLazySingleton<ShopViewModel>(
    () => ShopViewModel(
      repository: getIt<ShopRepository>(),
      memberViewModel: getIt<MemberViewModel>(),
    ),
  );
  getIt.registerLazySingleton<TransactionViewModel>(
    () => TransactionViewModel(
      repository: getIt<TransactionRepository>(),
      memberViewModel: getIt<MemberViewModel>(),
    ),
  );
  getIt.registerLazySingleton<TimerOptionsViewModel>(
    () => TimerOptionsViewModel(repository: getIt<TimerOptionsRepository>()),
  );
  getIt.registerLazySingleton<TimerRecordViewModel>(
    () => TimerRecordViewModel(
      repository: getIt<TimerRecordRepository>(),
      memberViewModel: getIt<MemberViewModel>(),
      transactionViewModel: getIt<TransactionViewModel>(),
    ),
  );
  getIt.registerLazySingleton<TimerStateViewModel>(
    () => TimerStateViewModel(
      repository: getIt<TimerStateRepository>(),
      timerOptionsViewModel: getIt<TimerOptionsViewModel>(),
      timerRecordViewModel: getIt<TimerRecordViewModel>(),
    ),
  );
  getIt.registerLazySingleton<GroupTimerViewModel>(() => GroupTimerViewModel());
}
