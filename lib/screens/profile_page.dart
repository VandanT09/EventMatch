import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'videos_page.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';
import 'my_events_page.dart';
import 'notifications_page.dart';
import 'invite_feature.dart';
import 'calender_page.dart';
import 'help_feedback_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 3;
  String username = "Loading...";
  String bio = "Loading profile...";
  List<String> interests = [];
  List<String> eventPreferences = [];
  File? _profileImage;
  List<Map<String, dynamic>> bookmarkedEvents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookmarkedEvents();
    fetchUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserProfile(); // call a method to fetch and set profile info
  }

  void _loadUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data();
      if (data != null && mounted) {
        setState(() {
          username = data['user'] ?? 'Pranjal';
          bio = data['bio'] ?? '';
          interests = List<String>.from(data['interests'] ?? []);
          eventPreferences = List<String>.from(data['eventPreferences'] ?? []);
          // Load profile image if stored
          // _profileImage = File.fromUri(...); if needed
        });
      }
    }
  }

  Future<void> fetchUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          setState(() {
            // Make sure we're getting the name the user entered during signup
            username = userData['displayName'] ?? userData['name'] ?? "Pranjal";

            // Print to debug what's actually being retrieved
            print('Retrieved displayName: Pranjal');
            print('Retrieved name: Pranjal');

            // Rest of your code remains the same
            bio = userData['bio'] ?? generateBio(userData);

            // Get event preferences directly from user data
            if (userData['eventPreferences'] != null) {
              eventPreferences =
                  List<String>.from(userData['eventPreferences']);
            } else if (userData['interests'] != null) {
              eventPreferences = List<String>.from(userData['interests']);
            }

            if (userData['interests'] != null) {
              interests = List<String>.from(userData['interests']);
            }
          });
        }
      } else {
        // If user document doesn't exist yet, create a default one
        createDefaultUserProfile(uid);
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Generate a bio based on user data
  String generateBio(Map<String, dynamic> userData) {
    String generatedBio = "Hi, I'm ";

    // Add name
    // Add name
    generatedBio += userData['displayName'] ?? userData['name'] ?? "a user";

    // Add location if available
    if (userData['location'] != null &&
        userData['location'].toString().isNotEmpty) {
      generatedBio += " from ${userData['location']}";
    }

    // Add age if available
    if (userData['age'] != null) {
      generatedBio += ", ${userData['age']}";
    }

    // Add interests/preferences
    if (userData['eventPreferences'] != null &&
        (userData['eventPreferences'] as List).isNotEmpty) {
      List<String> prefs = List<String>.from(userData['eventPreferences']);
      if (prefs.length > 2) {
        generatedBio +=
            ". I'm interested in ${prefs[0]}, ${prefs[1]}, and more!";
      } else if (prefs.length == 2) {
        generatedBio += ". I'm interested in ${prefs[0]} and ${prefs[1]}!";
      } else if (prefs.length == 1) {
        generatedBio += ". I'm interested in ${prefs[0]}!";
      }
    } else if (userData['interests'] != null &&
        (userData['interests'] as List).isNotEmpty) {
      List<String> intrsts = List<String>.from(userData['interests']);
      if (intrsts.length > 2) {
        generatedBio +=
            ". I'm interested in ${intrsts[0]}, ${intrsts[1]}, and more!";
      } else if (intrsts.length == 2) {
        generatedBio += ". I'm interested in ${intrsts[0]} and ${intrsts[1]}!";
      } else if (intrsts.length == 1) {
        generatedBio += ". I'm interested in ${intrsts[0]}!";
      }
    }

    // Add a friendly ending
    generatedBio += " Looking forward to connecting at events!";

    return generatedBio;
  }

  // Create a default user profile if none exists
  Future<void> createDefaultUserProfile(String uid) async {
    // Get the current user from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get display name from Firebase Auth or use a default
    String displayName = user.displayName ?? "User";

    // Create default data
    final userData = {
      'displayName': displayName,
      'name': displayName, // Make sure both fields are consistent
      'email': user.email,
      'bio':
          "Hi! I'm new to EventMatch and looking forward to discovering events!",
      'interests': [],
      'eventPreferences': [],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    // Save to Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(userData, SetOptions(merge: true));

    // Update the state
    setState(() {
      username = displayName;
      bio = userData['bio']?.toString() ?? '';
      interests = [];
      eventPreferences = [];
    });
  }

  // Modify fetchBookmarkedEvents() in ProfilePage to include more debugging
  Future<void> fetchBookmarkedEvents() async {
    setState(() {
      _isLoading = true;
    });

    print("Fetching bookmarked events...");
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Add a print statement to see the collection path
      print("Checking collection: users/$uid/bookmarkedEvents");

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('bookmarkedEvents')
          .orderBy('bookmarkedAt', descending: true)
          .get();

      print("Query returned ${snapshot.docs.length} documents");

      final fetched = snapshot.docs.map((doc) {
        print("Document ID: ${doc.id}, Data: ${doc.data()}");
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      setState(() {
        bookmarkedEvents = fetched;
        _isLoading = false;
      });

      print("Fetched ${fetched.length} bookmarked events.");
      if (fetched.isNotEmpty) {
        print("First event: ${fetched[0]}");
      }
    } catch (e) {
      print('Error fetching bookmarked events: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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

    if (result != null && mounted) {
      setState(() {
        username = result['username'] ?? username;
        bio = result['bio'] ?? bio;
        interests = List<String>.from(result['interests'] ?? interests);
        eventPreferences = List<String>.from(result['interests'] ?? interests);

        if (result['image'] != null) {
          _profileImage = File(result['image'].path);
        }
      });

      try {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'displayName': username,
            'user': username,
            'bio': bio,
            'interests': interests,
            'eventPreferences': interests,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (e) {
        print("Failed to update profile: $e");
        // Optionally show a snackbar or alert
      }
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("You have been logged out."),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pushReplacementNamed(context, '/auth');
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await fetchBookmarkedEvents();
                await fetchUserProfile();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileSection(),
                    _buildBioSection(),
                    _buildEditProfileButton(),
                    _buildEventPreferencesSection(),
                    _buildQuickActions(),
                  ],
                ),
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
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black87),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/EventMatch_Adobe.png',
                    height: 80, width: 80, fit: BoxFit.contain),
                const SizedBox(height: 10),
                const Text(
                  'EventMatch',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Calendar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CalendarPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text('Invite Friends'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const InvitePage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Help & Feedback'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HelpAndFeedbackPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? ClipOval(
                        child: Image.network(
                          'https://picsum.photos/200',
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person,
                                size: 60, color: Colors.grey);
                          },
                        ),
                      )
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            username,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).cardColor,
      child: Center(
        child: Text(
          bio,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            // Using Theme.of(context) to dynamically set text color based on theme
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton(
        onPressed: _editProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text("Edit Profile",
            style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }

  Widget _buildEventPreferencesSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Event Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          eventPreferences.isEmpty
              ? const Text("No preferences set yet",
                  style: TextStyle(color: Colors.grey, fontSize: 14))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: eventPreferences
                      .map((pref) => _buildChip(pref, Colors.blue.shade100))
                      .toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Chip(
      label: Text(label),
      backgroundColor: color,
      labelStyle: const TextStyle(color: Colors.black),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
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
              if (_isLoading) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Loading your events, please wait...")),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MyEventsPage(myEvents: bookmarkedEvents),
                  ),
                ).then((_) {
                  // Refresh events when returning from MyEventsPage
                  fetchBookmarkedEvents();
                });
              }
            },
          ),
          _buildActionButton(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationsPage()));
            },
          ),
        ],
      ),
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
}
