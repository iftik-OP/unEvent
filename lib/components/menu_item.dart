import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuItem extends StatelessWidget {
  IconData leadingIcon;
  String title;
  MenuItem({required this.leadingIcon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FaIcon(
            leadingIcon,
            color: const Color(0xffE83094),
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const FaIcon(
            FontAwesomeIcons.arrowRight,
            color: Color(0xFF41E4A9),
          )
        ],
      ),
    );
  }
}
