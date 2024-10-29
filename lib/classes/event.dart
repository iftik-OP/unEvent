import 'dart:io';

class Event {
  String title;
  String id;
  dynamic image;
  String? eventOwner; // event owner email
  String description;
  DateTime dateTime;
  String location;
  String? fest;
  List<String> participants;
  List<String> checkedins;

  Event({
    required this.description,
    required this.title,
    required this.id,
    this.image,
    this.eventOwner,
    this.fest,
    required this.dateTime,
    required this.location,
    List<String>? participants,
    List<String>? checkedins,
  })  : participants = participants ?? [],
        checkedins = checkedins ?? [];

  // Convert an Event object into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'image': image is File
          ? null
          : image, // Assuming `image` is a URL if it's not a File
      'eventOwner': eventOwner,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'fest': fest,
      'participants': participants,
      'checkedins': checkedins,
    };
  }

  // Convert a JSON map into an Event object.
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'],
      id: json['id'],
      image: json['image'],
      eventOwner: json['eventOwner'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      location: json['location'],
      fest: json['fest'],
      participants: (json['participants'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
      checkedins: (json['checkedins'] as List<dynamic>)
          .map((item) => item.toString())
          .toList(),
    );
  }

  // Convert an Event object into a Map.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'image': image is File
          ? null
          : image, // Assuming `image` is a URL if it's not a File
      'eventOwner': eventOwner,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'location': location,
      'fest': fest,
      'participants': participants,
      'checkedins': checkedins,
    };
  }

  // Convert a Map into an Event object.
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'],
      id: map['id'],
      image: map['image'],
      eventOwner: map['eventOwner'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      location: map['location'],
      fest: map['fest'],
      participants: (map['participants'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      checkedins: (map['checkedins'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
    );
  }
}
