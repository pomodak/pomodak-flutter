import 'package:flutter/material.dart';

class ShowUserGuideButton extends StatelessWidget {
  const ShowUserGuideButton({super.key});

  void showUserGuide(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("User Guide"),
          content: const Text("Here is how to use the app..."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {
          showUserGuide(context);
        },
        child: const Text(
          "How to use?",
          style: TextStyle(
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
