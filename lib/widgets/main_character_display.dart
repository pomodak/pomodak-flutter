import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';

class MainCharacterDisplay extends StatefulWidget {
  final double width;
  const MainCharacterDisplay({super.key, required this.width});

  @override
  State<MainCharacterDisplay> createState() => _MainCharacterDisplayState();
}

class _MainCharacterDisplayState extends State<MainCharacterDisplay> {
  String message = "Welcome!";
  List<String> messages = ["Hello!", "Welcome!", "Enjoy!"];
  int messageIndex = 0;
  bool showMessage = true;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        messageIndex = (messageIndex + 1) % messages.length;
        message = messages[messageIndex];
        showMessage = true;
      });
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          showMessage = false;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.network(
          CDNImages.mascot["normal"]!,
          width: widget.width,
          fit: BoxFit.contain,
        ),
        if (showMessage)
          Positioned(
            bottom: 190,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white70, // 혹시 이미지랑 겹치면 약간의 배경색으로 보이도록
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
      ],
    );
  }
}
