import 'package:animated_background/animated_background.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:unevent/pages/homePage.dart';
import 'package:unevent/providers/user_provider.dart';
import 'package:unevent/services/user_service.dart';

class landingPage extends StatefulWidget {
  const landingPage({super.key});

  @override
  State<landingPage> createState() => _landingPageState();
}

class _landingPageState extends State<landingPage>
    with TickerProviderStateMixin {
  UserService userService = UserService();

  ParticleOptions particles = const ParticleOptions(
    baseColor: Color(0xffE83094),
    spawnOpacity: 0.0,
    opacityChangeRate: 0.25,
    minOpacity: 0.05,
    maxOpacity: 0.1,
    particleCount: 8,
    spawnMaxRadius: 150.0,
    spawnMaxSpeed: 5.0,
    spawnMinSpeed: 1.0,
    spawnMinRadius: 100.0,
  );

  void signInAsBitian() async {
    final FA.UserCredential userCredential =
        await userService.signInWithGoogle();
    if (userCredential.user!.email != null) {
      if (userCredential.user!.email!.endsWith('@bitmesra.ac.in')) {
        // The email is valid
        final user =
            await userService.checkIfUserExists(userCredential.user!.email!);
        if (user == null) {
          await userService.createData({
            'name': userCredential.user!.displayName,
            'email': userCredential.user!.email
          }, context);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => homePage(),
              ));
        } else {
          Provider.of<UserProvider>(context, listen: false).saveUser(user);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const homePage(),
              ));
        }
        // Provider.of<UserProvider>(context).saveUser(user);
        Fluttertoast.showToast(
                msg: "Sign in successful",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 12.0)
            .then((value) => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const homePage())));
      } else {
        // The email is not from the specified domain
        await userService.signOut();
        Fluttertoast.showToast(
            msg: "Please sign in with your BIT Mesra email ID",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 12.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: particles),
          child: Column(
            children: [
              Image.asset(
                'Images/unevent black.png',
                height: 300,
                width: 300,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'The ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Official\n',
                        style: TextStyle(
                          color: Color(0xFF41E4A9),
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Event Management App of ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'BIT',
                        style: TextStyle(
                          color: Color(0xFFE83094),
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Mesra',
                        style: TextStyle(
                          color: Color(0xFFE83094),
                          fontSize: 29,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                'Login',
                style: TextStyle(fontFamily: 'Akira', fontSize: 30),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  signInAsBitian();
                },
                child: Container(
                  width: 300,
                  height: 54,
                  decoration: ShapeDecoration(
                    color: const Color(0x66F4F4F4),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 0.25, color: Color(0xFFE83094)),
                      borderRadius: BorderRadius.circular(37),
                    ),
                  ),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'Images/bit_logo.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Sign in as BITian',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 300,
                height: 54,
                decoration: ShapeDecoration(
                  color: const Color(0x66F4F4F4),
                  shape: RoundedRectangleBorder(
                    side:
                        const BorderSide(width: 0.25, color: Color(0xFFE83094)),
                    borderRadius: BorderRadius.circular(37),
                  ),
                ),
                child: const Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.google),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
