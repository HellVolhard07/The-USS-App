import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:provider/provider.dart';
import 'package:the_uss_project/screens/profile_screen.dart';
import 'package:the_uss_project/widgets/about_profile_widget.dart';
import 'package:the_uss_project/widgets/about_society_widget.dart';
import 'package:the_uss_project/widgets/event_profile_widget.dart';
import 'package:the_uss_project/widgets/event_society_widget.dart';
import 'package:the_uss_project/widgets/sliver_header.dart';
import 'package:the_uss_project/widgets/society_item.dart';
import 'package:the_uss_project/widgets/team_members_widget.dart';
import '../constants.dart';
import '../theme_provider.dart';
import 'society_list_screen.dart';

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
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            sliverHeader(societyArgs.societyName, societyArgs.societyLogo),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 24.0, bottom: 10.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: FlutterToggleTab(
                                width: 60,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                                unSelectedTextStyle: TextStyle(
                                  color: Colors.black,
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
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
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