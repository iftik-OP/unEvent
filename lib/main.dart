import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unevent/pages/homePage.dart';
import 'package:unevent/pages/landingPage.dart';
import 'package:unevent/providers/committee_provider.dart';
import 'package:unevent/providers/event_provider.dart';
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
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => CommitteeProvider())
      ],
      child: MaterialApp(
        title: 'unEvent',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffE83094)),
          fontFamily: GoogleFonts.poppins().fontFamily,
          textTheme: TextTheme(displayLarge: TextStyle(fontFamily: 'Akira')),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser != null
            ? const homePage()
            : const landingPage(),
      ),
    );
  }
}
