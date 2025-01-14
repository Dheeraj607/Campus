import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mini/constants.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _noti = [];
  String formatDate(String dateTime) {
  try {
    DateTime parsedDate = DateTime.parse(dateTime);

    // Add 5 hours and 30 minutes to the parsed date
    parsedDate = parsedDate.add(Duration(hours: 5, minutes: 30));

    // Format the updated date
    return DateFormat('MMM dd, yyyy - hh:mm a').format(parsedDate);
  } catch (e) {
    return 'Invalid Date'; // Fallback if date parsing fails
  }
}
  @override
  void initState() {
    super.initState();
    _fetchNoti();
  }

  Future<void> _fetchNoti() async {
    try {
      final response = await http.get(Uri.parse('$kBaseurl/notifications/'));
      if (response.statusCode == 200) {
        setState(() {
          _noti = json.decode(response.body);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: _noti.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _noti.length,
              itemBuilder: (context, index) {
                final noti = _noti[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 80, 79, 79),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Icon(
                      Icons.notifications,
                      color: Colors.amber,
                    ),
                    title: Text(
                      '${noti['message']}',
                      style: TextStyle(
                        color: noti['type'] == 0
                            ? const Color.fromARGB(255, 242, 114, 105)
                            : const Color.fromARGB(255, 144, 234, 147),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      formatDate(noti['date_created']),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    // trailing: Icon(
                    //   Icons.delete,
                    //   color: Colors.red,
                    // ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Color(0xFF222222),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            title: Text(
                              'Notification Details',
                              style: TextStyle(
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              '${noti['message']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text(
                                  'Close',
                                  style: TextStyle(color: Colors.amber),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
