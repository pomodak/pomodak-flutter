import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/views/widgets/custom_button.dart';
import 'package:pomodak/views/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "이메일을 입력해주세요.";
    }

    final emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '유효하지 않은 이메일 주소입니다.';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (value.length < 8) {
      return '비밀번호는 최소 8자 이상입니다.';
    }
    if (value.length > 20) {
      return '비밀번호는 최대 20자 이하입니다.';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 숫자가 포함되어야 합니다.';
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 소문자가 포함되어야 합니다.';
    }
    if (!RegExp(r'(?=.*[\W])').hasMatch(value)) {
      return '비밀번호에는 적어도 하나의 특수 문자가 포함되어야 합니다.';
    }
    return null;
  }

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
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                labelText: '이메일',
                validator: _emailValidator,
                onSaved: (value) => _email = value!,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                labelText: '패스워드',
                obscureText: true,
                validator: _passwordValidator,
                onSaved: (value) => _password = value!,
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: "로그인",
                isLoading: authViewModel.loading,
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  authViewModel.emailLogin(
                    context,
                    email: _email,
                    password: _password,
                  );
                },
              ),
              const SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '아직 계정이 없으신가요? '),
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
            ],
          ),
        ),
      ),
    );
  }
}
