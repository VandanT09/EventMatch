import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  const HelpAndFeedbackPage({super.key});

  @override
  State<HelpAndFeedbackPage> createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();

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

  Future<void> _submitFeedback() async {
    final feedback = _feedbackController.text.trim();

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some feedback.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to send feedback.'),
        ),
      );
      return;
    }

    // Immediately show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback submitted successfully!')),
    );

    _feedbackController.clear(); // Clear input right away

    // Save feedback to Firestore in the background
    try {
      await FirebaseFirestore.instance.collection('user_feedback').add({
        'uid': uid,
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving feedback: $e'); // Log error, but don't show user
    }
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
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildExpandableCard(
            'How do I create an event?',
            'To create an event, go to the Calendar page and tap the + button...',
          ),
          _buildExpandableCard(
            'How do I invite friends?',
            'You can invite friends by sharing the event link or using the Invite Friends option...',
          ),
          _buildExpandableCard(
            'How do I change my profile?',
            'Go to Profile page and tap the Edit Profile button to update your info.',
          ),
          const SizedBox(height: 24),
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
          const Text(
            'Send Feedback',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      labelText: 'Your Feedback',
                      hintText: 'Tell us what you think about the app...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitFeedback,
                    child: const Text('Submit Feedback'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
}
