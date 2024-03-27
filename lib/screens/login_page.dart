import 'package:flutter/material.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/services/auth_service.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppPage.login.toTitle),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            authService.loginWithEmail("email@test.com", "qwer@1234");
          },
          child: const Text("Log in"),
        ),
      ),
    );
  }
}
