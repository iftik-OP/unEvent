import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unevent/classes/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', user.toJson());
    prefs.setBool('loggedIn', true);
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(userJson);
      notifyListeners();
    }
  }
}
