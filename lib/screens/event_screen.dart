import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/event_item.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final eventArgs = ModalRoute.of(context)!.settings.arguments as EventItem;
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
                    color: Color(0xff232323),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 10,
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
                                padding: const EdgeInsets.all(10.0),
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
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.person_add_alt_1_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Society: ${eventArgs.orgSocietyName}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.maps_ugc_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      eventArgs.eventVenue,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 15),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${eventArgs.eventDate.toDate().day}/${eventArgs.eventDate.toDate().month}/${eventArgs.eventDate.toDate().year}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          "${eventArgs.eventStartTime} - ${eventArgs.eventEndTime}",
                                          style: TextStyle(
                                            color: Colors.white60,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              "About",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              eventArgs.aboutEvent,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
