import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FA;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unevent/classes/user.dart';
import 'package:unevent/providers/user_provider.dart';

class UserService {
  final _auth = FA.FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('user');

  Future<FA.UserCredential> signInWithGoogle() async {
    // Trigger the Google Sign In process
    final googleUser = await _googleSignIn.signIn();

    // Obtain the GoogleSignInAuthentication object
    final googleAuth = await googleUser!.authentication;

    // Create a new credential
    final credential = FA.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google Auth credential
    return await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', false);
  }

  Future<User?> checkIfUserExists(String email) async {
    try {
      QuerySnapshot snapshot =
          await _collection.where('email', isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> userData =
            snapshot.docs.first.data() as Map<String, dynamic>;
        return User.fromMap(userData);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get user by email: $e');
    }
  }

  Future<void> createData(
      Map<String, dynamic> data, BuildContext context) async {
    try {
      DocumentReference docRef = await _collection.add(data);
      String id = docRef.id;
      docRef.update({'id': id});
      Provider.of<UserProvider>(context, listen: false)
          .saveUser(User(id: id, name: data['name']));
    } catch (e) {
      throw Exception('Failed to create data: $e');
    }
  }
}
