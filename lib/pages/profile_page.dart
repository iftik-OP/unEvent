import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:provider/provider.dart';
import 'package:unevent/components/menu_item.dart';
import 'package:unevent/pages/check-ins_page.dart';
import 'package:unevent/pages/created_events_page.dart';
import 'package:unevent/pages/favourite_events_page.dart';
import 'package:unevent/pages/landingPage.dart';
import 'package:unevent/pages/technical_committee.dart';
import 'package:unevent/providers/committee_provider.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FA.User? user = FA.FirebaseAuth.instance.currentUser;
  UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    Provider.of<CommitteeProvider>(context).loadMembers();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 16, left: 16, top: 30, bottom: 20),
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
                            radius: 50,
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  user!.email!.endsWith('@bitmesra.ac.in')
                                      ? Image.asset(
                                          'Images/bit_logo_red.png',
                                          height: 23,
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              currentUser!.designation != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              26, 255, 193, 7),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Text(
                                        currentUser.designation!,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber),
                                      ),
                                    )
                                  : const SizedBox()
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      MenuItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Checkinspage(),
                                ));
                          },
                          leadingIcon: FontAwesomeIcons.ticket,
                          title: 'Your Check-ins'),
                      const Divider(
                        endIndent: 2,
                      ),
                      MenuItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CreatedEventsPage(),
                                ));
                          },
                          leadingIcon: FontAwesomeIcons.calendarDays,
                          title: 'Created Events'),
                      const Divider(
                        endIndent: 2,
                      ),
                      MenuItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const FavouriteEventsPage(),
                                ));
                          },
                          leadingIcon: FontAwesomeIcons.solidHeart,
                          title: 'Favourites'),
                      const Divider(
                        endIndent: 2,
                      ),
                      MenuItem(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TechnicalCommittee(),
                                ));
                          },
                          leadingIcon: FontAwesomeIcons.robot,
                          title: 'Technical Committee'),
                      const Divider(
                        endIndent: 2,
                      ),
                      MenuItem(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: "Coming Soon",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Color(0xffE83094),
                                textColor: Colors.white,
                                fontSize: 12.0);
                          },
                          leadingIcon: FontAwesomeIcons.music,
                          title: 'Cultural Committee'),
                      const Divider(
                        endIndent: 2,
                      ),
                      MenuItem(
                          onTap: () {},
                          leadingIcon: FontAwesomeIcons.info,
                          title: 'About Us'),
                      const SizedBox(
                        height: 60,
                      ),
                      TextButton(
                        onPressed: () {
                          userService.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const landingPage()),
                            (Route<dynamic> route) => route.isFirst,
                          );
                        },
                        child: const Text(
                          'Sign Out',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Color(0xFF41E4A9),
                              fontWeight: FontWeight.w900,
                              fontSize: 15),
                        ),
                      ),
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
        ),
      ),
    );
  }
}
