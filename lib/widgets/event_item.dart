import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screens/event_screen.dart';

class EventItem extends StatelessWidget {
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

  EventItem({
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
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(eventPosterUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: -20,
                  top: -20,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 27.0, top: 16.0),
                      child: Text(
                        "${eventDate.toDate().day}/${eventDate.toDate().month}/${eventDate.toDate().year}",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    width: 110,
                    height: 50,
                  ),
                ),
                Positioned(
                  top: 220,
                  left: -20,
                  child: Container(
                    width: 360,
                    height: 90,
                    color: Colors.white70,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25.0,
                        vertical: 10.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventTitle,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            eventVenue,
                            style: TextStyle(
                              fontSize: 11.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
              clipBehavior: Clip.none,
            ),
          ),
        ),
      ),
    );
  }
}
/*Row(
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
fontWeight: FontWeight.w900,
fontSize: 16,
),
overflow: TextOverflow.ellipsis,
),
),
Text(
"${eventDate.toDate().day}/${eventDate.toDate().month}/${eventDate.toDate().year}",
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
],
),*/
