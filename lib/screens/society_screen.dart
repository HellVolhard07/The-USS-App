import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/society_item.dart';

class SocietyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final societyArgs =
        ModalRoute.of(context)!.settings.arguments as SocietyItem;

    return Scaffold(
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
  }
}
