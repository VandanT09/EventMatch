import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  // 🔹 Reference to current user's notifications subcollection
  CollectionReference<Map<String, dynamic>> getUserNotificationsRef() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications');
  }

  // 🔹 Mark a specific notification as read
  Future<void> markAsRead(String docId) async {
    await getUserNotificationsRef().doc(docId).update({'read': true});
  }

  // 🔹 Delete all notifications
  Future<void> clearNotifications() async {
    final querySnapshot = await getUserNotificationsRef().get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // 🔐 Show message if user is not logged in
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please log in to view notifications."),
        ),
      );
    }

    final notificationsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final confirm = await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Clear All Notifications?"),
                  content: const Text(
                      "This will permanently remove all notifications."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Clear")),
                  ],
                ),
              );

              if (confirm == true) {
                final querySnapshot = await notificationsRef.get();
                for (var doc in querySnapshot.docs) {
                  await doc.reference.delete();
                }
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream:
            notificationsRef.orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No new notifications!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final notification = docs[index].data();
              final docId = docs[index].id;

              return ListTile(
                leading: notification['read'] == true
                    ? const Icon(Icons.notifications_none, color: Colors.grey)
                    : const Icon(Icons.notifications_active,
                        color: Colors.blue),
                title: Text(
                  notification['title'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(notification['message'] ?? ''),
                trailing: notification['read'] == true
                    ? null
                    : IconButton(
                        icon:
                            const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () async {
                          await notificationsRef
                              .doc(docId)
                              .update({'read': true});
                        },
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
