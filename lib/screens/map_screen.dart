import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _launchURL();
      //   },
      //   child: Icon(Icons.location_on_rounded),
      // ),
      appBar: AppBar(
        title: Text('Campus Map'),
      ),
      body: Center(
        child: InteractiveViewer(
          clipBehavior: Clip.none,
          boundaryMargin: EdgeInsets.all(10.0),
          minScale: 0.5,
          maxScale: 4.0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                height: constraints.maxHeight,
                width: double.infinity,
                child: Image.asset(
                  'images/map4.jpg',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _launchURL() async {
  final Uri uri = Uri.parse('https://www.google.com/');
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print('Could not launch $uri');
  }
}

}
