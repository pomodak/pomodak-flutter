import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/models/domain/account_model.dart';

class AuthTokens {
  final String accessToken;
  final String? refreshToken;

  AuthTokens({required this.accessToken, this.refreshToken});
}

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokens tokens);
  Future<AuthTokens?> getTokens();
  Future<void> deleteTokens();

  Future<void> saveAccount(AccountModel account);
  Future<AccountModel?> getAccount();
  Future<void> deleteAccount();
}

const accessTokenKey = "accessToken";
const refreshTokenKey = "refreshToken";
const accountKey = "accountData";

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  AuthLocalDataSourceImpl(this.storage);

  @override
  Future<void> saveTokens(AuthTokens tokens) async {
    await storage.write(
        key: accessTokenKey,
        value: tokens.accessToken,
        aOptions: _androidOptions);
    if (tokens.refreshToken != null) {
      await storage.write(
          key: refreshTokenKey,
          value: tokens.refreshToken,
          aOptions: _androidOptions);
    }
  }

  @override
  Future<AuthTokens?> getTokens() async {
    try {
      var accessToken =
          await storage.read(key: accessTokenKey, aOptions: _androidOptions);
      var refreshToken =
          await storage.read(key: refreshTokenKey, aOptions: _androidOptions);

      if (accessToken != null) {
        return AuthTokens(accessToken: accessToken, refreshToken: refreshToken);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      await deleteTokens();
      rethrow;
    }
  }

  @override
  Future<void> deleteTokens() async {
    await storage.delete(key: accessTokenKey);
    await storage.delete(key: refreshTokenKey);
  }

  @override
  Future<AccountModel?> getAccount() async {
    try {
      var account =
          await storage.read(key: accountKey, aOptions: _androidOptions);

      if (account != null) {
        return AccountModel.fromJson(jsonDecode(account));
      }
      return null;
    } catch (e) {
      storage.delete(key: accountKey, aOptions: _androidOptions);
      rethrow;
    }
  }

  @override
  Future<void> saveAccount(AccountModel account) async {
    await storage.write(
      key: accountKey,
      value: jsonEncode(account.toJson()),
      aOptions: _androidOptions,
    );
  }

  @override
  Future<void> deleteAccount() async {
    await storage.delete(key: accountKey);
  }
}
