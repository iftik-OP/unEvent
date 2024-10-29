import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:unevent/classes/event.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/user_service.dart';

class EventCard extends StatefulWidget {
  final Event event;
  const EventCard({required this.event});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  final UserService _userService = UserService();
  User? owner;

  @override
  void initState() {
    super.initState();
    _fetchOwner();
  }

  Future<void> _fetchOwner() async {
    if (widget.event.eventOwner != null &&
        widget.event.eventOwner!.isNotEmpty) {
      User? fetchedOwner =
          await _userService.checkIfUserExists(widget.event.eventOwner!);
      setState(() {
        owner = fetchedOwner;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    print(currentUser!.favouriteEvents);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: widget.event.image != null
                ? widget.event.image is String
                    ? Hero(
                        tag: widget.event.id,
                        child: Image.network(
                          widget.event.image!,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child; // The image is fully loaded, display it.
                            } else {
                              return Center(
                                child: LoadingAnimationWidget.prograssiveDots(
                                    color: Color(0xffE83094), size: 30),
                              ); // Display the loading indicator while the image is being loaded.
                            }
                          },
                        ),
                      )
                    : widget.event.image is File
                        ? Image.file(
                            widget.event.image as File,
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          )
                        : Image.asset(
                            'Images/unevent logo.png',
                            fit: BoxFit.contain,
                            height: 200,
                            width: double.infinity,
                          )
                : Image.asset(
                    'Images/unevent black.png',
                    fit: BoxFit.contain,
                    height: 200,
                    width: double.infinity,
                  ),
          ),
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black, Colors.transparent, Colors.transparent],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: widget.event.title,
                      child: Text(
                        widget.event.title,
                        textAlign: TextAlign.left,
                        style:
                            Theme.of(context).textTheme.displayLarge!.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.event.location.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xffE83094).withOpacity(0.8),
                          ),
                          child: Text(
                            '${widget.event.dateTime.hour}:${widget.event.dateTime.minute} | ${widget.event.dateTime.day}',
                            style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          owner != null
              ? Positioned(
                  top: 15,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white.withOpacity(0.9),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: NetworkImage(
                            owner!.photoURL!,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          owner!.name,
                          style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          Positioned(
            right: 20,
            bottom: 20,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF41E4A9).withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white,
                )),
          ),
          currentUser.favouriteEvents.contains(widget.event.id)
              ? Positioned(
                  top: 20,
                  right: 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentUser.favouriteEvents.remove(widget.event.id);
                        UserService userService = UserService();
                        userService.updateFavouriteEvents(
                            currentUser.favouriteEvents, currentUser.id);
                        print(currentUser.favouriteEvents);
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
                  top: 20,
                  right: 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentUser.favouriteEvents.add(widget.event.id);
                        UserService userService = UserService();
                        userService.updateFavouriteEvents(
                            currentUser.favouriteEvents, currentUser.id);
                        print(currentUser.favouriteEvents);
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
