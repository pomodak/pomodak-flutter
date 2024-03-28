import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/app_router.dart';
import 'package:pomodak/theme/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
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

  @override
  void initState() {
    appViewModel = AppViewModel(widget.sharedPreferences);
    authViewModel = AuthViewModel();
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
