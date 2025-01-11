import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/rendering.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchURL();
        },
        child: Icon(Icons.location_on_rounded),
      ),
      appBar: AppBar(
        title: Text('Campus Map'),
      ),
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(10.0), // Add margin for overflow
          minScale: 0.5, // Minimum zoom level (50%)
          maxScale: 4.0, // Maximum zoom level (400%)
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight, // Use available height
                width: double.infinity, // Use full width
                child: Image.asset(
                  'images/map2.png', // Replace with your static map image path
                  fit: BoxFit.cover, // Fill the container while maintaining aspect ratio
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  void _launchURL() async {
  final Uri uri = Uri.parse('https://www.google.com');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print('Could not launch http://www.example.com');
  }
}

}


