import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pomodak/di.dart';
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

  // timerRecords 기록
  await Hive.initFlutter();
  Hive.registerAdapter(TimerRecordModelAdapter());
  await Hive.openBox<TimerRecordModel>('timerRecords');

  // 권한 허용
  LocalNotificationUtil.initialization();
  LocalNotificationUtil.permissionWithNotification();

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
        ChangeNotifierProvider(create: (_) => getIt<TimerOptionsViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerRecordViewModel>()),
        ChangeNotifierProvider(create: (_) => getIt<TimerStateViewModel>()),
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
            ),
          );
        },
      ),
    );
  }
}
