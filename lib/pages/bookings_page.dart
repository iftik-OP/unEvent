import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/components/event_ticket.dart';
import 'package:unevent/providers/event_provider.dart';
import 'package:unevent/providers/user_provider.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  Event event = Event(
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Upcoming Bookings',
                style: TextStyle(fontFamily: 'Akira', fontSize: 20),
              ),
              Text(
                'Tap the barcode for your QR',
                style: TextStyle(
                    fontFamily: 'Akira',
                    fontSize: 10,
                    color: Colors.black.withOpacity(0.5)),
              ),
              const SizedBox(
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
                        !event.participants.contains(currentUser!.email) ||
                        event.checkedins.contains(currentUser.email));
                    if (events.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'Images/no-booking.png',
                              opacity: const AlwaysStoppedAnimation(0.3),
                            ),
                            const Text('No Upcoming Bookings'),
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
