import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/models/domain/account_model.dart';

const accessTokenKey = "accessToken";
const refreshTokenKey = "refreshToken";
const accountKey = "accountData";

class AuthStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AndroidOptions _androidOptions = const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  Future<void> storeTokens(String accessToken, {String? refreshToken}) async {
    await _storage.write(
        key: accessTokenKey, value: accessToken, aOptions: _androidOptions);
    if (refreshToken != null) {
      await _storage.write(
          key: refreshTokenKey, value: refreshToken, aOptions: _androidOptions);
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: accessTokenKey, aOptions: _androidOptions);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: refreshTokenKey, aOptions: _androidOptions);
  }

  Future<void> deleteAllData() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: accountKey);
  }

  Future<AccountModel?> getAccount() async {
    var account =
        await _storage.read(key: accountKey, aOptions: _androidOptions);

    if (account != null) {
      return AccountModel.fromJson(jsonDecode(account));
    }
    return null;
  }

  Future<void> storeAccount(AccountModel account) async {
    await _storage.write(
      key: accountKey,
      value: jsonEncode(account.toJson()),
      aOptions: _androidOptions,
    );
  }
}
