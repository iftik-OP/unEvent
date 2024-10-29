import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/components/unEventLoading.dart';
import 'package:unevent/pages/qr_scanner.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/event_services.dart';
import 'package:unevent/services/user_service.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  User? owner;

  @override
  void initState() {
    super.initState();
    _fetchOwner();
  }

  Future<void> _fetchOwner() async {
    UserService _userService = UserService();
    if (widget.event.eventOwner != null &&
        widget.event.eventOwner!.isNotEmpty) {
      User? fetchedOwner =
          await _userService.checkIfUserExists(widget.event.eventOwner!);
      setState(() {
        owner = fetchedOwner;
      });
    }
  }

  final months = [
    'Janueary',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  Future<void> rsvpUser(User currentUser) async {
    unEventLoading.showLoadingDialog(context);
    widget.event.participants.add(currentUser.email!);
    currentUser.participatedEvents.add(widget.event.id);
    UserService userService = UserService();

    EventServices eventService = EventServices();
    await eventService.updateEventParticipants(widget.event);
    await userService.updateParticiaptedEvents(
        currentUser.participatedEvents, currentUser.id);
    unEventLoading.hideLoadingDialog(context);
  }

  Future<void> withdrawUser(User currentUser) async {
    widget.event.participants.remove(currentUser.email);
    currentUser.participatedEvents.remove(widget.event.id);
    UserService userService = UserService();

    EventServices eventService = EventServices();
    await eventService.updateEventParticipants(widget.event);
    await userService.updateParticiaptedEvents(
        currentUser.participatedEvents, currentUser.id);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 32),
        child: SizedBox(
          width: double.infinity,
          child: widget.event.eventOwner == currentUser!.email
              ? FloatingActionButton.extended(
                  isExtended: true,
                  backgroundColor: const Color(0xFF41E4A9),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScanQRCode(
                            event: widget.event,
                          ),
                        ));
                  },
                  label: const Text(
                    'Check-in User',
                    style: TextStyle(fontFamily: 'Akira', color: Colors.white),
                  ),
                )
              : widget.event.participants.contains(currentUser!.email)
                  ? FloatingActionButton.extended(
                      isExtended: true,
                      backgroundColor: Colors.redAccent,
                      onPressed: () async {
                        withdrawUser(currentUser);
                        setState(() {});
                      },
                      label: const Text(
                        'Withdraw',
                        style:
                            TextStyle(fontFamily: 'Akira', color: Colors.white),
                      ),
                    )
                  : FloatingActionButton.extended(
                      isExtended: true,
                      backgroundColor: const Color(0xFF41E4A9),
                      onPressed: () async {
                        await rsvpUser(currentUser);
                        setState(() {});
                      },
                      label: const Text(
                        'RSVP',
                        style:
                            TextStyle(fontFamily: 'Akira', color: Colors.white),
                      ),
                    ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Hero(
              tag: widget.event.id,
              child: Image.network(
                widget.event.image,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
              )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.3 - 30),
            height: 500,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Hero(
                    tag: widget.event.title,
                    child: Text(
                      widget.event.title,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Color(0xffE83094),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(
                    endIndent: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Text(
                    '${days[widget.event.dateTime.weekday - 1]}\n${months[widget.event.dateTime.month - 1]} ${widget.event.dateTime.day}, ${widget.event.dateTime.year}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.4)),
                  ),
                  Divider(
                    endIndent: MediaQuery.of(context).size.height * 0.1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Event Description',
                    style: TextStyle(fontFamily: 'Akira', fontSize: 16),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.event.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  owner != null
                      ? const Text(
                          'Event Coordinator',
                          style: TextStyle(fontFamily: 'Akira', fontSize: 12),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 20,
                  ),
                  owner != null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  owner!.photoURL!,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                owner!.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          currentUser!.favouriteEvents.contains(widget.event.id)
              ? Positioned(
                  top: 50,
                  right: 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentUser.favouriteEvents.remove(widget.event.id);
                        UserService userService = UserService();
                        userService.updateFavouriteEvents(
                            currentUser.favouriteEvents, currentUser.id);
                      });
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.red,
                      size: 25,
                    ),
                  ),
                )
              : Positioned(
                  top: 50,
                  right: 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentUser.favouriteEvents.add(widget.event.id);
                        UserService userService = UserService();
                        userService.updateFavouriteEvents(
                            currentUser.favouriteEvents, currentUser.id);
                      });
                    },
                    child: const FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
