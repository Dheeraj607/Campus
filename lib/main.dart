import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/add_event_screen.dart';

void main() {
  runApp(CampusApp());
}

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Navigator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xff090c22),
        appBarTheme: AppBarTheme(
          color: Color(0xff090c22),
          
        )
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/add-event': (context) => AddEventScreen(),
      },
    );
  }
}