import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/event_item.dart';

import '../constants.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(eventsCollection)
            .orderBy("date", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var eventsData = snapshot.data.docs;
          // print(eventsData[0].id);
          // print(snapshot.data.docs[0]["title"]);
          return ListView.builder(
            itemBuilder: (ctx, index) => EventItem(
              boxColor:
                  index % 2 == 0 ? Colors.orangeAccent : Colors.pinkAccent,
              eventId: eventsData[index].id,
              aboutEvent: eventsData[index][aboutEvent],
              eventDate: eventsData[index][date],
              eventStartTime: eventsData[index][startTime],
              eventTitle: eventsData[index][title],
              eventVenue: eventsData[index][venue],
              eventEndTime: eventsData[index][endTime],
            ),
            itemCount: eventsData.length,
          );
        },
      ),
    );
  }
}
