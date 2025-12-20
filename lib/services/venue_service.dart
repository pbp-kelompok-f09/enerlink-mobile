import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/venue.dart';
import '../models/booking.dart';

class VenueService {
  static String get baseUrl => "${dotenv.env['BACKEND_URL']}/rent-venue/api";

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

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return BookingResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login first.');
      } else {
        throw Exception(
          'Failed to load bookings. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Get booking detail
  static Future<Booking> getBookingDetail(String bookingId) async {
    try {
      String url = "$baseUrl/bookings/$bookingId/";

      final response = await http.get(Uri.parse(url));

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

      final body = json.encode({
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
      });

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      final jsonData = json.decode(response.body);

      if (response.statusCode == 201) {
        return BookingResponse.fromJson(jsonData);
      } else {
        throw Exception(
          jsonData['message'] ?? 'Failed to create booking. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
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

      final body = json.encode({
        'booking_date': bookingDate,
        'start_time': startTime,
        'end_time': endTime,
      });

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
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

      final response = await http.delete(Uri.parse(url));

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

