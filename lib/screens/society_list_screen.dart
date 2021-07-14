import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/widgets/society_item.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/theme_provider.dart';

class SocietyListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(societiesCollection)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          var societiesData = snapshot.data.docs;

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                      child: Text(
                        'Societies',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(160.0, 20, 20, 10),
                        child: IconButton(
                          icon: themeProvider.isDarkTheme
                              ? Icon(
                                  Icons.light_mode,
                                  color: Colors.yellow,
                                )
                              : Icon(
                                  Icons.dark_mode,
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
                  itemBuilder: (ctx, index) => SocietyItem(
                    myColor:
                        index % 2 == 0 ? Colors.blueAccent : Colors.redAccent,
                    societyName: societiesData[index][societyName],
                    societyLogo: societiesData[index][societyLogo],
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
