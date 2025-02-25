import 'package:flutter/material.dart';

class HelpAndFeedbackPage extends StatelessWidget {
  const HelpAndFeedbackPage({Key? key}) : super(key: key);

  void _showEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text('You can reach us at:\nsupport@eventmatch.com'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Feedback'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // FAQ Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExpandableCard(
            'How do I create an event?',
            'To create an event, go to the Calendar page and tap the + button. Fill in the event details like title, date, time, and description.',
          ),
          _buildExpandableCard(
            'How do I invite friends?',
            'You can invite friends by sharing the event link or using the Invite Friends option in the side menu.',
          ),
          _buildExpandableCard(
            'How do I change my profile?',
            'Go to Profile page from the bottom navigation bar and tap the Edit Profile button to update your information.',
          ),

          const SizedBox(height: 24),

          // Contact Support Section
          const Text(
            'Contact Support',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Support'),
              subtitle: const Text('Get help from our support team'),
              onTap: () => _showEmailDialog(context),
            ),
          ),

          const SizedBox(height: 24),

          // Feedback Section
          const Text(
            'Send Feedback',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      labelText: 'Your Feedback',
                      hintText: 'Tell us what you think about the app...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thank you for your feedback!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text('Submit Feedback'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // App Info Section
          const Text(
            'App Information',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('EventMatch',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Version: 1.0.0'),
                  SizedBox(height: 4),
                  Text('© 2025 EventMatch. All rights reserved.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(title),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(content),
          ),
        ],
      ),
    );
  }
}
