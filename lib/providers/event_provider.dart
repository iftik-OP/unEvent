import 'package:flutter/material.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/services/event_services.dart';

class EventProvider extends ChangeNotifier {
  late Future<List<Event>>? _allEvents;
  Future<List<Event>>? get allEvents => _allEvents;

  Future<void> loadEvents() async {
    _allEvents = EventServices().fetchEvents();
  }
}
