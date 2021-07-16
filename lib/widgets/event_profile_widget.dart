import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_uss_project/theme_provider.dart';

import 'auth.dart';
import 'event_item.dart';

class EventWidget extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: societyEvents.length,
      itemBuilder: (context, index) {
        return EventItem(
            eventPosterUrl: societyEvents[index]['poster'],
            boxColor: index % 2 == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            eventId: societyEvents[index]['eventId'],
            aboutEvent: societyEvents[index]['aboutEvent'],
            eventDate: societyEvents[index]['date'],
            eventStartTime: societyEvents[index]['startTime'],
            eventTitle: societyEvents[index]['title'],
            eventVenue: societyEvents[index]['venue']);
      },
    );
  }
}
