import 'dart:convert';

class User {
  final String name;
  String id;
  final String? photoURL;
  final String? email;
  final String? fcmToken;
  List<String> favouriteEvents;
  List<String> createdEvents;
  List<String> participatedEvents;

  User({
    required this.name,
    required this.id,
    this.fcmToken,
    this.email,
    this.photoURL,
    List<String>? favouriteEvents,
    List<String>? createdEvents,
    List<String>? participatedEvents,
  })  : favouriteEvents = favouriteEvents ?? [],
        createdEvents = createdEvents ?? [],
        participatedEvents = participatedEvents ?? [];

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photoURL: map['photoURL'],
      favouriteEvents: (map['favouriteEvents'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      createdEvents: (map['createdEvents'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      participatedEvents: (map['participatedEvents'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'fcmToken': fcmToken,
      'email': email,
      'photoURL': photoURL,
      'favouriteEvents': favouriteEvents,
      'createdEvents': createdEvents,
      'participatedEvents': participatedEvents,
    });
  }

  static User fromJson(String jsonString) {
    final jsonData = jsonDecode(jsonString);
    return User(
      name: jsonData['name'],
      id: jsonData['id'],
      email: jsonData['email'],
      fcmToken: jsonData['fcmToken'],
      photoURL: jsonData['photoURL'],
      favouriteEvents: (jsonData['favouriteEvents'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      createdEvents: (jsonData['createdEvents'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      participatedEvents: (jsonData['participatedEvents'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fcmToken': fcmToken,
      'email': email,
      'photoURL': photoURL,
      'favouriteEvents': favouriteEvents,
      'createdEvents': createdEvents,
      'participatedEvents': participatedEvents,
    };
  }
}
