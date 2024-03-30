import 'package:flutter/material.dart';
import 'package:pomodak/view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

class StartButton extends StatelessWidget {
  const StartButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return ElevatedButton(
      onPressed: () {
        authViewModel.logOut();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(160, 54),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      child: const Text(
        'START',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
