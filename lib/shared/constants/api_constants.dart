import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get baseUrl => dotenv.env['BASE_URL']!;
  static String get adminDashboard => "/api/admin/dashboard/";
  static String get adminVenues => "/api/admin/venues/";
}