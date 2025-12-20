import 'dart:convert';

class Event {
  final String model;
  final String pk;
  final EventFields fields;

  Event({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        model: json["model"],
        pk: json["pk"],
        fields: EventFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class EventFields {
  final int idCommunity;
  final String title;
  final String description;
  final DateTime playingDate;
  final String location;
  final int fee;
  final int maxParticipants;
  final String status;
  final String color;
  final DateTime createdAt;
  final DateTime updatedAt;

  EventFields({
    required this.idCommunity,
    required this.title,
    required this.description,
    required this.playingDate,
    required this.location,
    required this.fee,
    required this.maxParticipants,
    required this.status,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EventFields.fromJson(Map<String, dynamic> json) => EventFields(
        idCommunity: json["id_community"],
        title: json["title"],
        description: json["description"],
        playingDate: DateTime.parse(json["playing_date"]),
        location: json["location"],
        fee: json["fee"],
        maxParticipants: json["max_participants"],
        status: json["status"],
        color: json["color"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id_community": idCommunity,
        "title": title,
        "description": description,
        "playing_date": "${playingDate.year.toString().padLeft(4, '0')}-${playingDate.month.toString().padLeft(2, '0')}-${playingDate.day.toString().padLeft(2, '0')}",
        "location": location,
        "fee": fee,
        "max_participants": maxParticipants,
        "status": status,
        "color": color,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

List<Event> eventFromJson(String str) =>
    List<Event>.from(json.decode(str).map((x) => Event.fromJson(x)));

String eventToJson(List<Event> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
