class AdminDashboardStats {
  final int totalUsers;
  final int totalVenues;
  final int totalCommunities;
  final int totalEvents;
  final int totalBookings; // <--- Tambahan Baru
  final String generatedAt;
  final List<VenueItem> recentVenues;
  final List<CommunityItem> activeCommunities;

  AdminDashboardStats({
    required this.totalUsers,
    required this.totalVenues,
    required this.totalCommunities,
    required this.totalEvents,
    required this.totalBookings, // <--- Tambahan Baru
    required this.generatedAt,
    required this.recentVenues,
    required this.activeCommunities,
  });

  factory AdminDashboardStats.fromJson(Map<String, dynamic> json) {
    return AdminDashboardStats(
      totalUsers: json['totalUsers'] ?? 0,
      totalVenues: json['totalVenues'] ?? 0,
      totalCommunities: json['totalCommunities'] ?? 0,
      totalEvents: json['totalEvents'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0, // <--- Ambil dari JSON Django
      generatedAt: json['generatedAt'] ?? "",
      recentVenues: json['recentVenues'] != null
          ? (json['recentVenues'] as List).map((i) => VenueItem.fromJson(i)).toList()
          : [],
      activeCommunities: json['activeCommunities'] != null
          ? (json['activeCommunities'] as List).map((i) => CommunityItem.fromJson(i)).toList()
          : [],
    );
  }
}

class VenueItem {
  final String name;
  final String category;
  final String address;
  final String price;
  final double rating;
  final String imageUrl;

  VenueItem({
    required this.name,
    required this.category,
    required this.address,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  factory VenueItem.fromJson(Map<String, dynamic> json) {
    return VenueItem(
      name: json['name'] ?? "",
      category: json['category'] ?? "",
      address: json['address'] ?? "",
      price: json['price'] ?? "0",
      rating: (json['rating'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? "",
    );
  }
}

class CommunityItem {
  final String title;
  final String city;
  final String sportCategory;
  final String thumbnail;

  CommunityItem({
    required this.title,
    required this.city,
    required this.sportCategory,
    required this.thumbnail,
  });

  factory CommunityItem.fromJson(Map<String, dynamic> json) {
    return CommunityItem(
      title: json['title'] ?? "",
      city: json['city'] ?? "",
      sportCategory: json['sport_category'] ?? "",
      thumbnail: json['thumbnail'] ?? "",
    );
  }
}