import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventTitle;
  final String date;
  final String location;

  const EventCard({super.key, required this.eventTitle, required this.date, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(eventTitle),
        subtitle: Text('$date - $location'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to event details screen
        },
      ),
    );
  }
}
