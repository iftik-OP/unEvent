import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/components/event_card.dart';
import 'package:unevent/providers/event_provider.dart';
import 'package:unevent/providers/user_provider.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({super.key});

  @override
  State<CreatedEventsPage> createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  @override
  Widget build(BuildContext context) {
    final allEvents = Provider.of<EventProvider>(context).allEvents;
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Created Events',
                style: TextStyle(
                    fontFamily: 'Akira',
                    fontSize: 20,
                    color: Color(0xffE83094)),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Event>>(
                future: allEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Skeletonizer(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return EventCard(
                                event: Event(
                              description: 'description',
                              eventOwner: 'btech25079.21@bitmesra.ac.in',
                              title: 'title',
                              id: 'id',
                              image: null,
                              dateTime: DateTime.now(),
                              location: 'location',
                            ));
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching events'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Column(
                      children: [
                        Image.asset(
                          'Images/empty_data.png',
                          height: 250,
                          opacity: AlwaysStoppedAnimation(0.4),
                        ),
                        const Text('No created events'),
                      ],
                    ));
                  } else {
                    List<Event> events =
                        List.from(snapshot.data!); // Create a copy
                    events.removeWhere((event) =>
                        !currentUser!.createdEvents.contains(event.id));
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        return EventCard(event: events[index]);
                      },
                    );
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
