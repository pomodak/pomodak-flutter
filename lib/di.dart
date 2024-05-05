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
import 'package:pomodak/view_models/banner_ad_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/rewarded_ad_view_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // local 저장소 (Hive, SharedPreferences, FlutterSecureStorage 등)
  await registerLocalStoragies();

  // (local)DataSource (local 저장소를 주입받아 데이터를 처리)
  registerLocalDataSource();
  // NetworkApiService (외부 서버와 통신 - authLocalDataSource가 필요하기 때문에 localDataSource를 먼저 등록)
  getIt.registerLazySingleton<NetworkApiService>(() =>
      NetworkApiService(authLocalDataSource: getIt<AuthLocalDataSource>()));
  // (remote)DataSource (apiServices를 주입받아 외부 서버에서 데이터를 처리)
  registerRemoteDataSource();

  // Repository (dataSources를 이용하여 데이터를 처리)
  registerRepository();

  // ViewModel (repositories를 주입받아 view에서 사용할 데이터를 처리)
  registerViewModels();
}

// local 저장소 등록
Future<void> registerLocalStoragies() async {
  // SharedPreferences (간단한 설정 같은 key-value 쌍을 저장하는 용도)
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // FlutterSecureStorage (보안이 필요한 데이터 (토큰, 계정 정보 등)를 저장하는 용도)
  getIt.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());

  // Hive (구조화된 데이터를 저장하는 용도 - 타이머 기록, 통계 등)
  // Hive를 초기화하고, 모델의 어댑터 등록, 필요한 Box를 열어 getIt에 등록
  await Hive.initFlutter();
  Hive.registerAdapter(TimerRecordModelAdapter());
  final Box<TimerRecordModel> timerRecordBox =
      await Hive.openBox<TimerRecordModel>('timerRecords');
  getIt.registerLazySingleton<Box<TimerRecordModel>>(() => timerRecordBox);
}

// LocalDataSource
void registerLocalDataSource() {
  // Auth
  getIt.registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt<FlutterSecureStorage>()));
  // Member
  getIt.registerLazySingleton<MemberLocalDataSource>(
      () => MemberLocalDataSourceImpl(getIt<SharedPreferences>()));
  // AppOptions
  getIt.registerLazySingleton<AppOptionsLocalDataSource>(
      () => AppOptionsLocalDataSourceImpl(getIt<SharedPreferences>()));
  // Timer 관련
  getIt.registerLazySingleton<TimerOptionsLocalDataSource>(
      () => TimerOptionsLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerStateLocalDataSource>(
      () => TimerStateLocalDataSourceImpl(getIt<SharedPreferences>()));
  getIt.registerLazySingleton<TimerRecordLocalDataSource>(
      () => TimerRecordLocalDataSourceImpl(getIt<Box<TimerRecordModel>>()));
}

// RemoteDataSource
void registerRemoteDataSource() {
  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  // Member
  getIt.registerLazySingleton<MemberRemoteDataSource>(
      () => MemberRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  // Shop
  getIt.registerLazySingleton<ShopRemoteDataSource>(
      () => ShopRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
  // Transaction(상점 구매/판매, 아이템 사용, 알 시간 적용 등)
  getIt.registerLazySingleton<TransactionRemoteDataSource>(() =>
      TransactionRemoteDataSourceImpl(apiService: getIt<NetworkApiService>()));
}

// Repository
void registerRepository() {
  // Auth
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      localDataSource: getIt<AuthLocalDataSource>(),
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );
  // Member
  getIt.registerLazySingleton<MemberRepository>(
    () => MemberRepository(
      localDataSource: getIt<MemberLocalDataSource>(),
      remoteDataSource: getIt<MemberRemoteDataSource>(),
    ),
  );

  // Shop
  getIt.registerLazySingleton<ShopRepository>(
    () => ShopRepository(
      remoteDataSource: getIt<ShopRemoteDataSource>(),
    ),
  );
  // Transaction(상점 구매/판매, 아이템 사용, 알 시간 적용 등)
  getIt.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(
      remoteDataSource: getIt<TransactionRemoteDataSource>(),
    ),
  );
  // AppOptions
  getIt.registerLazySingleton<AppOptionsRepository>(
    () => AppOptionsRepository(
      localDataSource: getIt<AppOptionsLocalDataSource>(),
    ),
  );
  // Timer 관련
  getIt.registerLazySingleton<TimerRecordRepository>(
    () => TimerRecordRepository(
      localDataSource: getIt<TimerRecordLocalDataSource>(),
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
void registerViewModels() {
  // AppOptions
  getIt.registerLazySingleton<AppViewModel>(
    () => AppViewModel(repository: getIt<AppOptionsRepository>()),
  );

  // Auth
  getIt.registerLazySingleton<AuthViewModel>(
    () => AuthViewModel(repository: getIt<AuthRepository>()),
  );

  // Member
  getIt.registerLazySingleton<MemberViewModel>(
    () => MemberViewModel(repository: getIt<MemberRepository>()),
  );

  // Shop
  getIt.registerLazySingleton<ShopViewModel>(
    () => ShopViewModel(repository: getIt<ShopRepository>()),
  );

  // Transaction(상점 구매/판매, 아이템 사용, 알 시간 적용 등)
  getIt.registerLazySingleton<TransactionViewModel>(
    () => TransactionViewModel(repository: getIt<TransactionRepository>()),
  );

  // Timer 관련
  getIt.registerLazySingleton<TimerOptionsViewModel>(
    () => TimerOptionsViewModel(repository: getIt<TimerOptionsRepository>()),
  );
  getIt.registerLazySingleton<TimerRecordViewModel>(
    () => TimerRecordViewModel(repository: getIt<TimerRecordRepository>()),
  );
  getIt.registerLazySingleton<TimerAlarmViewModel>(
    () => TimerAlarmViewModel(),
  );
  getIt.registerLazySingleton<TimerViewModel>(
    () => TimerViewModel(
      repository: getIt<TimerStateRepository>(),
      timerOptionsViewModel: getIt<TimerOptionsViewModel>(),
    ),
  );
  getIt.registerLazySingleton<GroupTimerViewModel>(() => GroupTimerViewModel());

  // AdMob
  getIt.registerLazySingleton<RewardedAdViewModel>(() => RewardedAdViewModel());
  getIt.registerLazySingleton<BannerAdViewModel>(() => BannerAdViewModel());
}
