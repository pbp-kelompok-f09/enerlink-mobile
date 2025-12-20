import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';

class ApiClient {
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:8000';
    return 'http://10.0.2.2:8000';
  }

  static const String tokenKey = 'auth_token';
  static const Duration timeout = Duration(seconds: 15);

  // === Token Management ===
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setBool('isLoggedIn', true);
    print('🔐 Token saved: ${token.substring(0, 8)}...');
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(tokenKey);
    await prefs.remove('isLoggedIn');
    print('🗑️ Session cleared');
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // === Auth ===
  static Future<http.Response> login(String username, String password) async {
    try {
      final uri = Uri.parse('$baseUrl/api/auth/login/');
      print('🔄 Login request to: $uri');
      
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      ).timeout(timeout);

      print('✅ Login response: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
      }
      return resp;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  static Future<http.Response> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    String lastName = '',
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/auth/register/');
      print('🔄 Register request to: $uri');

      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'first_name': firstName,
          'last_name': lastName,
        }),
      ).timeout(timeout);

      print('✅ Register response: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
      }
      return resp;
    } catch (e) {
      print('❌ Register error: $e');
      rethrow;
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await getAuthHeaders();
      final uri = Uri.parse('$baseUrl/api/auth/logout/');
      await http.post(uri, headers: headers).timeout(timeout);
    } catch (_) {}
    await clearSession();
  }

  // === Dashboard Data ===
  static Future<Map<String, dynamic>?> getDashboardData() async {
    try {
      final headers = await getAuthHeaders();
      final uri = Uri.parse('$baseUrl/api/dashboard/');
      print('🔄 Dashboard request to: $uri');

      final resp = await http.get(uri, headers: headers).timeout(timeout);

      print('✅ Dashboard response: ${resp.statusCode}');

      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      } else if (resp.statusCode == 401) {
        print('⚠️ Not authenticated - clearing session');
        await clearSession();
      }
    } catch (e) {
      print('❌ Dashboard error: $e');
    }
    return null;
  }

  // === Profile ===
  static Future<Map<String, dynamic>?> getProfile() async {
    return getDashboardData();
  }

  // 🔄 CHANGED: Update updateProfile method

  static Future<bool> updateProfile({
    required String name,
    required String email,
    required String username,
    String? description,
    XFile? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final token = await getToken();
      if (token == null) {
        print('❌ No token!');
        return false;
      }
      
      final uri = Uri.parse('$baseUrl/api/profile/update/');

      print('');
      print('╔════════════════════════════════════╗');
      print('║     API CLIENT: UPDATE PROFILE     ║');
      print('╚════════════════════════════════════╝');
      print('🔄 URL: $uri');
      print('🔄 imageBytes received: ${imageBytes?.length ?? "NULL"} bytes');
      print('🔄 imageFile received: ${imageFile?.name ?? "NULL"}');

      final req = http.MultipartRequest('POST', uri);
      req.headers['Authorization'] = 'Bearer $token';
      
      // Fields
      req.fields['name'] = name;
      req.fields['email'] = email;
      req.fields['username'] = username;
      if (description != null) req.fields['description'] = description;

      // ➕ CRITICAL: Add image if available
      if (imageBytes != null && imageBytes.isNotEmpty) {
        print('📷 ═══════════════════════════════════');
        print('📷 ADDING IMAGE TO MULTIPART REQUEST');
        print('📷 ═══════════════════════════════════');
        
        String filename = imageFile?.name ?? 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        
        // Determine mime type
        String mimeType = 'image/jpeg';
        final ext = filename.toLowerCase().split('.').last;
        if (ext == 'png') mimeType = 'image/png';
        else if (ext == 'gif') mimeType = 'image/gif';
        else if (ext == 'webp') mimeType = 'image/webp';
        
        print('📷 Filename: $filename');
        print('📷 MimeType: $mimeType');
        print('📷 Size: ${imageBytes.length} bytes');
        
        final multipartFile = http.MultipartFile.fromBytes(
          'profile_picture',
          imageBytes,
          filename: filename,
          contentType: MediaType.parse(mimeType),
        );
        
        req.files.add(multipartFile);
        
        print('📷 ✅ File added successfully!');
        print('📷 Request files count: ${req.files.length}');
        print('📷 File field name: ${req.files.first.field}');
        print('📷 File length: ${req.files.first.length}');
      } else {
        print('📷 ⚠️ NO IMAGE TO UPLOAD');
        print('📷 imageBytes is ${imageBytes == null ? "NULL" : "EMPTY"}');
      }

      print('🚀 Sending request...');
      final streamed = await req.send().timeout(timeout);
      final response = await http.Response.fromStream(streamed);
      
      print('✅ Status: ${response.statusCode}');
      print('✅ Body: ${response.body}');
      print('═══════════════════════════════════════');
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error: $e');
      return false;
    }
  }

  // === Wallet ===
  static Future<bool> topUpWallet(double amount) async {
    try {
      final headers = await getAuthHeaders();
      final uri = Uri.parse('$baseUrl/api/wallet/topup/');
      print('🔄 Top up wallet: $amount');

      final resp = await http.post(
        uri,
        headers: headers,
        body: jsonEncode({'amount': amount}),
      ).timeout(timeout);

      print('✅ Top up response: ${resp.statusCode}');
      return resp.statusCode == 200;
    } catch (e) {
      print('❌ Top up error: $e');
      return false;
    }
  }

  // === Events ===
  static Future<bool> cancelEvent(String eventId) async {
    try {
      final headers = await getAuthHeaders();
      final uri = Uri.parse('$baseUrl/api/event/$eventId/leave/');
      final resp = await http.post(uri, headers: headers).timeout(timeout);
      return resp.statusCode == 200;
    } catch (e) {
      print('❌ Cancel event error: $e');
      return false;
    }
  }

  // === Communities ===
  static Future<bool> leaveCommunity(String communityId) async {
    try {
      final headers = await getAuthHeaders();
      final uri = Uri.parse('$baseUrl/api/community/$communityId/leave/');
      final resp = await http.post(uri, headers: headers).timeout(timeout);
      return resp.statusCode == 200;
    } catch (e) {
      print('❌ Leave community error: $e');
      return false;
    }
  }
  
  // === Check if logged in ===
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}