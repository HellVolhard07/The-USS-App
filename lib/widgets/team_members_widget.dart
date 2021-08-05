import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/utils.dart';
import 'package:the_uss_project/widgets/society_item.dart';

class TeamMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: mediaQuery.width * 0.065,
              ),
              Text(
                'Team Members',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 28,
                  color: themeProvider.isDarkTheme
                      ? Colors.white
                      : Color(0xffcd885f),
                ),
              ),
            ],
          ),
          Divider(
            endIndent: mediaQuery.width * 0.065,
            indent: mediaQuery.width * 0.065,
            thickness: 2,
            color: themeProvider.isDarkTheme
                ? Color(0xffd59b78)
                : Color(0xffcd885f),
          ),
          SizedBox(
            height: mediaQuery.height * 0.025,
          ),
          GridView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: societyArgs.societyTeam.length,
            itemBuilder: (context, index) {
              return MemberCircle(index);
            },
          ),
        ],
      ),
    );
  }
}

class MemberCircle extends StatelessWidget {
  final int index;

  MemberCircle(@required this.index);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;

    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Utils.openEmail(
                toEmail: societyArgs.societyTeam[index]['contact'],
                subject: 'Query regarding ${societyArgs.societyName}',
                body: 'Sent using the USS app');
          },
          child: CircleAvatar(
            radius: mediaQuery.width * 0.08,
            backgroundColor: themeProvider.isDarkTheme
                ? Color(0xffd59b78)
                : Color(0xffffe4c9),
            child: Text(
              societyArgs.societyTeam[index]['name'][0],
              style: TextStyle(
                fontSize: 32,
                color: themeProvider.isDarkTheme
                    ? Colors.black
                    : Color(0xffcd885f),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.height * 0.01),
        Text(
          societyArgs.societyTeam[index]['name'],
          style: TextStyle(
            color: themeProvider.isDarkTheme ? Colors.white : Color(0xffcd885f),
          ),
        )
      ],
    );
  }
}
