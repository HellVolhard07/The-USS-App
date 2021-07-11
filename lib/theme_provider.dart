import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  void changeTheme(bool dark) {
    themeMode = dark ? ThemeMode.light : ThemeMode.dark;
    // print("dark theme $dark");
    notifyListeners();
  }
}

class ThemeBuilder {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF222831),
    fontFamily: "Poppins",
    primaryColor: Colors.orangeAccent,
    colorScheme: ColorScheme.dark(
      primary: Colors.orangeAccent,
      secondary: Colors.pinkAccent,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
  static final lightTheme = ThemeData(
    fontFamily: "Poppins",
    colorScheme: ColorScheme.light(
      primary: Colors.orangeAccent,
      secondary: Colors.pinkAccent,
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF222831),
    ),
  );
}
