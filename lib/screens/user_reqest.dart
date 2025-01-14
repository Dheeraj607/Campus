import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini/constants.dart';
import 'dart:convert';

import 'package:mini/screens/add_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRequestPage extends StatefulWidget {
  const UserRequestPage({super.key});

  @override
  _UserRequestPageState createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  List<Map<String, dynamic>> requests = [];
  bool isLoading = true;
  Future<String> getShUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? admin =
        prefs.getString('username') ?? "false"; // Default to false if not set
    print('Is Admin: $admin');
    return admin;
  }

  @override
  void initState() {
    super.initState();
    _fetchRequests();
  }

  Future<void> _fetchRequests() async {
  try {
    String user2 = await getShUser();
    final response = await http.get(
      Uri.parse('$kBaseurl/req_list_user/$user2'), // Replace with your API endpoint
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> requestsData = data['req'];  // Access 'req' field here

      setState(() {
        requests = requestsData.map((e) => e as Map<String, dynamic>).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load requests');
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Messages'),
      ),
      floatingActionButton: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequestCreatePage()),
          );
        },
        icon: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final request = requests[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${request['date']} at ${request['from_time']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            request['status'] != 0?
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Admin"),
                                    content: Text(request['replay'] ?? 'No message'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'View Message',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ):SizedBox(),
                            Text(request['status'] == 0 ? 'Pending' : request['status'] == 1 ?'Approved':'Rejected',
                              style: TextStyle(
                                color: request['status'] == 0 ? Colors.red : request['status'] == 1 ?Colors.green:Colors.red,
                                
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
