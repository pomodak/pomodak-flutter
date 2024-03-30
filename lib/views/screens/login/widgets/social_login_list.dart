import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pomodak/views/widgets/custom_button.dart';

class SocialLoginList extends StatelessWidget {
  final VoidCallback onGoogleLoginTap;
  final VoidCallback onKakaoLoginTap;
  // final VoidCallback onNaverLoginTap;

  const SocialLoginList({
    super.key,
    required this.onGoogleLoginTap,
    required this.onKakaoLoginTap,
    // required this.onNaverLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomButton(
          icon: SvgPicture.asset("assets/icons/google.svg", height: 20),
          text: "구글 로그인",
          onTap: onGoogleLoginTap,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
        const SizedBox(height: 8),
        CustomButton(
          icon: SvgPicture.asset("assets/icons/kakao.svg", height: 16),
          text: "카카오 로그인",
          onTap: onKakaoLoginTap,
          backgroundColor: const Color(0xffFEE500),
          textColor: Colors.black,
          borderWidth: 0,
        ),
        // const SizedBox(height: 8),
        // CustomButton(
        //   icon: SvgPicture.asset("assets/icons/naver.svg", height: 20),
        //   text: "네이버 로그인",
        //   onTap: onNaverLoginTap,
        //   backgroundColor: const Color(0xff03C75A),
        //   textColor: Colors.white,
        //   borderWidth: 0,
        // ),
      ],
    );
  }
}
