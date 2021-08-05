import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:the_uss_project/screens/home_screen.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: new HomeScreen(),
      title: new Text(
        'GeeksForGeeks',
        textScaleFactor: 2,
      ),
      image: new Image.network(
          'https://www.geeksforgeeks.org/wp-content/uploads/gfg_200X200.png'),
      loadingText: Text("Loading"),
      photoSize: 100.0,
      loaderColor: Colors.blue,
    );
  }
}
