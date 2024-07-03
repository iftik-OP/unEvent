import 'package:flutter/material.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/services/event_services.dart';

class EventProvider extends ChangeNotifier {
  late Future<List<Event>>? _allEvents;
  late Future<List<Event>>? _favouriteEvents;
  late Future<List<Event>>? _createdEvents;
  Future<List<Event>>? get allEvents => _allEvents;
  Future<List<Event>>? get createdEvents => _createdEvents;
  Future<List<Event>>? get favouriteEvents => _favouriteEvents;

  Future<void> loadEvents() async {
    _allEvents = EventServices().fetchEvents();
    _favouriteEvents = _allEvents;
    _createdEvents = _allEvents;
  }
}
