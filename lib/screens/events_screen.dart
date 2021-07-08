import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';

class EventsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(eventsCollection)
            .orderBy("date", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var eventsData = snapshot.data.docs;
          // print(snapshot.data.docs[0]["title"]);
          return ListView.builder(
            itemBuilder: (ctx, index) => Center(
              child: Text(
                eventsData[index]["title"],
              ),
            ),
            itemCount: eventsData.length,
          );
        },
      ),
    );
  }
}
