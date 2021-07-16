import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:the_uss_project/widgets/show_alert_dialogue.dart';

import 'package:the_uss_project/screens/home_screen.dart';
import 'package:the_uss_project/screens/login_screen.dart';
import 'package:the_uss_project/screens/profile_screen.dart';

import '../constants.dart';

User? loggedInUser;
String loggedInSocietyName = '';

String loggedInSoceityAbout = '';
List societyEvents = [];

String loggedInSocietyLogo = '';


class LoginProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get getAuth => _auth;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String error;

  String get getError => error;

  Future loginUser(String email, String password, BuildContext context) async {
    try {
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;
      if (user!.uid.isNotEmpty) {
        loggedInUser = user;

        await getCurrentUserData();

        print('Logged in as $email');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ProfileScreen()),
            (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = "User not found";
        showMyDialog(context, error);
      } else if (e.code == 'wrong-password') {
        error = "Incorrect password";
        showMyDialog(context, error);
      }
    }
    notifyListeners();
  }

  Future logOutUser(BuildContext context) async {
    await _auth.signOut();

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false);
    notifyListeners();
    print('logout successful');
  }

  Future getCurrentUserData() async {
    try {
      final loggedInUserDetail = await _firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .get();

      loggedInSocietyName = await loggedInUserDetail.get('societyName');
      loggedInSoceityAbout = await loggedInUserDetail.get('societyAbout');
      societyEvents = await loggedInUserDetail.get('myEvents');
      loggedInSocietyLogo = await loggedInUserDetail.get('societyLogo');

      print(loggedInSocietyName);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
