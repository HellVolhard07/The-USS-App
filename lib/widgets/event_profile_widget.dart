import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/event_profile_widget_item.dart';

class EventWidget extends StatefulWidget {
  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List convertToDate(List event) {
    event.forEach((element) {
      element[date].toDate();
    });

    event.sort((e1, e2) => e2[date].compareTo(e1[date]));

    return event;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: StreamBuilder<dynamic>(
          stream: _firestore
              .collection(societiesCollection)
              .doc(_auth.currentUser?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var loggedInDatas = snapshot.data.get('myEvents');
              loggedInDatas = convertToDate(loggedInDatas);
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: loggedInDatas.length,
                itemBuilder: (context, index) {
                  return EventProfileWidgetItem(
                      orgLogo: loggedInDatas[index][societyLogo],
                      orgSocietyName: loggedInDatas[index][societyName],
                      eventPosterUrl: loggedInDatas[index]['poster'],
                      eventId: loggedInDatas[index]['eventId'],
                      aboutEvent: loggedInDatas[index]['aboutEvent'],
                      eventDate: loggedInDatas[index]['date'],
                      eventStartTime: loggedInDatas[index]['startTime'],
                      eventEndTime: loggedInDatas[index]['endTime'],
                      eventTitle: loggedInDatas[index]['title'],
                      eventVenue: loggedInDatas[index]['venue']);
                },
              );
            }
          }),
    );
  }
}
