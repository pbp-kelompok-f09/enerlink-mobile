class AdminUser {
  final int id;
  final String username;
  final String name;
  final String email;
  final String role;
  final String wallet;
  final String description;
  final String profilePicture; // <--- Field Baru

  AdminUser({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    required this.wallet,
    required this.description,
    required this.profilePicture, // <--- Masuk Constructor
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      wallet: json['wallet'],
      description: json['description'] ?? "",
      // Ambil dari JSON, kalau null kasih string kosong ""
      profilePicture: json['profile_picture'] ?? "", 
    );
  }
}