class User {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? profilePicture;
  final bool isSuperuser;
  final bool isStaff;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.profilePicture,
    this.isSuperuser = false,
    this.isStaff = false,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePicture: json['profile_picture'],
      isSuperuser: json['is_superuser'] ?? false,
      isStaff: json['is_staff'] ?? false,
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'profile_picture': profilePicture,
      'is_superuser': isSuperuser,
      'is_staff': isStaff,
    };
  }

  String get fullName{
    if(firstName != null && lastName != null){
      return '$firstName $lastName';
    }
    return username;
  }
}