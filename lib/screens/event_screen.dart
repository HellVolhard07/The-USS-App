import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/event_item.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventArgs = ModalRoute.of(context)!.settings.arguments as EventItem;
    return Scaffold(
      appBar: AppBar(
        title: Text(eventArgs.eventTitle),
      ),
    );
  }
}
