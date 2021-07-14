import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/show_alert_dialogue.dart';

class LoginProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseAuth get getAuth => _auth;

  late String error;

  String get getError => error;

  Future loginUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = "User not found";
        showMyDialog(context, error);
      } else if (e.code == 'wrong-password') {
        error = "Incorrect password";
        showMyDialog(context, error);
      }
    }
  }
}
