import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/addEvent.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/about_profile_widget.dart';
import 'package:the_uss_project/widgets/auth.dart';
import 'package:the_uss_project/widgets/event_profile_widget.dart';

List<Widget> profileWidgets = [
  AboutWidget(),
  EventWidget(),
];

Widget finalWidget = AboutWidget();

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // print(loggedInSocietyName);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
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
                    loggedInSocietyName,
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
                        setState(() {
                          finalWidget = profileWidgets[index];
                        });
                      },
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      unSelectedTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                      selectedBackgroundColors: themeProvider.isDarkTheme
                          ? kDarkThemeSelectedToggleColors
                          : kLightThemeSelectedToggleColors,
                      unSelectedBackgroundColors: themeProvider.isDarkTheme
                          ? kDarkThemeUnselectedToggleColors
                          : kLightThemeUnselectedToggleColors,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: finalWidget,
                  )
                ],
              ),
              Positioned(
                left: 260,
                bottom: 570,
                child: GestureDetector(
                  onTap: () async {
                    loginProvider.logOutUser(context);
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage(
                        'https://d2qp0siotla746.cloudfront.net/img/use-cases/profile-picture/template_3.jpg',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: Add animation here, if needed.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(),
            ),
          );
        },
        elevation: 20,
        backgroundColor: Colors.greenAccent,
        focusColor: Colors.greenAccent,
        splashColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 38,
        ),
      ),
    );
  }
}
