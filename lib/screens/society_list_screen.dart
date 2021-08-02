import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/theme_provider.dart';
import 'package:the_uss_project/widgets/society_item.dart';

var societiesData;

class SocietyListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection(societiesCollection).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          societiesData = snapshot.data.docs;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  // padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                  padding: EdgeInsets.fromLTRB(
                    mediaQuery.width * 0.05,
                    mediaQuery.height * 0.02,
                    mediaQuery.width * 0.05,
                    mediaQuery.height * 0.02,
                  ),
                  child: Text(
                    'Societies',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: themeProvider.isDarkTheme
                          ? Color(0xffD59B78)
                          : Color(0xffcd885f),
                    ),
                  ),
                ),
                Divider(
                  indent: mediaQuery.width * 0.05,
                  endIndent: mediaQuery.width * 0.05,
                  thickness: 2.0,
                  color: themeProvider.isDarkTheme
                      ? Color(0xffD59B78)
                      : Color(0xffcd885f),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (ctx, index) => SocietyItem(
                    myColor: index % 2 == 0
                        ? themeProvider.isDarkTheme
                            ? Color(0xfff2d6b3)
                            : Color(0xffffd8b1)
                        : themeProvider.isDarkTheme
                            ? Color(0xffD59B78)
                            : Color(0xffffcc99),
                    societyName: societiesData[index][societyName],
                    societyLogo: societiesData[index][societyLogo],
                    societyAbout: societiesData[index][societyAbout],
                    societyTeam: societiesData[index][societyTeam],
                    societyKeEvents: societiesData[index][societyKeEvents],
                  ),
                  itemCount: societiesData.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
