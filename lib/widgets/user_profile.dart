import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final memberViewModel = Provider.of<MemberViewModel>(context);

    final member = memberViewModel.member;

    final imageUrl = member?.imageUrl.isEmpty ?? true
        ? CDNImages.newMember["mascot"]!
        : member!.imageUrl;
    final nickname = member?.nickname ?? "닉네임을 정해주세요.";
    final statusMessage = member?.statusMessage.isEmpty ?? true
        ? "상태 메시지를 입력해주세요."
        : member!.statusMessage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.network(
            imageUrl,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          nickname,
          style: const TextStyle(
            fontSize: 18,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          statusMessage,
          style: const TextStyle(
              fontSize: 16, letterSpacing: 1.2, color: Colors.black54),
        )
      ],
    );
  }
}
