import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/constants.dart';
import './event_details.dart';
import './edit_event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final response = await http.get(Uri.parse('$kBaseurl/api/events'));
      if (response.statusCode == 200) {
        setState(() {
          _events = json.decode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load events.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteEvent(String eventId) async {
  try {
    final response = await http.delete(Uri.parse('$kBaseurl/api/events/$eventId/'));
    if (response.statusCode == 200) {
      // Reload the events after deletion
      await _fetchEvents();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  Future<void> _updateEvent(String eventId) async {
    // Navigate to an Update Event screen (you can implement the screen separately)
    // Pass the event details for editing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Update functionality not implemented yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Events'),
    ),
    body: _events.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    if (event['image'] != null)
                      Image.network(
                        event['image'],
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ListTile(
                      title: Text(event['title'] ?? 'No Title'),
                      subtitle: Text('${event['date']} - ${event['location']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEvent(event: event,id:event['id']),
                          ),
                        ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteEvent(event['id'].toString()),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailsScreen(event: event),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
  );
}

}
