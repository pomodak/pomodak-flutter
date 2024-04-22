import 'dart:async';

import 'package:pomodak/data/datasources/local/auth_local_datasource.dart';
import 'package:pomodak/data/datasources/remote/auth_remote_datasource.dart';
import 'package:pomodak/models/api/base_api_response.dart';
import 'package:pomodak/models/api/login_response.dart';
import 'package:pomodak/models/domain/account_model.dart';

class AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  // 이메일로 로그인
  Future<BaseApiResponse<LoginResponse>> emailLogin({
    required String email,
    required String password,
  }) async {
    try {
      BaseApiResponse<LoginResponse> response =
          await remoteDataSource.emailLoginApi(
        email: email,
        password: password,
      );
      var data = response.data;
      if (data != null) {
        AuthTokens tokens = AuthTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _saveLoginData(tokens: tokens, account: data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 이메일로 회원가입
  Future<BaseApiResponse<LoginResponse>> emailRegister({
    required String email,
    required String password,
    required String code,
  }) async {
    try {
      BaseApiResponse<LoginResponse> response =
          await remoteDataSource.emailRegisterApi(
        email: email,
        password: password,
        code: code,
      );

      var data = response.data;

      if (data != null) {
        AuthTokens tokens = AuthTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _saveLoginData(tokens: tokens, account: data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 이메일 확인 메일 발송
  Future<void> checkEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.checkEmailApi(email: email);
    } catch (e) {
      rethrow;
    }
  }

  // 구글 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> googleLogin({
    required String idToken,
  }) async {
    try {
      BaseApiResponse<LoginResponse> response =
          await remoteDataSource.googleLoginApi(
        idToken: idToken,
      );
      var data = response.data;
      if (data != null) {
        AuthTokens tokens = AuthTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _saveLoginData(tokens: tokens, account: data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 카카오 OAuth 로그인
  Future<BaseApiResponse<LoginResponse>> kakaoLogin({
    required String accessToken,
  }) async {
    try {
      BaseApiResponse<LoginResponse> response =
          await remoteDataSource.kakaoLoginApi(accessToken: accessToken);

      var data = response.data;
      if (data != null) {
        AuthTokens tokens = AuthTokens(
          accessToken: data.accessToken,
          refreshToken: data.refreshToken,
        );
        await _saveLoginData(tokens: tokens, account: data.account);
      }

      return response;
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccountApi();
      await localDataSource.deleteAccount();
    } catch (e) {
      logOut();
      rethrow;
    }
  }

  // 저장소를 확인하여 계정 반환 (에러 발생시 저장소 초기화)
  Future<AccountModel?> getAccount() async {
    try {
      return localDataSource.getAccount();
    } catch (e) {
      await logOut();
      rethrow;
    }
  }

  // 스토리지(토큰, 계정) 비우기
  Future<void> logOut() async {
    await localDataSource.deleteTokens();
    await localDataSource.deleteAccount();
  }

  Future<AuthTokens?> getTokens() async {
    return await localDataSource.getTokens();
  }

  Future<void> _saveLoginData(
      {required AuthTokens tokens, AccountModel? account}) async {
    await localDataSource.saveTokens(tokens);
    if (account != null) await localDataSource.saveAccount(account);
  }
}
