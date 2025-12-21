import 'dart:convert';

class Booking {
  final String id;
  final VenueInfo venue;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.venue,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json["id"],
        venue: VenueInfo.fromJson(json["venue"]),
        bookingDate: DateTime.parse(json["booking_date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        totalPrice: (json["total_price"] is int)
            ? json["total_price"].toDouble()
            : json["total_price"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "venue": venue.toJson(),
        "booking_date": bookingDate.toIso8601String().split('T')[0],
        "start_time": startTime,
        "end_time": endTime,
        "total_price": totalPrice,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}

class VenueInfo {
  final String idVenue;
  final String name;
  final String? imageUrl;
  final double? rating;
  final String? description;
  final String? address;
  final String? contactPerson;
  final List<String>? facility;
  final List<dynamic>? rules;
  final double? sessionPrice;
  final List<String>? category;

  VenueInfo({
    required this.idVenue,
    required this.name,
    this.imageUrl,
    this.rating,
    this.description,
    this.address,
    this.contactPerson,
    this.facility,
    this.rules,
    this.sessionPrice,
    this.category,
  });

  factory VenueInfo.fromJson(Map<String, dynamic> json) => VenueInfo(
        idVenue: json["id_venue"],
        name: json["name"],
        imageUrl: json["image_url"],
        rating: json["rating"] != null
            ? ((json["rating"] is int) ? json["rating"].toDouble() : json["rating"])
            : null,
        description: json["description"],
        address: json["address"],
        contactPerson: json["contact_person"],
        facility: json["facility"] != null
            ? List<String>.from(json["facility"].map((x) => x.toString()))
            : null,
        rules: json["rules"],
        sessionPrice: json["session_price"] != null
            ? ((json["session_price"] is int)
                ? json["session_price"].toDouble()
                : json["session_price"])
            : null,
        category: json["category"] != null
            ? List<String>.from(json["category"].map((x) => x.toString()))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id_venue": idVenue,
        "name": name,
        if (imageUrl != null) "image_url": imageUrl,
        if (rating != null) "rating": rating,
        if (description != null) "description": description,
        if (address != null) "address": address,
        if (contactPerson != null) "contact_person": contactPerson,
        if (facility != null) "facility": facility,
        if (rules != null) "rules": rules,
        if (sessionPrice != null) "session_price": sessionPrice,
        if (category != null) "category": category,
      };
}

class BookingResponse {
  final String status;
  final Booking? data;
  final List<Booking>? dataList;
  final int? count;
  final String? message;

  BookingResponse({
    required this.status,
    this.data,
    this.dataList,
    this.count,
    this.message,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) {
    // Handle data field - can be either a single Booking object or a List of Bookings
    Booking? data;
    List<Booking>? dataList;
    
    if (json["data"] != null) {
      if (json["data"] is List) {
        // data is a list
        try {
          dataList = List<Booking>.from(
            (json["data"] as List).map((x) {
              if (x is Map<String, dynamic>) {
                return Booking.fromJson(x);
              } else {
                throw Exception('Invalid booking item in list: ${x.runtimeType}');
              }
            })
          );
        } catch (e) {
          throw Exception('Error parsing booking list: $e');
        }
      } else if (json["data"] is Map<String, dynamic>) {
        // data is a single object
        try {
          data = Booking.fromJson(json["data"] as Map<String, dynamic>);
        } catch (e) {
          throw Exception('Error parsing booking object: $e');
        }
      }
    }
    
    return BookingResponse(
      status: json["status"] ?? 'error',
      data: data,
      dataList: dataList,
      count: json["count"],
      message: json["message"],
    );
  }
}

List<Booking> bookingListFromJson(String str) =>
    List<Booking>.from(json.decode(str)["data"].map((x) => Booking.fromJson(x)));

String bookingListToJson(List<Booking> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

