import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The USS App',
      debugShowCheckedModeBanner: false,
      initialRoute: societyListScreen,
      routes: {
        societyListScreen: (_) => SocietyListScreen(),
      },
    );
  }
}
