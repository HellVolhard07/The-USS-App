import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/addEvent.dart';
import 'package:the_uss_project/screens/events_screen.dart';
import 'package:the_uss_project/screens/home_screen.dart';
import 'package:the_uss_project/screens/profile_screen.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  flutterLocalNotificationsPlugin.show(
    message.notification.hashCode,
    message.notification!.title,
    message.notification!.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channel.description,
        playSound: true,

        priority: Priority.max,
        icon: "@mipmap/ic_launcher",
        // other properties...
      ),
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.requestPermission(
    sound: true,
    badge: true,
    alert: true,
    announcement: true,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
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
            profileScreen: (_) => ProfileScreen(),
            addEventScreen: (_) => AddEventScreen(),
          },
        );
      },
    );
  }
}
