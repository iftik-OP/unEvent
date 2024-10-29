import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/components/app_bar.dart';
import 'package:unevent/components/event_ticket.dart';
import 'package:unevent/providers/user_provider.dart';

import '../providers/event_provider.dart';

class Checkinspage extends StatelessWidget {
  Checkinspage({super.key});

  final Event event = Event(
      description: 'description',
      title: 'title',
      id: 'id',
      dateTime: DateTime.now(),
      location: 'location');

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final allEvents = Provider.of<EventProvider>(context).allEvents;
    return Scaffold(
      appBar: unEventAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Checked-in Events',
                style: TextStyle(
                    fontFamily: 'Akira',
                    fontSize: 20,
                    color: Color(0xffE83094)),
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: allEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                        height: 200,
                        child: Skeletonizer(
                          containersColor: Colors.grey.withOpacity(0.3),
                          child: EventTicket(event: event),
                        ));
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Center(
                      child: Text('Error loading events'),
                    );
                  } else {
                    List<Event> events =
                        List.from(snapshot.data!); // Create a copy
                    events.removeWhere((event) =>
                        !event.checkedins.contains(currentUser!.email));
                    if (events.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'Images/no-checkins.png',
                              height: 300,
                              opacity: const AlwaysStoppedAnimation(0.4),
                            ),
                            const Text('No Check-ins'),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 200,
                            child: EventTicket(event: events[index]),
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
