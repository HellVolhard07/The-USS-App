import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventProfileWidgetItem extends StatelessWidget {
  final String orgLogo;
  final Color boxColor;
  final String? eventId;
  final String eventTitle;
  final Timestamp eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;
  final String eventPosterUrl;
  final String orgSocietyName;

  EventProfileWidgetItem({
    required this.orgLogo,
    required this.eventPosterUrl,
    required this.boxColor,
    this.eventId,
    required this.aboutEvent,
    required this.eventDate,
    this.eventEndTime,
    required this.eventStartTime,
    required this.eventTitle,
    required this.eventVenue,
    required this.orgSocietyName,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController _titleController = TextEditingController(
      text: eventTitle,
    );
    TextEditingController _descController = TextEditingController(
      text: aboutEvent,
    );
    TextEditingController _venueController = TextEditingController(
      text: eventVenue,
    );
    TextEditingController _miscController = TextEditingController();
    TextEditingController _dateEditingController = TextEditingController();
    TextEditingController _startTimeEditingController = TextEditingController(
      text: eventStartTime,
    );
    TextEditingController _endTimeEditingController = TextEditingController(
      text: eventEndTime,
    );

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
            "${eventDate.toDate().day}/${eventDate.toDate().month}/${eventDate.toDate().year} \n$eventVenue",
          ),
          isThreeLine: true,
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_outlined),
          ),
          dense: true,
        ),
      ),
    );
  }
}
