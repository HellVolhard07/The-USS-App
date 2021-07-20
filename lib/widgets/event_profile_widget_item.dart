import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/addEvent.dart';

class EventProfileWidgetItem extends StatelessWidget {
  final String orgLogo;
  final String? eventId;
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
    this.eventId,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 100.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.blueAccent,
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(eventPosterUrl),
          ),
          title: Text(
            eventTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          subtitle: Text(
            "${eventDate!.toDate().day}/${eventDate!.toDate().month}/${eventDate!.toDate().year} \n$eventVenue",
          ),
          isThreeLine: true,
          trailing: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEventScreen(),
                  settings: RouteSettings(
                    arguments: EventProfileWidgetItem(
                      orgLogo: orgLogo,
                      eventPosterUrl: eventPosterUrl,
                      aboutEvent: aboutEvent,
                      eventStartTime: eventStartTime,
                      eventDate: eventDate,
                      eventTitle: eventTitle,
                      eventVenue: eventVenue,
                      orgSocietyName: orgSocietyName,
                      eventEndTime: eventEndTime,
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
          dense: true,
        ),
      ),
    );
  }
}
