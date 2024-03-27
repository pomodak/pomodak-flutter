import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/screens/login_page.dart';
import 'package:pomodak/screens/main_page.dart';
import 'package:pomodak/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  // 세로모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodak',
      theme: AppTheme.lightTheme,
      routes: {
        "/": (context) => const MyHomePage(),
        '/login': (context) => const LoginPage(),
      },
      initialRoute: "/",
    );
  }
}
