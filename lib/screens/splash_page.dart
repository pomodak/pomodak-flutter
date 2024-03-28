import 'package:flutter/material.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/view_models/app_view_model.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AppViewModel _appViewModel;
  late AuthViewModel _authViewModel;

  @override
  void initState() {
    // 첫 실행에만 사용되기에 listen: false
    _appViewModel = Provider.of<AppViewModel>(context, listen: false);
    _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await _authViewModel.onAppStart();
    await _appViewModel.onAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppPage.splash.toTitle),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
