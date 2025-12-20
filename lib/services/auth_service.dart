import 'dart:convert';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/shared_preferences_helper.dart';
import 'api_service.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: ApiConstants.loginEndpoint,
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 302) {
        // Extract session cookie from response headers
        final cookies = response.headers['set-cookie'];
        
        // Parse response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Create User object
        final user = User.fromJson(responseData['user']);
        
        // Save login data
        await SharedPreferencesHelper.saveLoginData(
          user: user,
          sessionCookie: cookies ?? '',
        );

        return {
          'success': true,
          'message': 'Login successful',
          'user': user,
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await ApiService.post(
        endpoint: ApiConstants.registerEndpoint,
        body: {
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'message': responseData['message'] ?? 'Registration successful',
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {
          'success': false,
          'message': errorData['error'] ?? 'Registration failed',
          'errors': errorData['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: ${e.toString()}',
      };
    }
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    try {
      await ApiService.post(
        endpoint: ApiConstants.logoutEndpoint,
        body: {},
        includeAuth: true,
      );

      // Clear local data regardless of server response
      await SharedPreferencesHelper.clearLoginData();

      return {
        'success': true,
        'message': 'Logout successful',
      };
    } catch (e) {
      // Clear local data even if server request fails
      await SharedPreferencesHelper.clearLoginData();
      
      return {
        'success': true,
        'message': 'Logged out locally',
      };
    }
  }

  // Check authentication status
  static Future<bool> isAuthenticated() async {
    return await SharedPreferencesHelper.isLoggedIn();
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    return await SharedPreferencesHelper.getUserData();
  }
}