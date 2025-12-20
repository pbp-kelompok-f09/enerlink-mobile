import 'dart:convert';

class Venue {
  final String idVenue;
  final String name;
  final double rating;
  final String description;
  final String address;
  final String contactPerson;
  final List<String> facility;
  final List<dynamic> rules;
  final double sessionPrice;
  final List<String> category;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Venue({
    required this.idVenue,
    required this.name,
    required this.rating,
    required this.description,
    required this.address,
    required this.contactPerson,
    required this.facility,
    required this.rules,
    required this.sessionPrice,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        idVenue: json["id_venue"],
        name: json["name"],
        rating: (json["rating"] is int) ? json["rating"].toDouble() : json["rating"],
        description: json["description"],
        address: json["address"] ?? '',
        contactPerson: json["contact_person"],
        facility: List<String>.from(json["facility"]?.map((x) => x.toString()) ?? []),
        rules: json["rules"] ?? [],
        sessionPrice: (json["session_price"] is int) 
            ? json["session_price"].toDouble() 
            : json["session_price"],
        category: List<String>.from(json["category"]?.map((x) => x.toString()) ?? []),
        imageUrl: json["image_url"] ?? '',
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_venue": idVenue,
        "name": name,
        "rating": rating,
        "description": description,
        "address": address,
        "contact_person": contactPerson,
        "facility": facility,
        "rules": rules,
        "session_price": sessionPrice,
        "category": category,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class VenueResponse {
  final String status;
  final List<Venue>? data;
  final int? count;
  final String? message;

  VenueResponse({
    required this.status,
    this.data,
    this.count,
    this.message,
  });

  factory VenueResponse.fromJson(Map<String, dynamic> json) => VenueResponse(
        status: json["status"],
        data: json["data"] != null
            ? List<Venue>.from(json["data"].map((x) => Venue.fromJson(x)))
            : null,
        count: json["count"],
        message: json["message"],
      );
}

List<Venue> venueListFromJson(String str) =>
    List<Venue>.from(json.decode(str)["data"].map((x) => Venue.fromJson(x)));

String venueListToJson(List<Venue> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

