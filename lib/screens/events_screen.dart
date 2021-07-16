import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      print(loggedInSocietyName);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(eventsCollection)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                      child: Text(
                        'Upcoming Events',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                        child: IconButton(
                          icon: themeProvider.isDarkTheme
                              ? Icon(
                                  Icons.wb_twighlight,
                                  color: Colors.yellow,
                                )
                              : Icon(
                                  Icons.nights_stay_rounded,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            themeProvider
                                .changeTheme(themeProvider.isDarkTheme);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  thickness: 3.0,
                  color: Colors.deepPurpleAccent,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (ctx, index) => EventItem(
                    eventPosterUrl: eventsData[index][posterURL],
                    boxColor: index % 2 == 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.secondary,
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
          );
        },
      ),
    );
  }
}
