class UserModel {
  final int id;
  final String name;
  final String email;
  final int level;
  final DateTime? emailVerifiedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.level,
    this.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      level: json['level'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
    );
  }
}