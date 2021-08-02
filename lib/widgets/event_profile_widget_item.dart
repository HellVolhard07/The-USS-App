import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/screens/updateEventScreen.dart';

import '../theme_provider.dart';

class EventProfileWidgetItem extends StatelessWidget {
  final String orgLogo;
  final String eventId;
  final String eventTitle;
  final Timestamp? eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;
  final String eventPosterUrl;
  final String orgSocietyName;

  EventProfileWidgetItem({
    required this.orgLogo,
    required this.eventPosterUrl,
    required this.eventId,
    required this.aboutEvent,
    this.eventDate,
    this.eventEndTime,
    required this.eventStartTime,
    required this.eventTitle,
    required this.eventVenue,
    required this.orgSocietyName,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: mediaQuery.width * 0.02,
      ),
      child: Container(
        height: mediaQuery.width * 0.25,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color:
              themeProvider.isDarkTheme ? Color(0xff232323) : Color(0xffffd8b1),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(eventPosterUrl),
          ),
          title: Text(
            eventTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: themeProvider.isDarkTheme
                  ? Color(0xffd59b78)
                  : Color(0xffcd885f),
            ),
          ),
          subtitle: Text(
            "${eventDate!.toDate().day}/${eventDate!.toDate().month}/${eventDate!.toDate().year}",
            style: TextStyle(
              fontSize: 12.0,
              color:
                  themeProvider.isDarkTheme ? Colors.white : Color(0xffd1926b),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateEventScreen(
                    eventTitle: eventTitle,
                    eventVenue: eventVenue,
                    eventDate: eventDate!.toDate(),
                    eventStartTime: eventStartTime,
                    eventDesc: aboutEvent,
                    eventID: eventId,
                    eventPoster: eventPosterUrl,
                    eventEndTime: eventEndTime,
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.edit_outlined,
              color:
                  themeProvider.isDarkTheme ? Colors.white : Color(0xffcd885f),
            ),
          ),
          dense: true,
        ),
      ),
    );
  }
}
