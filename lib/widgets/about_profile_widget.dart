import 'package:flutter/material.dart';

import '../theme_provider.dart';
import 'auth.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({
    Key? key,
    required this.themeProvider,
  }) : super(key: key);

  final ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'About',
            style: TextStyle(
                // color: Colors.white,
                color:
                    themeProvider.isDarkTheme ? Colors.white : Colors.black,
                fontWeight: FontWeight.w900,
                fontSize: 43),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            loggedInSoceityAbout,
            style: TextStyle(
                // color: Colors.white,
                color:
                    themeProvider.isDarkTheme ? Colors.white : Colors.black,
                fontSize: 18),
          ),
        ],
      ),
    );
  }
}
