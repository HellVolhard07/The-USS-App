import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/society_item.dart';

import '../theme_provider.dart';
import 'auth.dart';

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
          color: themeProvider.isDarkTheme
              ? Colors.deepPurpleAccent.withOpacity(0.1)
              : Colors.greenAccent.withOpacity(0.4),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Text(
                'About',
                style: TextStyle(
                    // color: Colors.white,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 43),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              child: Text(
                societyArgs.societyAbout,
                style: TextStyle(
                    // color: Colors.white,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
