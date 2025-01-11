import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['title'] ?? 'Event Details'),
        backgroundColor: Theme.of(context).primaryColor, // Set app bar color
      ),
      body: SingleChildScrollView(
        // Allow scrolling for long descriptions
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event['image'] != null)
              Hero(
                tag: event['id'] ??
                    'default_event_image', // Set unique tag for hero animation
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(16.0), // Rounded corners for image
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.network(
                        event['image'],
                        width: constraints.maxWidth, // Use the available width
                        fit: BoxFit.contain, // Maintain aspect ratio
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: 16.0),
            Text(
              event['title'] ?? 'No Title',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    // Use headline5 with custom font size if needed
                    fontSize: 24.0, // Adjust font size as desired
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.grey), // Add calendar icon
                SizedBox(width: 8.0),
                Text(
                  'Date: ${event['date']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on,
                    color: Colors.grey), // Add location icon
                SizedBox(width: 8.0),
                Text(
                  'Location: ${event['location']}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8.0),
            Text(
              event['description'] ?? 'No description available',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    height: 1.5, // Adjust line spacing for better readability
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
