class AdminCommunity {
  final String id;
  final String title;
  final String sportCategory;
  final String city;
  final int memberCount;
  final String status;
  final String thumbnail;

  AdminCommunity({
    required this.id,
    required this.title,
    required this.sportCategory,
    required this.city,
    required this.memberCount,
    required this.status,
    required this.thumbnail,
  });

  factory AdminCommunity.fromJson(Map<String, dynamic> json) {
    return AdminCommunity(
      id: json['id'],
      title: json['title'] ?? "Unknown",
      sportCategory: json['sport_category'] ?? "-",
      city: json['city'] ?? "-",
      memberCount: json['member_count'] ?? 0,
      status: json['status'] ?? "Active",
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}