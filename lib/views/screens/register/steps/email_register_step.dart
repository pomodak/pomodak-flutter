import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/register/widgets/check_code_form.dart';

class EmailRegisterStep extends StatelessWidget {
  final Function(String code) onSuccess;
  final Function() reSendCode;

  const EmailRegisterStep(
      {super.key, required this.onSuccess, required this.reSendCode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckCodeForm(onRegister: (code) {
          onSuccess(code);
        }),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                    text: '이메일이 발송되지 않았나요? ',
                    style: TextStyle(color: Colors.black54)),
                TextSpan(
                  text: ' 재발급 받기',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      reSendCode();
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
