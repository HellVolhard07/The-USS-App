import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/event_item.dart';
import 'package:animations/animations.dart';

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
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                  child: Text(
                    'Upcoming Events',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                ),
                Divider(
                  indent: 20,
                  // endIndent: 20,
                  thickness: 3.0,
                  color: Colors.deepPurpleAccent,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (ctx, index) => EventItem(
                    boxColor: index % 2 == 0
                        ? Colors.orangeAccent
                        : Colors.pinkAccent,
                    eventId: eventsData[index].id,
                    aboutEvent: eventsData[index][aboutEvent],
                    eventDate: eventsData[index][date],
                    eventStartTime: eventsData[index][startTime],
                    eventTitle: eventsData[index][title],
                    eventVenue: eventsData[index][venue],
                    eventEndTime: eventsData[index][endTime],
                  ),
                  itemCount: eventsData.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
