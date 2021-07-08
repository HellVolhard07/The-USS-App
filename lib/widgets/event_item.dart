import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String eventTitle;
  final String eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;

  EventItem({
    required this.aboutEvent,
    required this.eventDate,
    this.eventEndTime,
    required this.eventStartTime,
    required this.eventTitle,
    required this.eventVenue,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        eventTitle,
      ),
    );
  }
}
