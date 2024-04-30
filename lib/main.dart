import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pomodak/di.dart';
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
import 'package:pomodak/view_models/timer_alarm_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/view_models/transaction_view_model.dart';
import 'package:pomodak/views/widgets/bouncing_loading_icon.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // 환경 변수 로드
  await dotenv.load(fileName: ".env");

  // Flutter 엔진과 위젯 트리 바인딩
  // https://stackoverflow.com/questions/63873338/what-does-widgetsflutterbinding-ensureinitialized-do
  WidgetsFlutterBinding.ensureInitialized();

  // firebase 연동
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 디바이스 오리엔테이션 설정(세로모드 고정)
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // 디바이스 상태바 색상 설정
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // 하단 바
    statusBarColor: Colors.white, // 상단 바
  ));

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JS_APP_KEY']!,
  );

  // 로컬 알림 초기화
  LocalNotificationUtil.initialization();
  LocalNotificationUtil.permissionWithNotification();

  // DI 설정
  await setupLocator();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AppViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<MemberViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<ShopViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TransactionViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerOptionsViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerRecordViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerAlarmViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<GroupTimerViewModel>()),
      ],
      child: Builder(
        builder: (context) {
          final appRouter = AppRouter(
              appViewModel: getIt<AppViewModel>(),
              authViewModel: getIt<AuthViewModel>());
          final goRouter = appRouter.router;

          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidgetBuilder: (_) {
              return const Center(
                child: BouncingLoadingIcon(),
              );
            },
            child: MaterialApp.router(
              title: "뽀모닭",
              theme: AppTheme.lightTheme,
              routerConfig: goRouter,
              builder: (context, child) => Overlay(
                initialEntries: [
                  if (child != null) ...[
                    OverlayEntry(
                      builder: (context) => child,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
