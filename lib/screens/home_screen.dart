import 'package:flutter/material.dart';
import 'package:mini/screens/chatscreen.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Navigator'),
      ),
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
        child: Icon(Icons.chat),
      ),
      body: Center(
        child: Text('Welcome to Campus Navigator App!'),
      ),
    );
  }
}
