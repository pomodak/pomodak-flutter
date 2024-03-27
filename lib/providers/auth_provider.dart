import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pomodak/models/account_model.dart';
import 'package:pomodak/models/member_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthProvider with ChangeNotifier {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AccountModel? _account;
  MemberModel? _user;

  AccountModel? get account => _account;
  MemberModel? get user => _user;

  Future<void> loginWithEmail(String email, String password) async {
    var response = await http.post(
      Uri.parse('$_nestApiEndpoint/auth/email/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      var accessToken = data['access_token'];
      var refreshToken = data['refresh_token'];
      var accountData = data['account'];

      await _storage.write(
          key: 'accessToken',
          value: accessToken,
          aOptions: _getAndroidOptions());
      await _storage.write(
          key: 'refreshToken',
          value: refreshToken,
          aOptions: _getAndroidOptions());

      _account = AccountModel.fromJson(accountData);
      await fetchUserInfo(_account!.accountId);

      notifyListeners();
    } else {
      // 로그인 실패 처리
    }
  }

  Future<void> refreshToken() async {
    var refreshToken = await _storage.read(
        key: 'refreshToken', aOptions: _getAndroidOptions());
    var response = await http.post(
      Uri.parse('$_nestApiEndpoint/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data'];
      var newAccessToken = data['access_token'];

      await _storage.write(
          key: 'accessToken',
          value: newAccessToken,
          aOptions: _getAndroidOptions());

      notifyListeners();
    } else {
      // 토큰 리프레시 실패 처리
    }
  }

  Future<void> fetchUserInfo(String accountId) async {
    var accessToken =
        await _storage.read(key: 'accessToken', aOptions: _getAndroidOptions());
    var response = await http.get(
      Uri.parse("$_nestApiEndpoint/members/me"),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body)['data']['member'];
      _user = MemberModel.fromJson(data);

      notifyListeners();
    } else {
      // 유저 정보 가져오기 실패 처리
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'accessToken', aOptions: _getAndroidOptions());
    await _storage.delete(key: 'refreshToken', aOptions: _getAndroidOptions());
    _account = null;
    _user = null;
    notifyListeners();
  }
}
