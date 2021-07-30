import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/auth.dart';
import 'package:the_uss_project/widgets/event_item.dart';

class EventsScreen extends StatefulWidget {
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    getCurrentUserData();
    super.initState();
  }

  Future getCurrentUserData() async {
    try {
      final loggedInUserDetail = await _firestore
          .collection(societiesCollection)
          .doc(_auth.currentUser!.uid)
          .get();

      loggedInSocietyName = await loggedInUserDetail.get('societyName');
      loggedInSoceityAbout = await loggedInUserDetail.get('societyAbout');
      loggedInSocietyEvents = await loggedInUserDetail.get('myEvents');
      teamMembers = await loggedInUserDetail.get('teamMembers');
      loggedInSocietyLogo = await loggedInUserDetail.get('societyLogo');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Widget eventsWidget(List eventsData) {
    if (eventsData.length == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'No upcoming events to display, Enjoy the day!',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) => EventItem(
        orgLogo: eventsData[index][societyLogo],
        orgSocietyName: eventsData[index][societyName],
        eventPosterUrl: eventsData[index][posterURL],
        eventId: eventsData[index].id,
        aboutEvent: eventsData[index][aboutEvent],
        eventDate: eventsData[index][date],
        eventStartTime: eventsData[index][startTime],
        eventTitle: eventsData[index][title],
        eventVenue: eventsData[index][venue],
        eventEndTime: eventsData[index][endTime],
      ),
      itemCount: eventsData.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(eventsCollection)
            .where("date", isGreaterThanOrEqualTo: DateTime.now())
            .orderBy("date", descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var eventsData = snapshot.data.docs;
          return SafeArea(
            child: SizedBox(
              height: mediaQuery.height,
              child: Stack(
                children: [
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                          child: IconButton(
                            icon: themeProvider.isDarkTheme
                                ? Icon(
                                    Icons.wb_sunny_outlined,
                                    color: Color(0xffD59B78),
                                  )
                                : Icon(
                                    Icons.nights_stay_rounded,
                                    color: Color(0xffcd885f),
                                  ),
                            onPressed: () {
                              themeProvider
                                  .changeTheme(themeProvider.isDarkTheme);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                          child: Text(
                            "${DateFormat("d").format(DateTime.now())} ${DateFormat("MMMM").format(DateTime.now())}, ${DateFormat("EEEE").format(DateTime.now())} ",
                            style: TextStyle(
                              fontSize: 20,
                              color: themeProvider.isDarkTheme
                                  ? Color(0xffD59B78)
                                  : Color(0xffcd885f),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: mediaQuery.height * 0.12,
                        bottom: 0,
                      ),
                      width: mediaQuery.width * 0.85,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: themeProvider.isDarkTheme
                            ? Color(0xff0c0c0c)
                            : Color(0xffffe4c9),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(39),
                          topRight: Radius.circular(39),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30.0, 25, 20, 10),
                              child: Text(
                                'Upcoming Events',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Color(0xffd1926b),
                                ),
                              ),
                            ),
                            Divider(
                              indent: 30,
                              endIndent: 30,
                              thickness: 2.0,
                              color: Color(0xffD59B78),
                            ),
                            eventsWidget(eventsData),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
