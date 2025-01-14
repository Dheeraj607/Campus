import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:mini/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestCreatePage extends StatefulWidget {
  @override
  _RequestCreatePageState createState() => _RequestCreatePageState();
}

class _RequestCreatePageState extends State<RequestCreatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _reqFromController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _fromTimeController = TextEditingController();
  TextEditingController _toTimeController = TextEditingController();
  
  Future<String> getShUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? admin =
        prefs.getString('username') ?? "false"; // Default to false if not set
    print('Is Admin: $admin');
    return admin;
  }
  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      // Data to send to the API
      String user=await getShUser();
      final requestData = {
        'req_from': user,
        'message': _messageController.text,
        'date': _dateController.text,
        'from_time': _fromTimeController.text,
        'to_time': _toTimeController.text,
      };

      try {
        final response = await http.post(
          Uri.parse('$kBaseurl/req_create/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestData),
        );
        print(response.body);
        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody['message'])),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create request')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      _dateController.text = pickedDate.toIso8601String().split('T').first;
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime != null) {
    // Convert TimeOfDay to hh:mm:ss format
    final now = DateTime.now();
    final formattedTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    ).toIso8601String().split('T')[1].split('.')[0]; // hh:mm:ss format
    controller.text = formattedTime;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Date Picker
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // From Time Picker
              TextFormField(
                controller: _fromTimeController,
                decoration: InputDecoration(
                  labelText: 'From Time',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _fromTimeController),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a start time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // To Time Picker
              TextFormField(
                controller: _toTimeController,
                decoration: InputDecoration(
                  labelText: 'To Time',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, _toTimeController),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an end time';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text('Submit Request'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
