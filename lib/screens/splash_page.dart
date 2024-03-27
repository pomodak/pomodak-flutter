import 'package:flutter/material.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/services/app_service.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late AppService _appService;

  @override
  void initState() {
    // 첫 실행에만 사용되기에 재빌드 x
    _appService = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  void onStartUp() async {
    await _appService.onAppStart();
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
