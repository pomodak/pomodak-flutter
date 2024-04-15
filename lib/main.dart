import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/data/storagies/app_options_storage.dart';
import 'package:pomodak/data/storagies/timer_record_storage.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';
import 'package:pomodak/data/storagies/timer_options_storage.dart';
import 'package:pomodak/data/storagies/timer_state_storage.dart';
import 'package:pomodak/models/domain/timer_record_model.dart';
import 'package:pomodak/router/app_router.dart';
import 'package:pomodak/config/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:pomodak/utils/local_notification_util.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model/timer_state_view_model.dart';
import 'package:pomodak/views/widgets/bouncing_loading_icon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // 세로모드 고정
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JS_APP_KEY']!,
  );

  // 간단한 설정 값 (timer 상태, timer 옵션)
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  // timerRecords 기록
  await Hive.initFlutter();
  Hive.registerAdapter(TimerRecordModelAdapter());
  await Hive.openBox<TimerRecordModel>('timerRecords');

  runApp(
    MyApp(sharedPreferences: sharedPreferences),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({
    super.key,
    required this.sharedPreferences,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AuthStorage authStorage;
  late AppOptionStorage appOptionsStorage;
  late TimerOptionsStorage timerOptionsStorage;
  late TimerStateStorage timerStateStorage;
  late TimerRecordStorage timerRecordStorage;

  late NetworkApiService apiService;
  late AuthRepository authRepository;
  late MemberRepository memberRepository;
  late ShopRepository shopRepository;

  late AppViewModel appViewModel;
  late AuthViewModel authViewModel;
  late MemberViewModel memberViewModel;
  late TimerOptionsViewModel timerOptionsViewModel;
  late TimerRecordViewModel timerRecordViewModel;
  late TimerStateViewModel timerStateViewModel;
  late GroupTimerViewModel groupTimerViewModel;
  late ShopViewModel shopViewModel;

  @override
  void initState() {
    super.initState();

    // flutter_secure_storage
    authStorage = AuthStorage();
    // sharedPreferences
    timerOptionsStorage = TimerOptionsStorage(widget.sharedPreferences);
    timerStateStorage = TimerStateStorage(widget.sharedPreferences);
    appOptionsStorage = AppOptionStorage(widget.sharedPreferences);
    // hive
    timerRecordStorage = TimerRecordStorage();
    //network
    apiService = NetworkApiService(storage: authStorage);
    authRepository =
        AuthRepository(apiService: apiService, storage: authStorage);
    memberRepository = MemberRepository(apiService: apiService);
    shopRepository = ShopRepository(apiService: apiService);

    // ViewModel
    appViewModel = AppViewModel(storage: appOptionsStorage);
    memberViewModel = MemberViewModel(repository: memberRepository);
    authViewModel = AuthViewModel(
      repository: authRepository,
      memberViewModel: memberViewModel,
    );
    timerOptionsViewModel = TimerOptionsViewModel(storage: timerOptionsStorage);
    timerRecordViewModel = TimerRecordViewModel(
      storage: timerRecordStorage,
      memberViewModel: memberViewModel,
    );
    timerStateViewModel = TimerStateViewModel(
      storage: timerStateStorage,
      timerRecordViewModel: timerRecordViewModel,
      timerOptionsViewModel: timerOptionsViewModel,
    );
    groupTimerViewModel = GroupTimerViewModel();

    shopViewModel = ShopViewModel(
      repository: shopRepository,
      memberViewModel: memberViewModel,
    );

    LocalNotificationUtil.initialization();
    LocalNotificationUtil.permissionWithNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppViewModel>(create: (_) => appViewModel),
        ChangeNotifierProvider<AuthViewModel>(create: (_) => authViewModel),
        ChangeNotifierProvider<MemberViewModel>(create: (_) => memberViewModel),

        // 타이머 관련
        ChangeNotifierProvider<TimerOptionsViewModel>(
          create: (_) => timerOptionsViewModel,
        ),
        ChangeNotifierProvider<TimerStateViewModel>(
          create: (_) => timerStateViewModel,
        ),
        ChangeNotifierProvider<TimerRecordViewModel>(
          create: (_) => timerRecordViewModel,
        ),
        ChangeNotifierProvider<GroupTimerViewModel>(
          create: (_) => groupTimerViewModel,
        ),

        // 상점
        ChangeNotifierProvider<ShopViewModel>(create: (_) => shopViewModel),
      ],
      child: Builder(
        builder: (context) {
          final appRouter = AppRouter(appViewModel, authViewModel);
          final goRouter = appRouter.router;

          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidgetBuilder: (_) {
              return const Center(
                child: BouncingLoadingIcon(),
              );
            },
            child: MaterialApp.router(
              title: "Pomodak",
              theme: AppTheme.lightTheme,
              routerConfig: goRouter,
            ),
          );
        },
      ),
    );
  }
}
