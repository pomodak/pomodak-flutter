import 'dart:convert';
import 'dart:io';

import 'package:pomodak/data/app_exceptions.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:http/http.dart' as http;
import 'package:pomodak/data/repositories/auth_repository.dart';
import 'package:pomodak/models/api/base_api_response.dart';

class NetworkApiService extends BaseApiServices {
  static final AuthRepository _authRepository = AuthRepository();

  @override
  Future getGetApiResponse(String url) async {
    dynamic responseJson;
    final uri = Uri.parse(url);
    final headers = await _getHeaders();
    try {
      final response = await http
          .get(uri, headers: headers)
          .timeout(const Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      // 인터넷 연결 에러
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPostApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    final uri = Uri.parse(url);
    final headers = await _getHeaders();
    try {
      final response = await http
          .post(
            uri,
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      // 인터넷 연결 에러
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getPatchApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    final uri = Uri.parse(url);
    final headers = await _getHeaders();
    try {
      final response = await http
          .patch(
            uri,
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      // 인터넷 연결 에러
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  @override
  Future getDeleteApiResponse(String url, dynamic data) async {
    dynamic responseJson;
    final uri = Uri.parse(url);
    final headers = await _getHeaders();
    try {
      final response = await http
          .delete(
            uri,
            headers: headers,
            body: json.encode(data),
          )
          .timeout(const Duration(seconds: 10));
      responseJson = _returnResponse(response);
    } on SocketException {
      // 인터넷 연결 에러
      throw FetchDataException('No Internet Connection');
    }

    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      default: // 나머지 서버에서 발생한 에러처리
        dynamic responseJson = jsonDecode(response.body);
        // 서버에서 body에 message를 담아 보냈을 경우
        if (responseJson["message"] != null) {
          return BaseApiResponse.fromJson(responseJson, (json) => null);
        } else {
          // 그외
          throw FetchDataException(
              "Error occurred while communicating with server with status code ${response.statusCode}");
        }
    }
  }

  Future<String?> _getAccessToken() async {
    return await _authRepository.refreshTokenIfNeeded();
  }

  Future<Map<String, String>> _getHeaders() async {
    final accessToken = await _getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }
}
