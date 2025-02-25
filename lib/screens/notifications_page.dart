import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [
    {
      "title": "Event Reminder",
      "message": "Rock Concert is tomorrow at 7 PM!",
      "read": false
    },
    {
      "title": "Booking Confirmed",
      "message": "Your ticket for Tech Conference is confirmed.",
      "read": true
    },
    {
      "title": "New Event Added",
      "message": "A new Food Festival is happening near you!",
      "read": false
    },
  ];

  void markAsRead(int index) {
    setState(() {
      notifications[index]['read'] = true;
    });
  }

  void clearNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: clearNotifications,
          ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text("No new notifications!",
                  style: TextStyle(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: notifications[index]['read']
                      ? const Icon(Icons.notifications_none, color: Colors.grey)
                      : const Icon(Icons.notifications_active,
                          color: Colors.blue),
                  title: Text(notifications[index]['title'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notifications[index]['message']),
                  trailing: notifications[index]['read']
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.check_circle,
                              color: Colors.green),
                          onPressed: () => markAsRead(index),
                        ),
                );
              },
            ),
    );
  }
}
