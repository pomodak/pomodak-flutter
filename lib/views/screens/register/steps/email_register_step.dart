import 'package:flutter/material.dart';

class EmailRegisterStep extends StatelessWidget {
  final VoidCallback onSuccess;

  const EmailRegisterStep({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onSuccess,
          child: const Text("회원가입"),
        ),
      ],
    );
  }
}
