import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  void changeTheme(bool dark) {
    themeMode = dark ? ThemeMode.light : ThemeMode.dark;
    // print("dark theme $dark");
    notifyListeners();
  }
}

class ThemeBuilder {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xff181818),
    fontFamily: "Poppins",
    colorScheme: ColorScheme.dark(
      primary: Color(0xffffd8b1),
      secondary: Color(0xffD59B78),
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xfffff0e1),
    fontFamily: "Poppins",
    colorScheme: ColorScheme.light(
      primary: Color(0xffffd8b1),
      secondary: Color(0xffD59B78),
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF222831),
    ),
  );
}
