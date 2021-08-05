import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: mediaQuery.width * 0.05,
            vertical: mediaQuery.width * 0.05,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: mediaQuery.width * 0.035,
                  ),
                  Text(
                    'Hello',
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white70
                          : Colors.black,
                      // : Color(0xffcd885f),
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    loggedInSocietyName,
                    style: TextStyle(
                      color: themeProvider.isDarkTheme
                          ? Colors.white
                          // : Colors.black,
                          : Color(0xffc57545),
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    color: Color(0xffD59B78),
                  ),
                  SizedBox(
                    height: mediaQuery.width * 0.05,
                  ),
                  Center(
                    child: FlutterToggleTab(
                      borderRadius: 15,
                      width: mediaQuery.width * 0.1725,
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
                    height: mediaQuery.width * 0.07,
                  ),
                  Expanded(
                    child: finalWidget,
                  )
                ],
              ),
              Positioned(
                left: mediaQuery.width * 0.65,
                top: mediaQuery.width * 0.035,
                child: GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext ctx) => AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: Text("$loggedInSocietyName"),
                        content: Text("Are you sure you want to logout!!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              loginProvider.logOutUser(context);
                              Navigator.of(ctx).pop(true);
                            },
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Color(0xffffa265)
                                    : Color(0xffcd885f),
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage("$loggedInSocietyLogo"),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: mediaQuery.width * 0.06),
        child: FloatingActionButton(
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
          backgroundColor:
              themeProvider.isDarkTheme ? Color(0xffffa265) : Color(0xffe09d7a),
          splashColor: Colors.blueAccent,
          child: Icon(
            Icons.add,
            color: themeProvider.isDarkTheme ? Colors.black : Color(0xfffff0e1),
            size: 38,
          ),
        ),
      ),
    );
  }
}
