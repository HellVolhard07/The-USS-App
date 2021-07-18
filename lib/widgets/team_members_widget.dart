import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'auth.dart';

class TeamMembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                style: TextStyle(fontSize: 28, color: Colors.white70),
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
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.greenAccent,
                    child: Icon(
                      Icons.person,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Member",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
