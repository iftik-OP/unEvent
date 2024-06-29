import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6),
      child: Stack(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            'Images/Tech Fest.jpg',
            fit: BoxFit.cover,
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
          child: const Padding(
            padding: EdgeInsets.only(bottom: 20, left: 20),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Title",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Akira'),
                  ),
                  Text(
                    'Seminar Hall',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffE83094).withOpacity(0.8),
            ),
            child: const Text(
              '01:00 PM | 28 Jan',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF41E4A9).withOpacity(0.8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.arrowRight,
                color: Colors.white,
                size: 25,
              )),
        ),
        Positioned(
          top: 20,
          right: 25,
          child: const FaIcon(
            FontAwesomeIcons.solidHeart,
            color: Colors.white,
            size: 25,
          ),
        ),
      ]),
    );
  }
}
