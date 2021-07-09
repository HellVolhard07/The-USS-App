import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screens/event_screen.dart';

class EventItem extends StatelessWidget {
  final Color boxColor;
  final String eventId;
  final String eventTitle;
  final String eventDate;
  final String? eventEndTime;
  final String eventStartTime;
  final String eventVenue;
  final String aboutEvent;

  EventItem({
    required this.boxColor,
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
    SharedAxisTransitionType? _transitionType =
        SharedAxisTransitionType.horizontal;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            reverseTransitionDuration: Duration(milliseconds: 800),
            settings: RouteSettings(
              arguments: EventItem(
                boxColor: boxColor,
                eventId: eventId,
                aboutEvent: aboutEvent,
                eventDate: eventDate,
                eventStartTime: eventStartTime,
                eventTitle: eventTitle,
                eventVenue: eventVenue,
                eventEndTime: eventEndTime,
              ),
            ),
            transitionDuration: Duration(milliseconds: 800),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                child: EventScreen(),
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: _transitionType!,
              );
            },
          ),

          // MaterialPageRoute(
          //   builder: (ctx) => EventScreen(),
          //   settings: RouteSettings(
          //     arguments: EventItem(
          //       boxColor: boxColor,
          //       eventId: eventId,
          //       aboutEvent: aboutEvent,
          //       eventDate: eventDate,
          //       eventStartTime: eventStartTime,
          //       eventTitle: eventTitle,
          //       eventVenue: eventVenue,
          //       eventEndTime: eventEndTime,
          //     ),
          //   ),
          // ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: boxColor.withOpacity(0.4),
              border: Border(
                left: BorderSide(
                  color: boxColor,
                  width: 7,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventTitle,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                Text(
                  eventDate,
                  // style: TextStyle(
                  //   color: Colors.grey,
                  // ),
                ),
                Text(
                  "$eventStartTime - $eventEndTime",
                  // style: TextStyle(
                  //   color: Colors.grey,
                  // ),
                ),
                Text(
                  eventVenue,
                  style: TextStyle(
                    backgroundColor: Colors.black12,
                  ),
                  // style: TextStyle(
                  //   color: Colors.grey,
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
