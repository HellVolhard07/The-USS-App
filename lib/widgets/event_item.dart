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
  final String eventPosterUrl;

  EventItem({
    required this.eventPosterUrl,
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
                eventPosterUrl: eventPosterUrl,
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
                transitionType: _transitionType,
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
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: boxColor,
              border: Border(
                left: BorderSide(
                  color: boxColor,
                  width: 7,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: eventTitle,
                          child: Text(
                            eventTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
                      Expanded(
                        child: Text(
                          eventVenue,
                          style: TextStyle(
                            backgroundColor: Colors.black12,
                          ),
                          overflow: TextOverflow.ellipsis,
                          // style: TextStyle(
                          //   color: Colors.grey,
                          // ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: eventPosterUrl,
                      child: Material(
                        type: MaterialType.transparency,
                        child: Image.network(
                          eventPosterUrl,
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: 100,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
