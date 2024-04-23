import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AppViewModel _appViewModel;
  late AuthViewModel _authViewModel;
  late MemberViewModel _memberViewModel;

  @override
  void initState() {
    super.initState();
    // 첫 실행에만 사용되기에 listen: false
    _appViewModel = Provider.of<AppViewModel>(context, listen: false);
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    _memberViewModel = Provider.of<MemberViewModel>(context, listen: false);
    onStartUp();
  }

  void onStartUp() async {
    _appViewModel.onAppStart(context); // 앱 설정 로드
    await _authViewModel.onAppStart(); // 로그인 정보(토큰, 계정) 로드

    if (_authViewModel.account != null) {
      await _memberViewModel.onAppStart(); // 유저 정보 로드 (토큰 사용)
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
