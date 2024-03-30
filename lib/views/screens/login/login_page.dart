import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/views/screens/login/widgets/email_login_form.dart';
import 'package:pomodak/views/screens/login/widgets/social_login_list.dart';
import 'package:pomodak/views/widgets/custom_devider.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: [
            GestureDetector(
              onTap: () {
                context.go(AppPage.welcome.toPath);
              },
              child: const Icon(Icons.chevron_left, size: 32),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: EmailLoginForm(
                onLogin: (email, password) {
                  authViewModel.emailLogin(context,
                      email: email, password: password);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                        text: '아직 계정이 없으신가요? ',
                        style: TextStyle(color: Colors.black54)),
                    TextSpan(
                      text: ' 회원가입',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go(AppPage.register.toPath);
                        },
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: CustomDivider(),
            ),
            SocialLoginList(
              onGoogleLoginTap: () {
                authViewModel.googleLogin(context);
              },
              onKakaoLoginTap: () {
                authViewModel.kakaoLogin(context);
              },
              // onNaverLoginTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
