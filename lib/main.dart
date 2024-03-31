import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/data/repositories/member_repository.dart';
import 'package:pomodak/data/storagies/auth_storage.dart';
import 'package:pomodak/router/app_router.dart';
import 'package:pomodak/config/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_state_view_model.dart';
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

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
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
  late NetworkApiService apiService;
  late AuthRepository authRepository;
  late MemberRepository memberRepository;

  @override
  void initState() {
    super.initState();
    authStorage = AuthStorage();
    apiService = NetworkApiService(storage: authStorage);
    authRepository =
        AuthRepository(apiService: apiService, storage: authStorage);
    memberRepository = MemberRepository(apiService: apiService);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppViewModel>(
            create: (_) => AppViewModel(widget.sharedPreferences)),
        ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel(authRepository: authRepository)),
        ChangeNotifierProvider<MemberViewModel>(
            create: (_) => MemberViewModel(memberRepository: memberRepository)),
        ChangeNotifierProvider<TimerOptionsViewModel>(
            create: (_) => TimerOptionsViewModel()),
        ChangeNotifierProxyProvider<TimerOptionsViewModel, TimerStateViewModel>(
          create: (_) => TimerStateViewModel(),
          update: (ctx, timerOptionsViewModel, timerStateViewModel) {
            timerStateViewModel!.update(timerOptionsViewModel);
            return timerStateViewModel;
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final appViewModel =
              Provider.of<AppViewModel>(context, listen: false);
          final authViewModel =
              Provider.of<AuthViewModel>(context, listen: false);

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
