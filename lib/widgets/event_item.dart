import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../screens/event_screen.dart';
import '../utils.dart';

class EventItem extends StatelessWidget {
  final String orgLogo;
  final String? eventId;
  final String eventTitle;
  final Timestamp eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;
  final String eventPosterUrl;
  final String orgSocietyName;

  EventItem({
    required this.orgLogo,
    required this.eventPosterUrl,
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
    SharedAxisTransitionType? _transitionType =
        SharedAxisTransitionType.horizontal;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => EventScreen(),
            settings: RouteSettings(
              arguments: EventItem(
                orgLogo: orgLogo,
                orgSocietyName: orgSocietyName,
                eventPosterUrl: eventPosterUrl,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              children: [
                Text(
                  "${eventDate.toDate().day}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffD59B78),
                  ),
                ),
                Text(
                  "${DateFormat("MMMM").format(eventDate.toDate()).substring(0, 3)}, ${eventDate.toDate().year}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10, left: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Color(0xff232323),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              height: 90,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            eventTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xffD59B78),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "$eventStartTime - $eventEndTime",
                          style: TextStyle(
                            color: Color(0xff686868),
                            fontSize: 11.0,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () {
                                Utils.openLink(link: eventVenue);
                              },
                              child: Text(
                                eventVenue,
                                style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontSize: 10.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        eventPosterUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
