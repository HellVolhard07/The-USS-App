import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';

class HomeScreen extends StatelessWidget {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> screens() {
    return [
      EventsScreen(),
      SocietyListScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.event),
        title: 'Events',
        activeColorPrimary: Colors.deepPurpleAccent,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.people),
        title: 'Events',
        activeColorPrimary: Colors.deepPurpleAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: screens(),
      items: navBarItems(),
      navBarHeight: 65,  //TODO: make it dynamic
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
