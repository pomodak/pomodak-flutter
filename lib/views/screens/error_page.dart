import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/router/route_utils.dart';

class ErrorPage extends StatelessWidget {
  final String? error;
  const ErrorPage({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? ""),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed(AppPage.home.toName);
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
