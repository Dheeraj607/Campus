import 'package:flutter/material.dart';
import 'package:mini/screens/calender.dart';
import 'package:mini/screens/list_users.dart';
import '../screens/map_screen.dart';
import '../screens/events_screen.dart';
import '../screens/admin_panel_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Method to retrieve data
  Future<bool> getSh() async {
    final prefs = await SharedPreferences.getInstance();
    bool? admin =
        prefs.getBool('admin') ?? false; // Default to false if not set
    print('Is Admin: $admin');
    return admin;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 20, 7, 197),
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Campus Map'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Calender'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventCalendarScreen()));
            },
          ),
          FutureBuilder<bool>(
            future: getSh(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Admin Panel'),
                      onTap: null, // Disable tap while waiting for data
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('User List'),
                      onTap: null, // Disable tap while waiting for data
                    ),
                  ],
                );
              } else if (snapshot.hasData && snapshot.data == true) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.admin_panel_settings),
                      title: Text('Admin Panel'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminPanelScreen()));
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.people),
                      title: Text('User List'),
                      onTap: (){
                        {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserListingPage()));
                      }
                      }, // Disable tap while waiting for data
                    ),
                  ],
                );
              } else {
                return SizedBox(); // Hide admin option if not admin
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Deletes all saved data

              // Alternatively, remove specific keys:
              // await prefs.remove('admin');
              // await prefs.remove('someOtherKey');

              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
