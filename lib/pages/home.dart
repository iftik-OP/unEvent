import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:unevent/pages/techfest_page.dart';
import 'package:unevent/providers/committee_provider.dart';
import 'package:unevent/providers/event_provider.dart';

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<EventProvider>(context).loadEvents();
    Provider.of<CommitteeProvider>(context).loadMembers();
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Upcoming\nFests',
                style: TextStyle(fontFamily: 'Akira', fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Fluttertoast.showToast(
                    msg: "Coming Soon",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Color(0xffE83094),
                    textColor: Colors.white,
                    fontSize: 12.0);
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Image.asset(
                      'Images/Vibrations.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    child: const Center(
                      child: Column(
                        children: [
                          Text(
                            "Vibrations'25",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Akira'),
                          ),
                          Text(
                            'Coming Soon',
                            style: TextStyle(
                                color: Color(0xffE83094),
                                fontFamily: 'Akira',
                                fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TechFestPage(),
                    ));
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Image.asset(
                      'Images/Tech Fest.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Tech Fest'25",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Akira'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   height: 300,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Color.fromARGB(20, 48, 232, 146),
            //   ),
            //   child: Column(
            //     children: [
            //       ClipRRect(
            //         borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20)),
            //         child: Image.asset(
            //           'Images/Vibrations.jpg',
            //           height: 200,
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       const Text(
            //         "Vibrations '24",
            //         style: TextStyle(fontFamily: 'Akira', fontSize: 20),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       const Text(
            //         "Coming Soon...",
            //         style: TextStyle(
            //             color: Color(0xffE83094), fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            // Container(
            //   height: 300,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: Color.fromARGB(20, 48, 232, 146),
            //   ),
            //   child: Column(
            //     children: [
            //       ClipRRect(
            //         borderRadius: const BorderRadius.only(
            //             topLeft: Radius.circular(20),
            //             topRight: Radius.circular(20)),
            //         child: Image.asset(
            //           'Images/Tech Fest.jpg',
            //           height: 200,
            //           width: double.infinity,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       const Text(
            //         "Tech Fest '24",
            //         style: TextStyle(fontFamily: 'Akira', fontSize: 20),
            //       ),
            //       const SizedBox(
            //         height: 10,
            //       ),
            //       const Text(
            //         "Coming Soon...",
            //         style: TextStyle(
            //             color: Color(0xffE83094), fontWeight: FontWeight.bold),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }
}
