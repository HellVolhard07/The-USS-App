

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:the_uss_project/screens/addEvent.dart';

import 'package:provider/provider.dart';

import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/login_screen.dart';
import 'package:the_uss_project/screens/profile_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';
import 'package:the_uss_project/widgets/auth.dart';
import '../theme_provider.dart';

class HomeScreen extends StatelessWidget {
  bool isDarkTheme = true;
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> screens() {
    return [
      EventsScreen(),
      SocietyListScreen(),
      LoginScreen(),
      AddEventScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.event),
        title: 'Events',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        activeColorPrimary:
            isDarkTheme ? Colors.white : Colors.deepPurpleAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people),
        title: 'Societies',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        activeColorPrimary:
            isDarkTheme ? Colors.white : Colors.deepPurpleAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle_outlined),
        title: 'Account',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        activeColorPrimary:
            isDarkTheme ? Colors.white : Colors.deepPurpleAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        title: 'Add Event',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        activeColorPrimary: Colors.deepPurpleAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    List<Widget> screens() {
      return [
        EventsScreen(),
        SocietyListScreen(),
        loginProvider.getAuth.currentUser == null
            ? LoginScreen()
            : ProfileScreen(),
      ];
    }

    themeProvider.isDarkTheme ? isDarkTheme = true : isDarkTheme = false;
    return PersistentTabView(
      context,
      controller: _controller,
      screens: screens(),
      items: navBarItems(),
      navBarHeight: 65,
      //TODO: make it dynamic
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // decoration: NavBarDecoration(
      //   border: Border(
      //     top: BorderSide(
      //       color: Colors.deepPurpleAccent,
      //       width: 3,
      //       style: BorderStyle.solid,
      //     ),
      //   ),
      // ),
    );
  }
}
