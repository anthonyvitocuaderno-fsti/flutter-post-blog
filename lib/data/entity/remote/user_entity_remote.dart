class UserEntityRemote {
  final String id;
  final String name;
  final String email;

  UserEntityRemote({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserEntityRemote.fromJson(Map<String, dynamic> json) {
    return UserEntityRemote(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
