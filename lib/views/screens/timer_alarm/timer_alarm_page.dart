import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/views/widgets/custom_button.dart';

class TimerAlarmPage extends StatelessWidget {
  const TimerAlarmPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Image.network(
                    CDNImages.mascot["finish"]!,
                  )),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: 20,
                  left: 32,
                  right: 32,
                ),
                width: size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      '뽀모닭',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomButton(
                      onTap: () {
                        context.go('/login');
                      },
                      text: "접속하기",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
