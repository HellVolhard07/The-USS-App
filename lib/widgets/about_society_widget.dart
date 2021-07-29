import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/widgets/society_item.dart';

import '../theme_provider.dart';

class AboutSocietyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;
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
                    fontWeight: FontWeight.w500,
                    fontSize: 36.0,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              SingleChildScrollView(
                child: Text(
                  societyArgs.societyAbout,
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
