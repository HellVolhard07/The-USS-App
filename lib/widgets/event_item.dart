import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../screens/event_screen.dart';
import '../theme_provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;

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
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : Color(0xffD59B78),
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
                color: themeProvider.isDarkTheme
                    ? Color(0xff232323)
                    : Color(0xffffd8b1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              height: mediaQuery.height * 0.15,
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
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffD59B78)
                                  : Color(0xffcd885f),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "$eventStartTime - $eventEndTime",
                          style: TextStyle(
                            color: themeProvider.isDarkTheme
                                ? Color(0xff686868)
                                : Color(0xffc57545),
                            fontSize: 11.0,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Expanded(
                          child: SizedBox(
                            width: mediaQuery.width * 0.15,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shadowColor: MaterialStateProperty.all<Color>(
                                  themeProvider.isDarkTheme
                                      ? Color(0xffFFD8B1)
                                      : Colors.black,
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  themeProvider.isDarkTheme
                                      ? Color(0xffffa265)
                                      : Color(0xffFFD8B1),
                                ),
                              ),
                              onPressed: () {
                                Utils.openLink(link: eventVenue);
                              },
                              child: Text(
                                "Join",
                                style: TextStyle(
                                  color: themeProvider.isDarkTheme
                                      ? Colors.black
                                      : Color(0xffd1926b),
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.bold,
                                ),
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

// Expanded(
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 5),
// child: GestureDetector(
// onTap: () {
// Utils.openLink(link: eventVenue);
// },
// child: Text(
// eventVenue,
// style: TextStyle(
// color: themeProvider.isDarkTheme
// ? Colors.white
//     : Color(0xffd1926b),
// decoration: TextDecoration.underline,
// fontSize: 10.0),
// overflow: TextOverflow.ellipsis,
// ),
// ),
// ),
// ),
