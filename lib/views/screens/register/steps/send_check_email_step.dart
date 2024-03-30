import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/register/widgets/email_register_form.dart';

class SendCheckEmailStep extends StatelessWidget {
  final Function(String email, String password) onSuccess;

  const SendCheckEmailStep({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmailRegisterForm(onRegister: (email, password) {
          onSuccess(email, password);
        }),
      ],
    );
  }
}
