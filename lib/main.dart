import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/home_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';
import 'package:the_uss_project/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'The USS App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          darkTheme: ThemeBuilder.darkTheme,
          theme: ThemeBuilder.lightTheme,
          initialRoute: homeScreen,
          routes: {
            homeScreen: (_) => HomeScreen(),
            eventsScreen: (_) => EventsScreen(),
            societyListScreen: (_) => SocietyListScreen(),
          },
        );
      },
    );
  }
}
