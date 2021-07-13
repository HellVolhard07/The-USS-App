import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/home_screen.dart';
import 'package:the_uss_project/screens/profile_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider())
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'The USS App',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          darkTheme: ThemeBuilder.darkTheme,
          theme: ThemeBuilder.lightTheme,
          initialRoute: profileScreen,
          routes: {
            homeScreen: (_) => HomeScreen(),
            eventsScreen: (_) => EventsScreen(),
            societyListScreen: (_) => SocietyListScreen(),
            profileScreen: (_) => ProfileScreen(),
          },
        );
      },
    );
  }
}
