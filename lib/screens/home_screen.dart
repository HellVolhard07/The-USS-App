import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.event),
        title: 'Events',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        activeColorPrimary:
            isDarkTheme ? Color(0xffffa265) : Colors.deepPurpleAccent,
        activeColorSecondary: isDarkTheme ? Colors.black : Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people),
        title: 'Societies',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        activeColorPrimary:
            isDarkTheme ? Color(0xffffa265) : Colors.deepPurpleAccent,
        activeColorSecondary: isDarkTheme ? Colors.black : Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle_outlined),
        title: 'Account',
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        activeColorPrimary:
            isDarkTheme ? Color(0xffffa265) : Colors.deepPurpleAccent,
        activeColorSecondary: isDarkTheme ? Colors.black : Colors.white,
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
      navBarStyle: NavBarStyle.style7,
      controller: _controller,
      screens: screens(),
      items: navBarItems(),
      navBarHeight: 75,
      backgroundColor: isDarkTheme ? Color(0xff030303) : Colors.green,
      decoration: NavBarDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0xff181818),
          ),
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
    );
  }
}
