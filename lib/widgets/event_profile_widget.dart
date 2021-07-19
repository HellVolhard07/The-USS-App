import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/constants.dart';
import 'auth.dart';
import 'event_item.dart';

class EventWidget extends StatefulWidget {
  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        // color: themeProvider.isDarkTheme
        //     ? Colors.deepPurpleAccent.withOpacity(0.1)
        //     : Colors.greenAccent.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: StreamBuilder<Object>(
          stream: _firestore.collection(societiesCollection).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.lightBlue,
                ),
              );
            }
            return ListView.builder(
      itemCount: societyEvents.length,
      itemBuilder: (context, index) {
        return EventItem(
            orgLogo: societyEvents[index][societyLogo],
            orgSocietyName: societyEvents[index][societyName],
            eventPosterUrl: societyEvents[index]['poster'],
            boxColor: index % 2 == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            eventId: societyEvents[index]['eventId'],
            aboutEvent: societyEvents[index]['aboutEvent'],
            eventDate: societyEvents[index]['date'],
            eventStartTime: societyEvents[index]['startTime'],
            eventEndTime: societyEvents[index]['endTime'],
            eventTitle: societyEvents[index]['title'],
            eventVenue: societyEvents[index]['venue']);
      },
            );
          }),
  }
}