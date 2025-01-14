import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini/constants.dart';
import './event_details.dart';
import './edit_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> getSh() async {
    final prefs = await SharedPreferences.getInstance();
    bool? admin =
        prefs.getBool('admin') ?? false; // Default to false if not set
    print('Is Admin: $admin');
    return admin;
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

  void _showDeleteConfirmationDialog(String eventId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteEvent(eventId); // Call the delete function
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteEvent(String eventId) async {
    try {
      final response =
          await http.delete(Uri.parse('$kBaseurl/api/events/$eventId/'));
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
                        subtitle:
                            Text('${event['date']} - ${event['location']}'),
                        trailing: FutureBuilder<bool>(
                          future: getSh(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.blue),
                                      onPressed: null),
                                  IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: null),
                                ],
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data == true) {
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditEvent(
                                            event: event, id: event['id']),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteConfirmationDialog(
                                          event['id'].toString());
                                    },
                                  ),
                                ],
                              );
                            } else {
                              return SizedBox(); // Hide admin option if not admin
                            }
                          },
                        ),
                        onTap: () {
                          // Navigate to the details page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetailsScreen(event: event),
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
