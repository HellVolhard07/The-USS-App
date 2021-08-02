import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/screens/addEvent.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/event_item.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final eventArgs = ModalRoute.of(context)!.settings.arguments as EventItem;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Image.network(
              eventArgs.eventPosterUrl,
              fit: BoxFit.cover,
            ),
            height: mediaQuery.height * 0.4,
            width: double.infinity,
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              minChildSize: 0.6,
              maxChildSize: 0.9,
              initialChildSize: 0.7,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkTheme
                        ? Color(0xff232323)
                        : Color(0xffffe4c9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.width * 0.035,
                        vertical: mediaQuery.width * 0.025,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffd59b78),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                height: 3,
                                width: mediaQuery.width * 0.35,
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  mediaQuery.width * 0.025,
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(eventArgs.orgLogo),
                                  radius: mediaQuery.height * 0.1,
                                ),
                              ),
                              Text(
                                eventArgs.eventTitle,
                                style: TextStyle(
                                  color: Color(0xffd59b78),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  mediaQuery.width * 0.020,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1_outlined,
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                      width: mediaQuery.width * 0.035,
                                    ),
                                    Text(
                                      "Society: ${eventArgs.orgSocietyName}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: themeProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  mediaQuery.width * 0.020,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.maps_ugc_outlined,
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    SizedBox(width: mediaQuery.width * 0.035),
                                    Text(
                                      eventArgs.eventVenue,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: themeProvider.isDarkTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                  mediaQuery.width * 0.020,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range_outlined,
                                      color: themeProvider.isDarkTheme
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    SizedBox(
                                      width: mediaQuery.width * 0.035,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${eventArgs.eventDate.toDate().day}/${eventArgs.eventDate.toDate().month}/${eventArgs.eventDate.toDate().year}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: themeProvider.isDarkTheme
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${eventArgs.eventStartTime} - ${eventArgs.eventEndTime}",
                                          style: TextStyle(
                                            color: themeProvider.isDarkTheme
                                                ? Colors.white60
                                                : Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width * 0.025,
                              vertical: mediaQuery.width * 0.0125,
                            ),
                            child: Text(
                              "About",
                              style: TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width * 0.025,
                            ),
                            child: Text(
                              eventArgs.aboutEvent,
                              style: TextStyle(
                                color: themeProvider.isDarkTheme
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.width * 0.375,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                eventArgs.registeration
                                    ? "Register"
                                    : eventArgs.online
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
                          SizedBox(
                            height: mediaQuery.width * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
