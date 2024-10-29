import 'package:flutter/material.dart';

AppBar unEventAppBar() {
  return AppBar(
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
  );
}
