import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/event_item.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventArgs = ModalRoute.of(context)!.settings.arguments as EventItem;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(eventArgs.eventTitle),
      // ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 17),
              child: Text(
                eventArgs.eventTitle,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
            ),
            Divider(
              // indent: 20,
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
