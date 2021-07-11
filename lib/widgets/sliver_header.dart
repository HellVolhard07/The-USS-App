import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';

SliverAppBar sliverHeader(
  String title,
  String url,
) {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.transparent,
    shape: ContinuousRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(50),
        bottomRight: Radius.circular(50),
      ),
    ),
    expandedHeight: 200.0,
    flexibleSpace: FlexibleSpaceBar(
      background: Hero(
        tag: title,
        child: Image.network(
          url,
          fit: BoxFit.fitHeight,
        ),
      ),
      title: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.blueGrey.withOpacity(0.7),
        ),
        child: Text(
          title,
          textAlign: TextAlign.justify,
          style: TextStyle(
            color: Colors.black,
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
