import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:unevent/components/event_card.dart';

class VibrationPage extends StatefulWidget {
  const VibrationPage({super.key});

  @override
  State<VibrationPage> createState() => _VibrationPageState();
}

class _VibrationPageState extends State<VibrationPage> {
  @override
  Widget build(BuildContext context) {
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
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Vibration\n2025',
                  style: TextStyle(
                    fontFamily: 'Akira',
                    fontSize: 30,
                    color: Color(0xffE83094),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                EventCard(),
                EventCard(),
                EventCard(),
                EventCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
