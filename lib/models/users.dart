class UserModel {
  final int id;
  final String username;
  final String email;
  final String nohp;
  final String password;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.nohp,
    required this.password,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      nohp: json['nohp'] ?? '',
      password: json['password'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'nohp': nohp,
      'password': password,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
