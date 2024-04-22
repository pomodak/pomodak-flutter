import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/models/domain/account_model.dart';
import 'package:pomodak/view_models/member_view_model.dart';

class AuthViewModel with ChangeNotifier {
  // DI
  late final AuthRepository repository;
  final MemberViewModel memberViewModel;

  // Data
  AccountModel? _account;
  bool _isLoggedIn = false;

  // 로딩 상태
  bool _isLoadingLogin = false;
  bool _isLoadingRegister = false;
  bool _isLoadingCheckEmail = false;

  // 에러 메시지
  String? _loginError;
  String? _registerError;
  String? _checkEmailError;

  AccountModel? get account => _account;
  bool get isLoggedIn => _isLoggedIn;

  bool get isLoadingLogin => _isLoadingLogin;
  bool get isLoadingRegister => _isLoadingRegister;
  bool get isLoadingCheckEmail => _isLoadingCheckEmail;

  String? get loginError => _loginError;
  String? get registerError => _registerError;
  String? get checkEmailError => _checkEmailError;

  AuthViewModel({required this.repository, required this.memberViewModel});

  Future<void> loadAccount() async {
    _account = await repository.getAccount(); // secureStorage에서 계정 정보 가져오기
    _isLoggedIn = _account != null;
    notifyListeners();
  }

  Future<void> emailLogin({
    required String email,
    required String password,
  }) async {
    if (_isLoadingLogin) return;
    _setLoadingState('login', isLoading: true);
    try {
      _setError("login");
      await repository.emailLogin(email: email, password: password);
      await _loginSuccess();
    } catch (e) {
      _handleError("login", e);
      await logOut();
    } finally {
      _setLoadingState('login', isLoading: false);
    }
  }

  Future<bool> emailRegister({
    required String email,
    required String password,
    required String code,
  }) async {
    if (_isLoadingRegister) return false;
    _setLoadingState('register', isLoading: true);
    try {
      _setError("register");
      await repository.emailRegister(
        email: email,
        password: password,
        code: code,
      );
      await _loginSuccess();
      return true;
    } catch (e) {
      _handleError('register', e);
      await logOut();
      return false;
    } finally {
      _setLoadingState('register', isLoading: false);
    }
  }

  Future<bool> checkEmail({
    required String email,
  }) async {
    if (_isLoadingCheckEmail) return false;
    _setLoadingState('checkEmail', isLoading: true);
    try {
      _setError("checkEmail");
      await repository.checkEmail(
        email: email,
      );

      MessageUtil.showSuccessToast("인증코드를 발송했습니다.");
      return true;
    } catch (e) {
      _handleError('checkEmail', e);
      return false;
    } finally {
      _setLoadingState('checkEmail', isLoading: false);
    }
  }

  Future<void> googleLogin() async {
    if (_isLoadingLogin) return;
    _setLoadingState('login', isLoading: true);
    try {
      _setError("login");
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      var authentication = await googleUser?.authentication;
      await repository.googleLogin(idToken: authentication?.idToken ?? "");
      await _loginSuccess();
    } catch (e) {
      _handleError('login', e);
      await logOut();
    } finally {
      _setLoadingState('login', isLoading: false);
    }
  }

  Future<void> kakaoLogin() async {
    if (_isLoadingLogin) return;
    _setLoadingState('login', isLoading: true);
    try {
      _setError("login");
      String accessToken = await _signInWithKakao();
      await repository.kakaoLogin(accessToken: accessToken);
      await _loginSuccess();
    } catch (e) {
      _handleError('login', e);
      await logOut();
    } finally {
      _setLoadingState('login', isLoading: false);
    }
  }

  Future<void> logOut() async {
    await repository.logOut();
    _isLoggedIn = false;
    _account = null;

    await memberViewModel.clearMemberData();
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    await repository.deleteAccount();
    _isLoggedIn = false;
    _account = null;

    await memberViewModel.clearMemberData();
    notifyListeners();
  }

  // 앱 시작 시 실행하는 로직
  Future<void> onAppStart() async {
    await loadAccount();
  }

  Future<AuthTokens?> getTokens() async {
    return await repository.getTokens();
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

  Future<void> _loginSuccess() async {
    await loadAccount(); // 계정 정보 갱신
    await memberViewModel.loadMemberRelatedData(forceUpdate: true); // 회원 정보 갱신
    MessageUtil.showSuccessToast("로그인 성공");
    notifyListeners();
  }

  void _handleError(String field, Object e) {
    final errorMessage = e.toString();
    _setError(field, errorMessage);
    MessageUtil.showErrorToast(errorMessage);
  }

  void _setLoadingState(String field, {required bool isLoading}) {
    switch (field) {
      case 'login':
        _isLoadingLogin = isLoading;
        break;
      case 'register':
        _isLoadingRegister = isLoading;
        break;
      case 'checkEmail':
        _isLoadingCheckEmail = isLoading;
        break;
    }
    notifyListeners();
  }

  void _setError(String field, [String? errorMessage]) {
    switch (field) {
      case 'login':
        _loginError = errorMessage;
        break;
      case 'register':
        _registerError = errorMessage;
        break;
      case 'checkEmail':
        _checkEmailError = errorMessage;
        break;
    }
    notifyListeners();
  }
}
