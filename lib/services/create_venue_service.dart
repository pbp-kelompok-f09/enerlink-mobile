import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/venue.dart';
import 'api_client.dart';

class CreateVenueService {
  static String get baseUrl => "${dotenv.env['BACKEND_URL']}/create-venue/api";
  
  // Helper method to get auth headers with fallback to session cookie
  static Future<Map<String, String>> _getAuthHeaders() async {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    
    final prefs = await SharedPreferences.getInstance();
    
    // Try to get token first
    final token = await ApiClient.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      headers['Cookie'] = 'sessionid=$token';
      return headers;
    }
    
    // Fallback to session cookie
    final sessionCookie = prefs.getString('session_cookie');
    if (sessionCookie != null && sessionCookie.isNotEmpty) {
      headers['Cookie'] = sessionCookie;
      return headers;
    }
    
    return headers;
  }

  // Get all venues (for management)
  static Future<VenueResponse> getVenues() async {
    try {
      String url = "$baseUrl/venues/";
      final headers = await _getAuthHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return VenueResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else if (response.statusCode == 403) {
        throw Exception('Only developers can access this feature.');
      } else {
        final jsonData = json.decode(response.body);
        throw Exception(
          jsonData['message'] ?? 'Failed to load venues. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Create venue
  static Future<Venue> createVenue({
    required String name,
    required String description,
    required String contactPerson,
    required double sessionPrice,
    required String category,
    String? address,
    double? rating,
    String? imageUrl,
    List<String>? facility,
    List<String>? rules,
  }) async {
    try {
      String url = "$baseUrl/venues/create/";
      final headers = await _getAuthHeaders();

      final body = json.encode({
        'name': name,
        'description': description,
        'contact_person': contactPerson,
        'session_price': sessionPrice,
        'category': category,
        if (address != null) 'address': address,
        if (rating != null) 'rating': rating,
        if (imageUrl != null) 'image_url': imageUrl,
        if (facility != null) 'facility': facility,
        if (rules != null) 'rules': rules,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 201) {
        return Venue.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else if (response.statusCode == 403) {
        throw Exception('Only developers can create venues.');
      } else {
        throw Exception(
          jsonData['message'] ?? jsonData['error'] ?? 'Failed to create venue. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('Authentication required') || e.toString().contains('Only developers')) {
        rethrow;
      }
      throw Exception('Error creating venue: $e');
    }
  }

  // Update venue
  static Future<Venue> updateVenue({
    required String venueId,
    String? name,
    String? description,
    String? contactPerson,
    double? sessionPrice,
    String? category,
    String? address,
    double? rating,
    String? imageUrl,
    List<String>? facility,
    List<String>? rules,
  }) async {
    try {
      String url = "$baseUrl/venues/$venueId/";
      final headers = await _getAuthHeaders();

      final bodyMap = <String, dynamic>{};
      if (name != null) bodyMap['name'] = name;
      if (description != null) bodyMap['description'] = description;
      if (contactPerson != null) bodyMap['contact_person'] = contactPerson;
      if (sessionPrice != null) bodyMap['session_price'] = sessionPrice;
      if (category != null) bodyMap['category'] = category;
      if (address != null) bodyMap['address'] = address;
      if (rating != null) bodyMap['rating'] = rating;
      if (imageUrl != null) bodyMap['image_url'] = imageUrl;
      if (facility != null) bodyMap['facility'] = facility;
      if (rules != null) bodyMap['rules'] = rules;

      final body = json.encode(bodyMap);

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        return Venue.fromJson(jsonData['data']);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else if (response.statusCode == 403) {
        throw Exception('Only developers can update venues.');
      } else {
        throw Exception(
          jsonData['message'] ?? jsonData['error'] ?? 'Failed to update venue. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('Authentication required') || e.toString().contains('Only developers')) {
        rethrow;
      }
      throw Exception('Error updating venue: $e');
    }
  }

  // Delete venue
  static Future<void> deleteVenue(String venueId) async {
    try {
      String url = "$baseUrl/venues/$venueId/delete/";
      final headers = await _getAuthHeaders();

      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] != 'success') {
          throw Exception(jsonData['message'] ?? 'Failed to delete venue');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else if (response.statusCode == 403) {
        throw Exception('Only developers can delete venues.');
      } else {
        final jsonData = json.decode(response.body);
        throw Exception(
          jsonData['message'] ?? 'Failed to delete venue. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('Authentication required') || e.toString().contains('Only developers')) {
        rethrow;
      }
      throw Exception('Error deleting venue: $e');
    }
  }
}

