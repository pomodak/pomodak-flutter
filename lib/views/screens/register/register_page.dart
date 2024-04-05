import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:pomodak/views/screens/register/steps/agree_to_policy_step.dart';
import 'package:pomodak/views/screens/register/steps/email_register_step.dart';
import 'package:pomodak/views/screens/register/steps/send_check_email_step.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    List<Widget> stepWidgets = [
      AgreeToPolicyStep(onSuccess: _goToNextStep),
      SendCheckEmailStep(onSuccess: _completeSendCheckEmail),
      EmailRegisterStep(
          onSuccess: _completeRegistration, reSendCode: _resendCode),
    ];
    List<Widget> stepTitles = [
      const Text(
        "약관동의",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      const Text(
        "가입하기",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      const Text(
        "가입하기",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: [
            GestureDetector(
              onTap: _goToPreviousStep,
              child: const Icon(Icons.chevron_left, size: 32),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 48),
                child: stepTitles[_currentStep],
              ),
              stepWidgets[_currentStep],
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextStep() {
    setState(() =>
        _currentStep = (_currentStep < 2) ? _currentStep + 1 : _currentStep);
  }

  void _goToPreviousStep() {
    setState(() =>
        _currentStep = (_currentStep > 0) ? _currentStep - 1 : _currentStep);
    if (_currentStep == 0) {
      context.go(AppPage.login.toPath);
    }
  }

  void _completeSendCheckEmail(String email, String password) async {
    _email = email;
    _password = password;
    context.loaderOverlay.show();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    var success = await authViewModel.checkEmail(email: email);

    if (mounted) context.loaderOverlay.hide();
    if (!success) return;

    _goToNextStep();
  }

  void _completeRegistration(String code) async {
    context.loaderOverlay.show();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    var success = await authViewModel.emailRegister(
      email: _email,
      password: _password,
      code: code,
    );

    if (mounted) context.loaderOverlay.hide();
    if (!success) return;

    if (mounted) {
      context.go(AppPage.home.toPath);
    }
  }

  void _resendCode() {
    _completeSendCheckEmail(_email, _password);
  }
}
