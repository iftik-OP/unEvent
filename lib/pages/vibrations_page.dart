import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/components/event_card.dart';
import 'package:unevent/pages/create_event_page.dart';
import 'package:unevent/pages/event_details_page.dart';
import 'package:unevent/providers/event_provider.dart';

class VibrationPage extends StatefulWidget {
  const VibrationPage({super.key});

  @override
  State<VibrationPage> createState() => _VibrationPageState();
}

class _VibrationPageState extends State<VibrationPage> {
  late Future<List<Event>>? _events;

  // void initState() {
  //   super.initState();
  //   _events = EventServices().fetchEvents();
  // }

  Event event = Event(
      description: 'description',
      eventOwner: 'btech25079.21@bitmesra.ac.in',
      title: 'title',
      id: 'id',
      image: null,
      dateTime: DateTime.now(),
      location: 'location');
  @override
  Widget build(BuildContext context) {
    _events = Provider.of<EventProvider>(context).allEvents;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF41E4A9),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEventPage(
                    fest: 'vibrations',
                  ),
                ));
          },
          child: const FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          )),
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Image.asset('Images/unevent black.png', height: 200, width: 200),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              color: Colors.black,
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Vibration\n2025',
                  style: TextStyle(
                    fontFamily: 'Akira',
                    fontSize: 30,
                    color: Color(0xffE83094),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<Event>>(
                  future: _events,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Skeletonizer(
                              child: ListView.builder(
                        shrinkWrap: true, // Add this line
                        physics:
                            const NeverScrollableScrollPhysics(), // Add this line
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return EventCard(event: event);
                        },
                      )));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching events'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          Image.asset(
                            'Images/no_data.png',
                            height: 250,
                            opacity: AlwaysStoppedAnimation(0.4),
                          ),
                          Text('No events found'),
                        ],
                      ));
                    } else {
                      List<Event> events = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true, // Add this line
                        physics:
                            const NeverScrollableScrollPhysics(), // Add this line
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailsPage(
                                          event: events[index]),
                                    ));
                              },
                              child: EventCard(event: events[index]));
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
