import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/venue.dart';
import '../models/booking.dart';
import 'api_client.dart'; // Import ApiClient for headers

class VenueService {
  static String get baseUrl => "${dotenv.env['BACKEND_URL']}/rent-venue/api";
  
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
      // Try both Bearer token and Cookie with sessionid
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

  // Get all venues
  static Future<VenueResponse> getVenues({
    String? search,
    String? category,
    String? maxPrice,
  }) async {
    try {
      String url = "$baseUrl/venues/";
      List<String> queryParams = [];
      
      if (search != null && search.isNotEmpty) {
        queryParams.add("search=$search");
      }
      if (category != null && category.isNotEmpty) {
        queryParams.add("category=$category");
      }
      if (maxPrice != null && maxPrice.isNotEmpty) {
        queryParams.add("max_price=$maxPrice");
      }
      
      if (queryParams.isNotEmpty) {
        url += "?${queryParams.join('&')}";
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return VenueResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
          'Failed to load venues. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Get venue detail
  static Future<Venue> getVenueDetail(String venueId) async {
    try {
      String url = "$baseUrl/venues/$venueId/";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return Venue.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to load venue');
        }
      } else {
        throw Exception(
          'Failed to load venue. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Get user bookings
  static Future<BookingResponse> getBookings() async {
    try {
      String url = "$baseUrl/bookings/";
      final headers = await _getAuthHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw Exception('Empty response from server');
        }
        
        dynamic decodedResponse;
        try {
          decodedResponse = json.decode(responseBody);
        } catch (e) {
          throw Exception('Failed to decode JSON response: $e');
        }
        
        // Handle both direct array and object with data field
        if (decodedResponse is List) {
          // If response is directly a list
          try {
            return BookingResponse(
              status: 'success',
              dataList: List<Booking>.from(
                decodedResponse.map((x) {
                  if (x is Map<String, dynamic>) {
                    return Booking.fromJson(x);
                  } else {
                    throw Exception('Invalid booking item format: ${x.runtimeType}');
                  }
                })
              ),
              count: decodedResponse.length,
            );
          } catch (e) {
            throw Exception('Error parsing booking list: $e');
          }
        } else if (decodedResponse is Map<String, dynamic>) {
          // If response is an object with status and data
          return BookingResponse.fromJson(decodedResponse);
        } else {
          throw Exception('Invalid response format from server: ${decodedResponse.runtimeType}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else {
        try {
          final errorBody = json.decode(response.body);
          throw Exception(
            errorBody['message'] ?? 'Failed to load bookings. Status code: ${response.statusCode}',
          );
        } catch (_) {
          throw Exception('Failed to load bookings. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Get booking detail
  static Future<Booking> getBookingDetail(String bookingId) async {
    try {
      String url = "$baseUrl/bookings/$bookingId/";
      final headers = await _getAuthHeaders();

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          return Booking.fromJson(jsonData['data']);
        } else {
          throw Exception(jsonData['message'] ?? 'Failed to load booking');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else {
        throw Exception(
          'Failed to load booking. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Create booking
  static Future<BookingResponse> createBooking({
    required String venueId,
    required String bookingDate,
    required String startTime,
    required String endTime,
  }) async {
    try {
      String url = "$baseUrl/book/$venueId/";
      final headers = await _getAuthHeaders();

      final body = json.encode({
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      // Check if response body is empty
      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      Map<String, dynamic> jsonData;
      try {
        jsonData = json.decode(response.body) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Invalid JSON response: ${response.body}');
      }

      if (response.statusCode == 201) {
        return BookingResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login again.');
      } else {
        throw Exception(
          jsonData['message'] ?? jsonData['error'] ?? 'Failed to create booking. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e.toString().contains('Authentication required')) {
        rethrow;
      }
      throw Exception('Error creating booking: $e');
    }
  }

  // Update booking
  static Future<BookingResponse> updateBooking({
    required String bookingId,
    required String bookingDate,
    required String startTime,
    required String endTime,
  }) async {
    try {
      String url = "$baseUrl/bookings/$bookingId/update/";
      final headers = await _getAuthHeaders();

      final body = json.encode({
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
      });

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to update booking. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating booking: $e');
    }
  }

  // Cancel booking
  static Future<void> cancelBooking(String bookingId) async {
    try {
      String url = "$baseUrl/bookings/$bookingId/cancel/";
      final headers = await _getAuthHeaders();

      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] != 'success') {
          throw Exception(jsonData['message'] ?? 'Failed to cancel booking');
        }
      } else {
        final jsonData = json.decode(response.body);
        throw Exception(
          jsonData['message'] ?? 'Failed to cancel booking. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error cancelling booking: $e');
    }
  }
}

