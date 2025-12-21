class AdminVenue {
  final String id;
  final String name;
  final String category;
  final String address;
  final String price;
  final double rating;
  final String imageUrl; // <--- Variable di Flutter

  AdminVenue({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  factory AdminVenue.fromJson(Map<String, dynamic> json) {
    return AdminVenue(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      address: json['address'],
      price: json['price'],
      rating: (json['rating'] as num).toDouble(),
      // MAPPING PENTING:
      // json['image_url'] (dari Django) --> masuk ke imageUrl (Flutter)
      imageUrl: json['image_url'] ?? "", 
    );
  }
}