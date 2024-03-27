import 'package:pomodak/models/account_model.dart';

class AuthResponseData {
  final AccountModel account;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthResponseData({
    required this.account,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthResponseData.fromJson(Map<String, dynamic> json) {
    return AuthResponseData(
      account: AccountModel.fromJson(json['account']),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}

class RefreshResponseData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  RefreshResponseData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory RefreshResponseData.fromJson(Map<String, dynamic> json) {
    return RefreshResponseData(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      expiresIn: json['expires_in'] as int,
    );
  }
}
