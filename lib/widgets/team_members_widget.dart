import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/society_item.dart';
import 'auth.dart';
import 'package:the_uss_project/utils.dart';

class TeamMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
              ),
              Text(
                'Team Members',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 28,
                    color: themeProvider.isDarkTheme
                        ? Colors.white70
                        : Colors.black),
              ),
            ],
          ),
          Divider(
            endIndent: 20,
            indent: 20,
            thickness: 3,
            color: Colors.deepPurpleAccent,
          ),
          SizedBox(
            height: 20,
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
          // GridView.count(
          //   physics: ScrollPhysics(),
          //   shrinkWrap: true,
          //   crossAxisCount: 3,
          //   children: [
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //     MemberCircle(),
          //   ],
          // ),
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
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // print(societyArgs.societyTeam.length);
            // print(societyArgs.societyTeam);
            Utils.openEmail(
                toEmail: societyArgs.societyTeam[index]['contact'],
                subject: 'Query regarding ${societyArgs.societyName}',
                body: 'Sent using the USS app');
          },
          child: CircleAvatar(
            radius: 32,
            backgroundColor: Colors.greenAccent,
            child: Text(
              societyArgs.societyTeam[index]['name'][0],
              style: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          societyArgs.societyTeam[index]['name'],
          style: TextStyle(
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
        )
      ],
    );
  }
}
