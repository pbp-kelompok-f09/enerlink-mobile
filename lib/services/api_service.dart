import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';
import '../utils/shared_preferences_helper.dart';

class ApiService {
  static Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final sessionCookie = await SharedPreferencesHelper.getSessionCookie();
      if (sessionCookie != null) {
        headers['Cookie'] = sessionCookie;
      }
    }

    return headers;
  }

  static Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
    bool includeAuth = false,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(ApiConstants.connectionTimeout);

      return response;
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  static Future<http.Response> get({
    required String endpoint,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final headers = await _getHeaders(includeAuth: includeAuth);

    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(ApiConstants.connectionTimeout);

      return response;
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}