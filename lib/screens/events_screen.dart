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

      print(loggedInSocietyName);
      print(teamMembers);
      // print(loggedInSoceityAbout);
      // print('society events are : $societyEvents');
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: themeProvider.isDarkTheme
          ? Theme.of(context).scaffoldBackgroundColor
          : Color(0xFF4044c9),
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
          // print(eventsData[0].id);
          // print(snapshot.data.docs[0]["title"]);
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
                                    Icons.wb_twighlight,
                                    color: Colors.yellow,
                                  )
                                : Icon(
                                    Icons.nights_stay_rounded,
                                    color: Colors.white,
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
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: mediaQuery.height * 0.12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                            child: Text(
                              'Upcoming Events',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Divider(
                            indent: 20,
                            endIndent: 20,
                            thickness: 3.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          ListView.builder(
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
                          ),
                        ],
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
