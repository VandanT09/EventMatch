import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark Theme
      appBar: AppBar(
        backgroundColor: Colors.black, // Simple black app bar
        elevation: 0, // Removes shadow for a clean look
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to EventMatch!',
              style: TextStyle(
                fontSize: 24, // Bigger font size
                fontWeight: FontWeight.bold, // Bold text
                color: Colors.white, // White color
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'EventMatch is your ultimate platform for discovering and booking tickets for events tailored to your preferences. '
              'With an innovative swipe-based interface inspired by Tinder and the convenience of BookMyShow’s booking system, '
              'EventMatch ensures a seamless and engaging experience. Find concerts, sports events, and entertainment shows effortlessly!',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const Text(
              'App Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            buildInfoRow(Icons.email, 'eventrockzz@gmail.com'),
            buildInfoRow(Icons.phone, '+91 7678003930'),
            buildInfoRow(Icons.language, 'www.eventmatch.com/EventMatch'),
            buildInfoRow(Icons.download, 'To be downloaded...'),
            buildInfoRow(Icons.calendar_today, 'Joined March 15, 2025'),
            buildInfoRow(Icons.public, 'India'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(fontSize: 16, color: Colors.white70)),
        ],
      ),
    );
  }
}
