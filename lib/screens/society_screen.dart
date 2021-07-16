import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/sliver_header.dart';
import 'package:the_uss_project/widgets/society_item.dart';

class SocietyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  return Container(
                    margin: EdgeInsets.only(top: 24.0, bottom: 10.0),
                    child: Column(
                      children: [
                        MaterialButton(
                          elevation: 5.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.1,
                            decoration: BoxDecoration(
                              color: Color(0xFF00BDBD).withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "$index",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 15, 0, 5),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(societyArgs.societyLogo),
                    maxRadius: 30.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 15),
                  child: Text(
                    societyArgs.societyName,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
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
          ],
        ),
      ),
    );
*/
