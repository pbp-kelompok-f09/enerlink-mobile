import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  // Ganti ke base URL server kamu (localhost emulator Android: 10.0.2.2)
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<http.Response> login(String username, String password) {
    final url = Uri.parse('$baseUrl/api/auth/login/');
    return http.post(url, body: {'username': username, 'password': password});
  }

  static Future<http.Response> register({
    required String username,
    required String email,
    required String password,
    required String name,
  }) {
    final url = Uri.parse('$baseUrl/api/auth/register/');
    return http.post(url, body: {
      'username': username,
      'email': email,
      'password': password,
      'name': name,
    });
  }

  static Future<http.StreamedResponse> updateProfile({
    required String tokenCookie, // jika pakai session cookie, isi dari storage
    required String username,
    required String name,
    required String email,
    required String description,
    File? profilePicture,
  }) async {
    // Gunakan endpoint Django HTML view: /user-dashboard/update-profile/
    final url = Uri.parse('$baseUrl/user-dashboard/update-profile/');
    final req = http.MultipartRequest('POST', url);

    req.fields['username'] = username;
    req.fields['name'] = name;
    req.fields['email'] = email;
    req.fields['description'] = description;

    if (profilePicture != null) {
      req.files.add(await http.MultipartFile.fromPath('profile_picture', profilePicture.path));
    }

    // Jika pakai session auth, kirim cookie (misal "sessionid=...")
    req.headers['Cookie'] = tokenCookie;

    return req.send();
  }
}