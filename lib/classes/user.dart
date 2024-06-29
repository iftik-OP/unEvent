import 'dart:convert';

class User {
  final String name;
  final String id;
  final String? email;
  final String? fcmToken;

  User({
    required this.name,
    required this.id,
    this.fcmToken,
    this.email,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(id: map['id'], name: map['name'], email: map['email']);
  }

  String toJson() {
    return jsonEncode(
        {'id': id, 'name': name, 'fcmToken': fcmToken, 'email': email});
  }

  static User fromJson(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return User(
        name: jsonData['name'],
        id: jsonData['id'],
        email: jsonData['email'],
        fcmToken: jsonData['fcmToken']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'fcmToken': fcmToken, 'email': email};
  }
}
