import 'dart:convert';

class Community {
  final String model;
  final String pk;
  final CommunityFields fields;

  Community({required this.model, required this.pk, required this.fields});

  factory Community.fromJson(Map<String, dynamic> json) => Community(
    model: json["model"],
    pk: json["pk"],
    fields: CommunityFields.fromJson(json["fields"]),
  );

  Map<String, dynamic> toJson() => {
    "model": model,
    "pk": pk,
    "fields": fields.toJson(),
  };
}

class CommunityFields {
  final String title;
  final String description;
  final String? announcement;
  final String sportCategory;
  final String adminCommunityName;
  final String? adminCommunityProfilePicture;
  final int? maxMembers;
  final String city;
  final String? coverUrls;
  final String? thumbnail;
  final int totalMembers;
  final int totalActivity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  CommunityFields({
    required this.title,
    required this.description,
    this.announcement,
    required this.sportCategory,
    required this.adminCommunityName,
    this.adminCommunityProfilePicture,
    this.maxMembers,
    required this.city,
    this.coverUrls,
    this.thumbnail,
    required this.totalMembers,
    required this.totalActivity,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory CommunityFields.fromJson(Map<String, dynamic> json) {
    const String defaultProfilePicture =
        'https://res.cloudinary.com/dwnuf9cop/image/upload/v1701386453/media/noProfile.jpg';

    return CommunityFields(
      title: json["title"],
      description: json["description"],
      announcement: json["announcement"],
      sportCategory: json["sport_category"],
      adminCommunityName: json["admin_community_name"],
      adminCommunityProfilePicture:
          json["admin_community_profile_picture"] ?? defaultProfilePicture,
      maxMembers: json["max_members"],
      city: json["city"],
      coverUrls: json["cover_urls"],
      thumbnail: json["thumbnail"],
      totalMembers: json["total_members"],
      totalActivity: json["total_activity"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      isActive: json["is_active"],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "announcement": announcement,
    "sport_category": sportCategory,
    "admin_community_name": adminCommunityName,
    "admin_community_profile_picture": adminCommunityProfilePicture,
    "max_members": maxMembers,
    "city": city,
    "cover_urls": coverUrls,
    "thumbnail": thumbnail,
    "total_members": totalMembers,
    "total_activity": totalActivity,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "is_active": isActive,
  };
}

List<Community> communityFromJson(String str) =>
    List<Community>.from(json.decode(str).map((x) => Community.fromJson(x)));

String communityToJson(List<Community> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
