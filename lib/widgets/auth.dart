import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/screens/profile_screen.dart';

String loggedInUserId = '';

class LoginProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get getAuth => _auth;

  Future loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Logged in as $email');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
