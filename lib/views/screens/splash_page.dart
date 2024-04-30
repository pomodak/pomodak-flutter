import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/di.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    onStartUp();
  }

  void onStartUp() async {
    getIt<AppViewModel>().onAppStart(context); // 앱 설정 로드
    await getIt<AuthViewModel>().onAppStart(); // 로그인 정보(토큰, 계정) 로드

    if (getIt<AuthViewModel>().account != null) {
      await getIt<MemberViewModel>().onAppStart(); // 유저 정보 로드 (토큰 사용)
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Image.network(
          CDNImages.mascot["finish"]!,
          width: size.width / 2,
        ),
      ),
    );
  }
}
