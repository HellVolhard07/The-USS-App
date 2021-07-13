import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/sliver_header.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

String loggedInSocietyName = '';

class ProfileScreen extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  // void getLoggedInSocietyDetails() async{
  //   try{
  //   loggedInSocietyName = await _firestore.collection(societiesCollection).doc(_auth.currentUser.uid).
  //   }
  //   on FirebaseException catch (e) {
  //     print(e);
  //   }
// }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Hello',
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white70
                          : Colors.black87,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    'SocietyName',
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white
                          : Colors.deepPurpleAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.deepPurpleAccent,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: FlutterToggleTab(
                      borderRadius: 15,
                      width: 70,
                      labels: ['About', 'Events'],
                      initialIndex: 0,
                      selectedLabelIndex: (index) {
                        print('selectedIndex : $index');
                      },
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      unSelectedTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      selectedBackgroundColors: [
                        Colors.deepPurpleAccent,
                        Colors.blueAccent
                      ],
                      unSelectedBackgroundColors: [
                        Colors.lightBlueAccent,
                        Colors.greenAccent
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? Colors.deepPurpleAccent.withOpacity(0.1)
                            : Colors.lightBlue.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 43),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'This society is the best society of whole of USS',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                left: 260,
                bottom: 630,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
