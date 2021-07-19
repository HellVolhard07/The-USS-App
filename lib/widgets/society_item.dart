import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/constants.dart';
import 'package:the_uss_project/screens/society_list_screen.dart';
import 'package:the_uss_project/screens/society_screen.dart';

class SocietyItem extends StatelessWidget {
  final String societyName;
  final String societyLogo;
  final Color myColor;
  final String societyAbout;
  final societyTeam;
  // final String societyEventName;
  // final String societyEventDate;
  // final String societyEventStartTime;
  // final String societyEventEndTime;
  // final String societyEventVenue;

  SocietyItem({
    required this.societyName,
    required this.societyLogo,
    required this.myColor,
    required this.societyAbout,
    required this.societyTeam,
    // required this.societyEventDate,
    // required this.societyEventName,
    // required this.societyEventStartTime,
    // required this.societyEventEndTime,
    // required this.societyEventVenue,
  });

  @override
  Widget build(BuildContext context) {
    SharedAxisTransitionType? _transitionType =
        SharedAxisTransitionType.horizontal;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            reverseTransitionDuration: Duration(milliseconds: 800),
            settings: RouteSettings(
              arguments: SocietyItem(
                myColor: myColor,
                societyLogo: societyLogo,
                societyName: societyName,
                societyAbout: societyAbout,
                societyTeam: societyTeam,
                // societyEventDate: societyEventDate,
                // societyEventName: societyEventName,
                // societyEventStartTime: societyEventStartTime,
                // societyEventEndTime: societyEventEndTime,
                // societyEventVenue: societyEventVenue,
              ),
            ),
            transitionDuration: Duration(milliseconds: 800),
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                child: SocietyScreen(),
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: _transitionType,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            height: 120.0,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 7.0,
                  color: myColor,
                ),
              ),
              color: myColor.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(societyLogo),
                  maxRadius: 40.0,
                ),
                SizedBox(
                  width: 30.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        societyName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 120.0,
                        child: Text(
                          loremIpsum,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
