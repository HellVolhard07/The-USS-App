import 'package:flutter/material.dart';
import 'package:the_uss_project/widgets/event_item.dart';

import '../widgets/sliver_header.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventArgs = ModalRoute.of(context)!.settings.arguments as EventItem;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            sliverHeader(
              eventArgs.eventTitle,
              eventArgs.eventPosterUrl,
            ),
          ],
        ),
      ),
    );
  }
}
