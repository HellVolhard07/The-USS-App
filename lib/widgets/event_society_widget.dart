import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/society_item.dart';

import '../theme_provider.dart';
import 'event_item.dart';

class EventSocietyWidget extends StatefulWidget {
  @override
  State<EventSocietyWidget> createState() => _EventSocietyWidgetState();
}

class _EventSocietyWidgetState extends State<EventSocietyWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List sortByDate(List event) {
    event.forEach((element) {
      element[date].toDate();
    });

    event.sort((e1, e2) => e2[date].compareTo(e1[date]));

    return event;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;

    sortByDate(societyArgs.societyKeEvents);
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: societyArgs.societyKeEvents.length == 0 ||
              societyArgs.societyKeEvents == null
          ? Padding(
              padding: EdgeInsets.all(mediaQuery.width * 0.05),
              child: Center(
                child: Text(
                  "No events posted yet!!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeProvider.isDarkTheme
                        ? Color(0xffD59B78)
                        : Color(0xffcd885f),
                  ),
                ),
              ),
            )
          : ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: societyArgs.societyKeEvents.length,
              itemBuilder: (context, index) {
                return EventItem(
                  orgLogo: societyArgs.societyKeEvents[index][societyLogo],
                  orgSocietyName: societyArgs.societyKeEvents[index]
                      [societyName],
                  eventPosterUrl: societyArgs.societyKeEvents[index]['poster'],
                  eventId: societyArgs.societyKeEvents[index]['eventId'],
                  aboutEvent: societyArgs.societyKeEvents[index]['aboutEvent'],
                  eventDate: societyArgs.societyKeEvents[index]['date'],
                  eventStartTime: societyArgs.societyKeEvents[index]
                      ['startTime'],
                  eventEndTime: societyArgs.societyKeEvents[index]['endTime'],
                  eventTitle: societyArgs.societyKeEvents[index]['title'],
                  eventVenue: societyArgs.societyKeEvents[index]['venue'],
                  online: societyArgs.societyKeEvents[index][onlineEvent],
                  registeration: societyArgs.societyKeEvents[index]
                      [registerationRequired],
                );
              },
            ),
    );
  }
}
