import 'package:flutter/material.dart';

class SendCheckEmailStep extends StatelessWidget {
  final VoidCallback onSuccess;

  const SendCheckEmailStep({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onSuccess,
          child: const Text("이메일 발송"),
        ),
      ],
    );
  }
}
