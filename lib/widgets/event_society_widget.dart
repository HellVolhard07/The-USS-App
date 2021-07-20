import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/society_item.dart';

import 'auth.dart';
import 'event_item.dart';

class EventSocietyWidget extends StatefulWidget {
  @override
  State<EventSocietyWidget> createState() => _EventSocietyWidgetState();
}

class _EventSocietyWidgetState extends State<EventSocietyWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        // color: themeProvider.isDarkTheme
        //     ? Colors.deepPurpleAccent.withOpacity(0.1)
        //     : Colors.greenAccent.withOpacity(0.4),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: societyArgs.societyKeEvents.length,
        itemBuilder: (context, index) {
          return EventItem(
              orgLogo: societyArgs.societyKeEvents[index][societyLogo],
              orgSocietyName: societyArgs.societyKeEvents[index][societyName],
              eventPosterUrl: societyArgs.societyKeEvents[index]['poster'],
              eventId: societyArgs.societyKeEvents[index]['eventId'],
              aboutEvent: societyArgs.societyKeEvents[index]['aboutEvent'],
              eventDate: societyArgs.societyKeEvents[index]['date'],
              eventStartTime: societyArgs.societyKeEvents[index]['startTime'],
              eventEndTime: societyArgs.societyKeEvents[index]['endTime'],
              eventTitle: societyArgs.societyKeEvents[index]['title'],
              eventVenue: societyArgs.societyKeEvents[index]['venue']);
        },
      ),
    );
  }
}
