import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    } else {
      return 'http://10.0.2.2:8000';
    }
  }
  
  // Auth Endpoints
  static const String loginEndpoint = '/api/auth/login/';
  static const String registerEndpoint = '/api/auth/register/';
  static const String logoutEndpoint = '/api/auth/logout/';
  static const String userProfileEndpoint = '/api/user/profile/';
  
  // Dashboard Endpoints - ✅ TAMBAHKAN INI
  static const String dashboardEndpoint = '/api/dashboard/';
  static String leaveCommunityEndpoint(String communityId) => '/api/community/$communityId/leave/';
  static String leaveEventEndpoint(String eventId) => '/api/event/$eventId/leave/';
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class StorageKeys {
  static const String isLoggedIn = 'is_logged_in';
  static const String userId = 'user_id';
  static const String username = 'username';
  static const String email = 'email';
  static const String sessionCookie = 'session_cookie';
}