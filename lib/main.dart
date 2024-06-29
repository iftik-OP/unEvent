import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unevent/pages/homePage.dart';
import 'package:unevent/pages/landingPage.dart';
import 'package:unevent/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'unEvent',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE83094)),
          fontFamily: GoogleFonts.poppins().fontFamily,
          useMaterial3: true,
        ),
        home: Builder(
          builder: (context) {
            return FutureBuilder(
              future: _isUserSignedin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.data == true) {
                  return const homePage();
                } else {
                  return const landingPage();
                }
              },
            );
          },
        ),
      ),
    );
  }
}

Future<bool> _isUserSignedin() async {
  final prefs = await SharedPreferences.getInstance();
  bool? loggedIn = prefs.getBool('loggedIn') ?? false;
  return loggedIn;
}
