import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/event_profile_widget_item.dart';

import 'auth.dart';

class EventWidget extends StatefulWidget {
  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    loggedInSocietyEvents.sort((e1, e2) => e2["date"].compareTo(e1["date"]));
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        // color: themeProvider.isDarkTheme
        //     ? Colors.deepPurpleAccent.withOpacity(0.1)
        //     : Colors.greenAccent.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: loggedInSocietyEvents.length,
        itemBuilder: (context, index) {
          return EventProfileWidgetItem(
              orgLogo: loggedInSocietyEvents[index][societyLogo],
              orgSocietyName: loggedInSocietyEvents[index][societyName],
              eventPosterUrl: loggedInSocietyEvents[index]['poster'],
              eventId: loggedInSocietyEvents[index]['eventId'],
              aboutEvent: loggedInSocietyEvents[index]['aboutEvent'],
              eventDate: loggedInSocietyEvents[index]['date'],
              eventStartTime: loggedInSocietyEvents[index]['startTime'],
              eventEndTime: loggedInSocietyEvents[index]['endTime'],
              eventTitle: loggedInSocietyEvents[index]['title'],
              eventVenue: loggedInSocietyEvents[index]['venue']);
        },
      ),
    );
  }
}
