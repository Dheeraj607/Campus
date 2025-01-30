import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/ForgotPasswordScreen.dart'; // Fixed typo in import

void main() {
  runApp(const CampusApp()); // Added 'const' for better optimization
}

class CampusApp extends StatelessWidget {
  const CampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Events',
      initialRoute: '/', // Correct use of initialRoute
      routes: {
        '/': (context) => const LoginScreen(), // Added const for StatelessWidget
        '/home': (context) => const HomeScreen(), // Added const
        '/signup': (context) => const SignUpScreen(), // Added const
        '/add-event': (context) => const AddEventScreen(), // Added const
        '/forgot-password': (context) => const ForgotPasswordScreen(), // Added const and fixed route name
      },
    );
  }
}
