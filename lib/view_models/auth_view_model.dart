import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/models/domain/account_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:provider/provider.dart';

class AuthViewModel with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final AuthRepository repository;

  AccountModel? _account;
  final bool _loading = false;
  bool _isLoggedIn = false;

  AccountModel? get account => _account;
  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;

  AuthViewModel({
    required this.repository,
  });

  Future<void> emailLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    try {
      await repository.emailLoginApi(email: email, password: password);

      await loadAccount(); // 계정 갱신

      if (context.mounted) {
        MessageUtil.showSuccessToast(
          "로그인 성공",
        );
        await Provider.of<MemberViewModel>(context, listen: false).login();
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.showErrorToast(e.toString());
        await logOut(context);
      }
    }
  }

  Future<bool> emailRegister(
    BuildContext context, {
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      await repository.emailRegisterApi(
        email: email,
        password: password,
        code: code,
      );

      if (context.mounted) {
        MessageUtil.showSuccessToast("회원가입 성공");
        await Provider.of<MemberViewModel>(context, listen: false).login();
      }

      await loadAccount(); // 계정 갱신
      return true;
    } catch (e) {
      if (context.mounted) {
        MessageUtil.showErrorToast(e.toString());
        await logOut(context);
      }

      return false;
    }
  }

  Future<bool> checkEmail(
    BuildContext context, {
    required String email,
  }) async {
    try {
      await repository.checkEmailApi(
        email: email,
      );

      if (context.mounted) {
        MessageUtil.showSuccessToast("인증코드를 발송했습니다.");
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        MessageUtil.showErrorToast(e.toString());
      }
      return false;
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      var authentication = await googleUser?.authentication;
      await repository.googleLoginApi(idToken: authentication?.idToken ?? "");

      await loadAccount(); // 계정 갱신

      if (context.mounted) {
        MessageUtil.showSuccessToast("로그인 성공");
        await Provider.of<MemberViewModel>(context, listen: false).login();
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.showErrorToast(e.toString());
        await logOut(context);
      }
    }
  }

  Future<void> kakaoLogin(BuildContext context) async {
    try {
      String accessToken = await _signInWithKakao();
      await repository.kakaoLoginApi(accessToken: accessToken);
      await loadAccount(); // 계정 갱신

      if (context.mounted) {
        MessageUtil.showSuccessToast(
          "로그인 성공",
        );
        await Provider.of<MemberViewModel>(context, listen: false).login();
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.showErrorToast(e.toString());
        await logOut(context);
      }
    }
  }

  Future<void> loadAccount() async {
    _account = await repository.getAccount();
    _isLoggedIn = _account != null;
    notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    await repository.logOut();
    _isLoggedIn = false;
    _account = null;

    if (context.mounted) {
      await Provider.of<MemberViewModel>(context, listen: false).remove();
    }
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  Future<void> onAppStart() async {
    await loadAccount();
    notifyListeners();
  }

  Future<String> _signInWithKakao() async {
    OAuthToken result;
    if (await isKakaoTalkInstalled()) {
      try {
        result = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          throw '카카오톡으로 로그인 취소';
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          result = await UserApi.instance.loginWithKakaoAccount();
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') {
            throw '카카오톡으로 로그인 취소';
          }
          throw '카카오계정으로 로그인 실패';
        }
      }
    } else {
      try {
        result = await UserApi.instance.loginWithKakaoAccount();
      } catch (error) {
        if (error is PlatformException && error.code == 'CANCELED') {
          throw '카카오톡으로 로그인 취소';
        }
        throw '카카오계정으로 로그인 실패';
      }
    }
    return result.accessToken;
  }
}
