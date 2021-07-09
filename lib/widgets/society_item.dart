import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocietyItem extends StatelessWidget {
  final String societyName;
  final String societyLogo;
  final Color myColor;

  SocietyItem({
    required this.societyName,
    required this.societyLogo,
    required this.myColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.all(40.0),
          width: double.infinity,
          height: 120.0,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 7.0,
                color: myColor,
              ),
            ),
            color: myColor.withOpacity(0.5),
          ),
          child: Row(
            children: [
              //Image.network(societyLogo),
              Text(societyName),
            ],
          ),
        ),
      ),
    );
  }
}
