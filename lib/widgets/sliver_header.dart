import 'package:flutter/material.dart';

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
        tag: url,
        transitionOnUserGestures: true,
        child: Material(
          type: MaterialType.transparency,
          child: Image.network(
            url,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      title: Hero(
        tag: title,
        // transitionOnUserGestures: true,
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.blueGrey.withOpacity(0.7),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: title.length >= 15 ? 15 : 20,
              ),
            ),
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
