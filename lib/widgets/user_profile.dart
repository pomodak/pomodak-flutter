import 'package:flutter/material.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.network(
            "https://d2quahb2ygxiv.cloudfront.net/df17af0a7a5c169f90044.png",
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
