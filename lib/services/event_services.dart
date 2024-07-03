import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/classes/user.dart';

class EventServices {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('events');
  Future<String?> createEvent(Event event) async {
    final data = event.toMap();

    try {
      DocumentReference docRef = await _collection.add(data);
      String id = docRef.id;
      docRef.update({'id': id});
      return id;
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }

  Future<void> updateEventParticipants(Event event) async {
    try {
      DocumentReference doc = await _collection.doc(event.id);
      doc.update({'participants': event.participants});
    } catch (e) {
      print('Error updating data: ${e}');
    }
  }

  Future<List<Event>> fetchEvents() async {
    List<Event> events = [];
    try {
      QuerySnapshot snapshot = await _collection.get();
      for (var doc in snapshot.docs) {
        events.add(Event.fromMap(doc.data() as Map<String, dynamic>));
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
    return events;
  }
}
