import 'dart:io';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'videos_page.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';
import 'my_events_page.dart'; // Import MyEventsPage
import 'notifications_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;

  String username = "John Doe";
  String bio = "Looking for outdoor adventures and live music events! 🎵 🏃‍♂️";
  List<String> interests = [
    "Live Music",
    "Hiking",
    "Food Festivals",
    "Tech Meetups",
    "Sports Events"
  ];
  int eventsAttended = 15;
  int upcomingEvents = 3;
  File? _profileImage;

  List<Map<String, dynamic>> myEvents = [
    {
      "title": "Rock Concert",
      "date": "Feb 20, 2025",
      "location": "Madison Square Garden",
      "booked": false,
      "bookmarked": false, // New field for bookmarking
    },
    {
      "title": "Tech Conference",
      "date": "March 10, 2025",
      "location": "Silicon Valley",
      "booked": true,
      "bookmarked": false,
    },
    {
      "title": "Food Festival",
      "date": "April 5, 2025",
      "location": "Central Park",
      "booked": false,
      "bookmarked": false,
    },
  ];

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          currentUsername: username,
          currentBio: bio,
          currentInterests: interests,
          profileImage: _profileImage?.path ?? 'https://picsum.photos/200',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        username = result['username'];
        bio = result['bio'];
        interests = List<String>.from(result['interests']);
        if (result['image'] != null) {
          _profileImage = File(result['image'].path);
        }
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SearchPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const VideosPage()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Function to toggle bookmark status
  void _toggleBookmark(int index) {
    setState(() {
      myEvents[index]["bookmarked"] = !myEvents[index]["bookmarked"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(),
            _buildEventPreferencesSection(),
            _buildQuickActions(),
            _buildMyEventsSection(), // Displaying the events
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library_outlined), label: 'Videos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!) as ImageProvider
                    : const NetworkImage('https://picsum.photos/200'),
              ),
              CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  onPressed: _editProfile,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(username,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(bio,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _editProfile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventPreferencesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Event Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests
                .map((interest) => _buildInterestChip(interest))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildActionButton(
              icon: Icons.calendar_today,
              label: 'My Events',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyEventsPage(myEvents: myEvents)),
                );
              }),
          _buildActionButton(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.withOpacity(0.1),
      labelStyle: const TextStyle(color: Colors.blue),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildActionButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  // Displaying the events section with "Bookmark" functionality
  Widget _buildMyEventsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Events",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            itemCount: myEvents.length,
            itemBuilder: (context, index) {
              var event = myEvents[index];
              return ListTile(
                title: Text(event["title"]),
                subtitle: Text('${event["date"]} at ${event["location"]}'),
                trailing: IconButton(
                  icon: Icon(
                    event["bookmarked"]
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: Colors.blue,
                  ),
                  onPressed: () =>
                      _toggleBookmark(index), // Use the already defined method
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
