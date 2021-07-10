import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/society_item.dart';

class SocietyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(societiesCollection)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var societiesData = snapshot.data.docs;
          return ListView.builder(
            itemBuilder: (ctx, index) => SocietyItem(
              myColor: index % 2 == 0 ? Colors.blueAccent : Colors.redAccent,
              societyName: societiesData[index][societyName],
              societyLogo: societiesData[index][societyLogo],
            ),
            itemCount: societiesData.length,
          );
        },
      ),
    );
  }
}
