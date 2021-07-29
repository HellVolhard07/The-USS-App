import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';
import 'auth.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color:
              themeProvider.isDarkTheme ? Color(0xff0c0c0c) : Color(0xffffe4c9),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Text(
                  'About',
                  style: TextStyle(
                    // color: Colors.white,
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : Color(0xffcd885f),
                    fontWeight: FontWeight.w900,
                    fontSize: 36.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SingleChildScrollView(
                child: Text(
                  loggedInSoceityAbout,
                  style: TextStyle(
                    // color: Colors.white,
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : Color(0xffd1926b),
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
