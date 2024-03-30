import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pomodak/router/app_router.dart';
import 'package:pomodak/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // 세로모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.env['KAKAO_NATIVE_KEY']!,
    javaScriptAppKey: dotenv.env['KAKAO_JS_APP_KEY']!,
  );

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  runApp(MyApp(sharedPreferences: sharedPreferences));
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
  late AppViewModel appViewModel;
  late AuthViewModel authViewModel;
  late MemberViewModel memberViewModel;

  @override
  void initState() {
    appViewModel = AppViewModel(widget.sharedPreferences);
    memberViewModel = MemberViewModel();

    authViewModel = AuthViewModel(
      onLoginSuccess: () async {
        await memberViewModel.loadMember();
      },
      onLogoutComplete: () async {
        await memberViewModel.remove();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppViewModel>(create: (_) => appViewModel),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) => authViewModel,
        ),
        ChangeNotifierProvider<MemberViewModel>(create: (_) => memberViewModel),
        // 라우터는 리다이렉트를 처리하기 위해 로그인 상태와 앱 상태를 주입받음
        Provider<AppRouter>(
            create: (_) => AppRouter(appViewModel, authViewModel)),
      ],
      child: Builder(
        builder: (context) {
          // listen: false - AppRouter에 변경사항이 생겨도 재빌드 X
          final GoRouter goRouter =
              Provider.of<AppRouter>(context, listen: false).router;
          return MaterialApp.router(
            title: "Pomodak",
            theme: AppTheme.lightTheme,
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
