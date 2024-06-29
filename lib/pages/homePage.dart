import 'package:flutter/material.dart';
import 'package:unevent/pages/home.dart';
import 'package:unevent/pages/profile_page.dart';
import 'package:unevent/services/user_service.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  UserService userService = UserService();
  int _selectedPageIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    Center(child: Text('Bookings')),
    home(),
    ProfilePage()
  ];

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
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPageIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
