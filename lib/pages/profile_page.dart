import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:unevent/components/menu_item.dart';
import 'package:unevent/pages/landingPage.dart';
import 'package:unevent/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 30, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.photoURL!),
                        radius: 70,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Hi\n',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xffE83094),
                                  ),
                                ),
                                TextSpan(
                                  text: user!.displayName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                userService.signOut();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const landingPage()),
                                  (Route<dynamic> route) => route.isFirst,
                                );
                              },
                              child: const Text(
                                'Sign Out',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Color(0xFF41E4A9),
                                    fontWeight: FontWeight.w500),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  MenuItem(
                      leadingIcon: FontAwesomeIcons.ticket,
                      title: 'Your Tickets'),
                  const Divider(
                    endIndent: 2,
                  ),
                  MenuItem(
                      leadingIcon: FontAwesomeIcons.airbnb,
                      title: 'Your Profile'),
                  const Divider(
                    endIndent: 2,
                  )
                ],
              ),
              Text(
                'Made with ❤️ by Iftikhar',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffE83094).withOpacity(0.2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
