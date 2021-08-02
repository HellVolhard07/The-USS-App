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
  final bool online;
  final bool registeration;

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
    required this.online,
    required this.registeration,
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
                online: online,
                registeration: registeration,
              ),
            ),
          ),
        );
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: mediaQuery.width * 0.05,
            ),
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
              margin: EdgeInsets.only(
                top: mediaQuery.width * 0.025,
                bottom: mediaQuery.width * 0.025,
                left: mediaQuery.width * 0.05,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: mediaQuery.width * 0.05,
                vertical: mediaQuery.width * 0.035,
              ),
              decoration: BoxDecoration(
                color: themeProvider.isDarkTheme
                    ? Color(0xff232323)
                    : Color(0xffffd8b1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              height: mediaQuery.height * 0.13,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
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
                          height: mediaQuery.width * 0.025,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all<Color>(
                                themeProvider.isDarkTheme
                                    ? Color(0xffFFD8B1)
                                    : Colors.black,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                themeProvider.isDarkTheme
                                    ? Color(0xffffa265)
                                    : Color(0xffFFD8B1),
                              ),
                            ),
                            onPressed: !registeration && !online
                                ? () {
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
                                            online: online,
                                            registeration: registeration,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                : () {
                                    Utils.openLink(link: eventVenue);
                                  },
                            child: Text(
                              registeration
                                  ? "Register"
                                  : online
                                      ? "Join"
                                      : "View",
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
                        width: mediaQuery.width * 0.15,
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
