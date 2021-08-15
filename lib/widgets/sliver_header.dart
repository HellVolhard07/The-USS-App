import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../theme_provider.dart';

SliverAppBar sliverHeader(
  BuildContext context,
  String title,
  String url,
) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final mediaQuery = MediaQuery.of(context).size;

  return SliverAppBar(
    // automaticallyImplyLeading: false,
    leading: CircleAvatar(
      radius: 20.0,
      backgroundColor:
          themeProvider.isDarkTheme ? Color(0xff232323) : Color(0xffffe4c9),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back),
        color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
      ),
    ),
    backgroundColor: Colors.transparent,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    expandedHeight: mediaQuery.height * 0.27,
    flexibleSpace: FlexibleSpaceBar(
      stretchModes: <StretchMode>[
        StretchMode.zoomBackground,
        StretchMode.fadeTitle,
      ],
      background: Image.network(
        url,
        fit: BoxFit.fitHeight,
      ),
      title: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mediaQuery.width * 0.02,
          vertical: mediaQuery.height * 0.003,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: themeProvider.isDarkTheme
              ? Color(0xFF232323).withOpacity(0.8)
              : Color(0xffcd885f),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.25,
            fontSize: title.length >= 15 ? 15 : 20,
          ),
        ),
      ),
      centerTitle: true,
    ),
    floating: true,
    pinned: true,
    stretch: true,
  );
}
