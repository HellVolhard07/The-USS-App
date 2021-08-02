import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/widgets/about_society_widget.dart';
import 'package:the_uss_project/widgets/event_society_widget.dart';
import 'package:the_uss_project/widgets/sliver_header.dart';
import 'package:the_uss_project/widgets/society_item.dart';
import 'package:the_uss_project/widgets/team_members_widget.dart';

import '../constants.dart';
import '../theme_provider.dart';

List societyWidgets = [
  AboutSocietyWidget(),
  EventSocietyWidget(),
  TeamMembers(),
];

Widget finalWidget = AboutSocietyWidget();

class SocietyScreen extends StatefulWidget {
  @override
  State<SocietyScreen> createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  @override
  void initState() {
    finalWidget = AboutSocietyWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;

    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            sliverHeader(
                context, societyArgs.societyName, societyArgs.societyLogo),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: mediaQuery.height * 0.025,
                          bottom: mediaQuery.height * 0.01,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: mediaQuery.height*0.025,
                            ),
                            Center(
                              child: FlutterToggleTab(
                                width: mediaQuery.width*0.16,
                                borderRadius: 15,
                                labels: ['', '', ''],
                                icons: [Icons.info, Icons.list, Icons.people],
                                initialIndex: 0,
                                selectedLabelIndex: (index) {
                                  print(index);
                                  setState(() {
                                    finalWidget = societyWidgets[index];
                                  });
                                },
                                selectedTextStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                                unSelectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                selectedBackgroundColors:
                                    themeProvider.isDarkTheme
                                        ? kDarkThemeSelectedToggleColors
                                        : kLightThemeSelectedToggleColors,
                                unSelectedBackgroundColors:
                                    themeProvider.isDarkTheme
                                        ? kDarkThemeUnselectedToggleColors
                                        : kLightThemeUnselectedToggleColors,
                              ),
                            ),
                            SizedBox(
                              height: mediaQuery.height*0.025,
                            ),
                            Padding(
                              padding: EdgeInsets.all(mediaQuery.width / 20),
                              child: finalWidget,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
