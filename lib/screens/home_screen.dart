import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:mini/screens/admin_requests.dart';
import 'package:mini/screens/chatscreen.dart';
import 'package:mini/screens/notifications_screen.dart';
import 'package:mini/screens/user_reqest.dart';
import '../widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  Future<bool> getSh() async {
    final prefs = await SharedPreferences.getInstance();
    bool? admin = prefs.getBool('admin') ?? false; // Default to false if not set
    print('Is Admin: $admin');
    return admin;
  }

  final List<String> _imagePaths = [
    'images/kuc1.jpeg',
    'images/kuc2.jpeg',
    'images/kuc3.jpeg',
    'images/kuc4.jpeg',
    'images/kuc5.jpeg',
    // Add more image paths
  ];

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _imagePaths.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Campus Navigator'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NotificationsScreen()),
                    );
                  },
                  icon: Icon(Icons.notifications),
                ),
                IconButton(
                  onPressed: () async {
                    bool admin = await getSh();
                    if (admin == true) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminRequestPage()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserRequestPage()),
                      );
                    }
                  },
                  icon: Icon(Icons.view_stream_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Icon(Icons.chat),
      ),
      body: SingleChildScrollView(  // Wrap body with SingleChildScrollView
        child: Column(
          children: [
            Image.asset('images/ku.png'),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 300, // Adjust height as needed to fit the images
              child: PageView.builder(
                controller: _pageController,
                itemCount: _imagePaths.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    _imagePaths[index],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Kannur University",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Kannur University was established by the Act 22 of 1996 of Kerala Legislative Assembly. The University, by the name 'Malabar University', had come into existence earlier by the promulgation of an Ordinance by the Governor of Kerala, on 9th November 1995. The University was inaugurated on 2nd March 1996 by the then Chief Minister of Kerala, Sri. A.K. Antony.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "The objective of the Kannur University Act 1996 is to establish in the Kerala state, a teaching, residential and affiliating University, promoting the development of higher education in Kasargod and Kannur revenue Districts and the Mananthavady Taluk of Wayanad District.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Kannur University is unique in the sense that it is a multi-campus university with campuses spread over at various locations under its jurisdiction. The Act envisages that the University shall establish, maintain, manage and develop campuses at Kannur, Kasaragod, Nileswaram, Mangattuparamba, Mananthavady, Payyannur, Thalassery, and such other places as are necessary for providing study and research facilities to promote advanced knowledge in Science and Technology and other relevant disciplines.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "About Our App",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "This app is designed to streamline and enhance the organization and participation in campus events. It aims to connect students, faculty, and staff with campus activities, fostering a vibrant and engaging community.",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
