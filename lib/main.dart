import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/home_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The USS App',
      debugShowCheckedModeBanner: false,
      initialRoute: homeScreen,
      routes: {
        homeScreen: (_) => HomeScreen(),
        eventsScreen: (_) => EventsScreen(),
        societyListScreen: (_) => SocietyListScreen(),
      },
    );
  }
}
