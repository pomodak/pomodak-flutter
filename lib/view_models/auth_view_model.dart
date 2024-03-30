import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pomodak/repositories/auth_repository.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/models/account_model.dart';

class AuthViewModel with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _myRepo = AuthRepository();

  AccountModel? _account;
  bool _loading = false;
  bool _isLoggedIn = false;

  AccountModel? get account => _account;
  bool get loading => _loading;
  bool get isLoggedIn => _isLoggedIn;

  // Callbacks
  Future<void> Function()? onLoginSuccess;
  Future<void> Function()? onLogoutComplete;

  AuthViewModel({this.onLoginSuccess, this.onLogoutComplete});

  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> emailLogin(
    BuildContext context, {
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      await _myRepo.emailLoginApi(email: email, password: password);

      await loadAccount(); // 계정 갱신

      if (onLoginSuccess != null) {
        await onLoginSuccess!();
      }
      if (context.mounted) {
        MessageUtil.flushbarSuccessMessage("로그인 성공", context);
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.flushbarErrorMessage(e.toString(), context);
      }
      await logOut();
    }
    setLoading(false);
  }

  Future<bool> emailRegister(
    BuildContext context, {
    required String email,
    required String password,
    required String code,
  }) async {
    setLoading(true);
    try {
      await _myRepo.emailRegisterApi(
        email: email,
        password: password,
        code: code,
      );

      await loadAccount(); // 계정 갱신

      if (onLoginSuccess != null) {
        await onLoginSuccess!();
      }
      if (context.mounted) {
        MessageUtil.flushbarSuccessMessage("회원가입 성공", context);
      }

      setLoading(false);
      return true;
    } catch (e) {
      if (context.mounted) {
        MessageUtil.flushbarErrorMessage(e.toString(), context);
      }
      await logOut();

      setLoading(false);
      return false;
    }
  }

  Future<bool> checkEmail(
    BuildContext context, {
    required String email,
  }) async {
    setLoading(true);
    try {
      await _myRepo.checkEmailApi(
        email: email,
      );

      if (context.mounted) {
        MessageUtil.flushbarSuccessMessage("인증코드를 발송했습니다.", context);
      }
      setLoading(false);
      return true;
    } catch (e) {
      if (context.mounted) {
        MessageUtil.flushbarErrorMessage(e.toString(), context);
      }
      setLoading(false);
      return false;
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    setLoading(true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      var authentication = await googleUser?.authentication;
      await _myRepo.googleLoginApi(idToken: authentication?.idToken ?? "");

      await loadAccount(); // 계정 갱신

      if (onLoginSuccess != null) {
        await onLoginSuccess!();
      }
      if (context.mounted) {
        MessageUtil.flushbarSuccessMessage("로그인 성공", context);
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.flushbarErrorMessage(e.toString(), context);
      }
      await logOut();
    }
    setLoading(false);
  }

  Future<void> kakaoLogin(BuildContext context) async {
    setLoading(true);

    try {
      String accessToken = await _signInWithKakao();
      await _myRepo.kakaoLoginApi(accessToken: accessToken);
      await loadAccount(); // 계정 갱신

      if (onLoginSuccess != null) {
        await onLoginSuccess!();
      }
      if (context.mounted) {
        MessageUtil.flushbarSuccessMessage("로그인 성공", context);
      }
    } catch (e) {
      if (context.mounted) {
        MessageUtil.flushbarErrorMessage(e.toString(), context);
      }
      await logOut();
    }

    setLoading(false);
  }

  Future<void> loadAccount() async {
    _account = await _myRepo.loadAccount();
    _isLoggedIn = _account != null;
    notifyListeners();
  }

  Future<void> logOut() async {
    await _myRepo.logOut();
    _isLoggedIn = false;
    _account = null;

    if (onLogoutComplete != null) {
      await onLogoutComplete!();
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
