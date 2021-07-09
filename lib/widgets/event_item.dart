import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screens/event_screen.dart';

class EventItem extends StatelessWidget {
  final String eventId;
  final String eventTitle;
  final String eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;

  EventItem({
    required this.eventId,
    required this.aboutEvent,
    required this.eventDate,
    this.eventEndTime,
    required this.eventStartTime,
    required this.eventTitle,
    required this.eventVenue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => EventScreen(),
            settings: RouteSettings(
              arguments: EventItem(
                eventId: eventId,
                aboutEvent: aboutEvent,
                eventDate: eventDate,
                eventStartTime: eventStartTime,
                eventTitle: eventTitle,
                eventVenue: eventVenue,
                eventEndTime: eventEndTime,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withOpacity(0.4),
              border: Border(
                left: BorderSide(
                  color: Colors.pinkAccent,
                  width: 7,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eventTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
