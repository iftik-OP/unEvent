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
import 'package:unevent/providers/committee_provider.dart';
import 'package:unevent/providers/event_provider.dart';
import 'package:unevent/providers/user_provider.dart';

class TechFestPage extends StatefulWidget {
  const TechFestPage({super.key});

  @override
  State<TechFestPage> createState() => _TechFestPageState();
}

class _TechFestPageState extends State<TechFestPage> {
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
    final currentUser = Provider.of<UserProvider>(context).user;
    _events = Provider.of<EventProvider>(context).allEvents;
    final _membersFuture = Provider.of<CommitteeProvider>(context).allMembers;
    return Scaffold(
      floatingActionButton: FutureBuilder(
        future: _membersFuture,
        builder: (context, snapshot) {
          final members = snapshot.data;
          if (members!.any((member) => member.email == currentUser!.email)) {
            return FloatingActionButton(
                backgroundColor: const Color(0xFF41E4A9),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateEventPage(
                          fest: 'techfest',
                        ),
                      ));
                },
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ));
          } else {
            return const SizedBox();
          }
        },
      ),
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
                  'TechFest\n2025',
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
                      events.removeWhere((event) => event.fest != 'techfest');
                      if (events.isEmpty) {
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
                      }
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
