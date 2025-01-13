import 'package:flutter/material.dart';
import 'package:mini/screens/calender.dart';
import 'package:mini/screens/payment.dart';
import '../screens/map_screen.dart';
import '../screens/events_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/admin_panel_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
            },
          ),
          
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Calender'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EventCalendarScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Admin Panel'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPanelScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}
