import 'package:flutter/material.dart';
import 'package:pomodak/router/route_utils.dart';
import 'package:pomodak/views/screens/register/steps/agree_to_policy_step.dart';
import 'package:pomodak/views/screens/register/steps/email_register_step.dart';
import 'package:pomodak/views/screens/register/steps/send_check_email_step.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> stepWidgets = [
      AgreeToPolicyStep(onSuccess: _goToNextStep),
      SendCheckEmailStep(onSuccess: _goToNextStep),
      EmailRegisterStep(onSuccess: _completeRegistration),
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              stepWidgets[_currentStep],
            ],
          ),
        ),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.go(AppPage.login.toPath);
    }
  }

  void _completeRegistration() {
    context.go(AppPage.home.toPath);
  }
}