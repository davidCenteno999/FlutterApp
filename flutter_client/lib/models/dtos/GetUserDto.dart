class GetUser{
  final String username;
  final String email;
  final String role;

  GetUser({required this.username, required this.email, required this.role});

  factory GetUser.fromJson(Map<String, dynamic> json) {
    return GetUser(
      username: json['username'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
    };
  }
}