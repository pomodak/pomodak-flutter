import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pomodak/services/auth_service.dart';

class ApiUtil {
  static final AuthService _authService = AuthService();

  static Future<String?> _getAccessToken() async {
    return await _authService.refreshTokenIfNeeded();
  }

  static Future<Map<String, String>> _getHeaders() async {
    final accessToken = await _getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
  }

  static Future<http.Response> _sendRequest(String method, String url,
      {Map<String, dynamic>? data}) async {
    final uri = Uri.parse(url);
    final headers = await _getHeaders();

    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: json.encode(data));
      case 'PATCH':
        return await http.patch(uri, headers: headers, body: json.encode(data));
      case 'DELETE':
        return await http.delete(uri,
            headers: headers, body: json.encode(data));
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  static Future<http.Response> getData(String endpoint) async {
    return await _sendRequest('GET', endpoint);
  }

  static Future<http.Response> postData(
      String url, Map<String, dynamic> data) async {
    return await _sendRequest('POST', url, data: data);
  }

  static Future<http.Response> patchData(
      String url, Map<String, dynamic> data) async {
    return await _sendRequest('PATCH', url, data: data);
  }

  static Future<http.Response> deleteData(
      String url, Map<String, dynamic> data) async {
    return await _sendRequest('DELETE', url, data: data);
  }
}
