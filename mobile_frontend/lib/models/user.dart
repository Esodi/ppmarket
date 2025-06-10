class User {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;

  User({required this.id, required this.email, this.firstName, this.lastName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}
