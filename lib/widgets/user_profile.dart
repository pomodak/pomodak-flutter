import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.network(
            CDNImages.newMember["mascot"]!,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        const Text(
          "이름",
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "상태메세지",
          style: TextStyle(
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        )
      ],
    );
  }
}
