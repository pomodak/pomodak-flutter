import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pomodak/repositories/auth_repository.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/models/account_model.dart';

class AuthViewModel with ChangeNotifier {
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
        MessageUtil.flushbarErrorMessage("로그인 성공", context);
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
}
