import 'package:flutter/material.dart';

class AgreeToPolicyStep extends StatelessWidget {
  final VoidCallback onSuccess;

  const AgreeToPolicyStep({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onSuccess,
          child: const Text("약관 동의"),
        ),
      ],
    );
  }
}
