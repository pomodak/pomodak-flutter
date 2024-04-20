import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';

class MemberCard extends StatelessWidget {
  final String nickname;
  final String imageUrl;
  final String timeStr;

  const MemberCard({
    super.key,
    required this.nickname,
    required this.imageUrl,
    required this.timeStr,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0, left: 8, right: 8),
          child: Text(
            nickname,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Expanded(
          child: Image.network(
            imageUrl.isEmpty ? CDNImages.newMember["mascot"]! : imageUrl,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(timeStr),
        ),
      ],
    );
  }
}
